/*
===============================================================================
Layoffs Data Cleaning 
===============================================================================

Purpose: 
	- To clean a real layoffs dataset and transform it into a usable dataset ready for analysis.
	
Highlights:

	Data Cleaning Process
	
		1. Preparing a new table for data cleaning.
		2. Identifying and removing duplicate rows.
		3. Handling missing or NULL values.
		4. Standardizing columns.
		5. Removing rows that have multiple missing values.
		6. Final data quality check.

===============================================================================
*/

-- ============================================================================
-- 1. PREPARING A NEW TABLE FOR DATA CLEANING
-- ============================================================================
		
-- Create a separate table for data cleaning and preserve the original table.

CREATE TABLE layoffs_cleaning
LIKE layoffs1;

INSERT INTO layoffs_cleaning
SELECT *
FROM layoffs1;

-- Check whether the columns are correct and the values are inserted correctly.

SELECT *
FROM layoffs_cleaning;

-- ============================================================================
-- 2. IDENTIFYING AND REMOVING DUPLICATE ROWS
-- ============================================================================

-- Check for duplicates using CTE and Row_Number window function.

WITH duplicates AS
(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY
	company,
	location,
	total_laid_off,
	`date`,
	percentage_laid_off,
	industry,
	source,
	stage,
	funds_raised,
	country,
	date_added) AS rn
FROM layoffs_cleaning
)
SELECT *
FROM duplicates
WHERE rn > 1;

-- No duplicates found.

-- ============================================================================
-- 3. HANDLING MISSING OR NULL VALUES
-- ============================================================================

-- Check for NULL or missing values in each column.

SELECT 
	COUNT(*) AS null_or_missing
FROM layoffs_cleaning
WHERE company IS NULL
OR TRIM(company) = '';

-- No NULL or missing values found in the company column.

SELECT 
	COUNT(*) AS null_or_missing
FROM layoffs_cleaning
WHERE location IS NULL
OR TRIM(location) = '';

-- 1 row has a missing location.

-- Determine which row contains the NULL or missing value.

SELECT *
FROM layoffs_cleaning
WHERE location IS NULL
OR TRIM(location) = '';

-- Company Product Hunt does not have the location column filled. 

-- Set the location of the company Product Hunt to NULL.

UPDATE layoffs_cleaning 
SET location = NULL 
WHERE TRIM(location) = '';

-- Check again whether the missing row has been filled with a NULL value.

SELECT *
FROM layoffs_cleaning
WHERE TRIM(location) = '';

SELECT 
	COUNT(*) AS null_or_missing
FROM layoffs_cleaning
WHERE total_laid_off IS NULL
OR TRIM(total_laid_off) = '';

-- 1,541 rows have missing total_laid_off values.

-- Update the total_laid_off column. Set the missing values to NULL.

UPDATE layoffs_cleaning 
SET total_laid_off = NULL 
WHERE TRIM(total_laid_off) = '';

-- Check whether the 1,541 rows that have missing total_laid_off values have been filled with NULL values.

SELECT 
	COUNT(*) AS null_or_missing
FROM layoffs_cleaning
WHERE total_laid_off IS NULL;

SELECT 
	COUNT(*) AS null_or_missing
FROM layoffs_cleaning
WHERE `date` IS NULL
OR TRIM(`date`) = '';

-- No NULL or missing values found in the date column.

SELECT 
	COUNT(*) AS null_missing
FROM layoffs_cleaning
WHERE percentage_laid_off IS NULL
OR percentage_laid_off = '';

-- 1,663 rows have missing percentage_laid_off values.

-- Update the percentage_laid_off column. Set the missing values to NULL.

UPDATE layoffs_cleaning 
SET percentage_laid_off = NULL 
WHERE TRIM(percentage_laid_off) = '';

-- Check whether the 1,663 rows that have missing percentage_laid_off values have been filled with NULL values.

SELECT 
	COUNT(*) AS null_or_missing
FROM layoffs_cleaning
WHERE percentage_laid_off IS NULL;

SELECT 
	COUNT(*) AS null_or_missing
FROM layoffs_cleaning
WHERE industry IS NULL
OR TRIM(industry) = '';

-- 2 rows have missing industry values.

-- Determine the 2 rows that have missing industry values.

SELECT *
FROM layoffs_cleaning
WHERE TRIM(industry) = '';

-- Companies Eyeo and Appsmith does not have a corresponding industry.

-- Check whether these companies' industry column can be filled using the existing dataset.

SELECT 
	company,
	industry
FROM layoffs_cleaning 
WHERE company = 'Appsmith'
OR company = 'Eyeo';

-- The industry column for these comapanies cannot be filled using the existing dataset.

-- Fill the missing columns using verified external source.

UPDATE layoffs_cleaning 
SET industry = 'Software Development'
WHERE TRIM(industry) = ''
AND company = 'Appsmith';

-- Check whether the changes made was applied. 

SELECT 
	company,
	industry
FROM layoffs_cleaning 
WHERE company = 'Appsmith';

-- Company Eyeo is to broad and the specific industry where it belongs to can't be verfied by an external source.
-- Therefore, it will be set to NULL.

UPDATE layoffs_cleaning
SET industry = NULL
WHERE TRIM(industry) = ''
AND company = 'Eyeo';

-- Check whether the changes made was applied. 

SELECT 
	company,
	industry
FROM layoffs_cleaning 
WHERE company = 'Eyeo';

-- Check whether the 2 rows that have missing industry values have been filled with appropriate industry and NULL values.

SELECT 
	COUNT(*) AS null_or_missing
FROM layoffs_cleaning
WHERE industry IS NULL;

-- Only 1 row has a NULL value.

-- The source column does not have any potential use for further EDA or other analysis. Therefore, it will be removed from the table.

ALTER TABLE layoffs_cleaning 
DROP source;

SELECT 
	COUNT(*) AS null_or_missing
FROM layoffs_cleaning
WHERE stage IS NULL
OR TRIM(stage) = '';

-- 5 rows have missing stage values.

-- Determine the 5 rows that have missing stage values.

SELECT *
FROM layoffs_cleaning
WHERE stage IS NULL
OR TRIM(stage) = '';

-- Determine whether the companies that have missing stage values can be filled using the existing dataset. 

SELECT *
FROM layoffs_cleaning
WHERE company = 'Soundwide'
OR company = 'Advata'
OR company = 'Spreetail'
OR company = 'Gatherly'
OR company = 'Zapp';

-- The Zapp company has an existing stage, which is Series B.

-- Check whether the date when the layoff happened for the same company happened closely in time or years apart.

SELECT 
	company,
	`date`,
	stage
FROM layoffs_cleaning 
WHERE company = 'Zapp'
ORDER BY `Date`;

-- The first laid off happened in 2022, while the second happened in 2024.
-- It will not be safe to assume that years 2022 and 2024 still have the same stages.
-- Therefore, in 2022, the stage will be set to NULL and for the remaining 4 rows.

UPDATE layoffs_cleaning
SET stage = NULL
WHERE TRIM(stage) = '';

-- Check whether the 5 rows that have missing stage values have been filled with NULL values.

SELECT 
	COUNT(*) AS null_or_missing
FROM layoffs_cleaning
WHERE stage IS NULL;

SELECT 
	COUNT(*) AS null_or_missing
FROM layoffs_cleaning 
WHERE funds_raised IS NULL 
OR TRIM(funds_raised) = '';

-- 521 rows have missing funds_raised values.

-- Set those 521 rows to NULL.

UPDATE layoffs_cleaning
SET funds_raised = NULL
WHERE TRIM(funds_raised) = '';

SELECT 
	COUNT(*) AS null_or_missing
FROM layoffs_cleaning 
WHERE country IS NULL 
OR TRIM(country) = '';

-- 2 rows have missing country values.

-- Determine the 2 rows that have missing country values.

SELECT *
FROM layoffs_cleaning
WHERE TRIM(country) = '';

-- Determine whether those 2 rows can be filled using the existing dataset.

SELECT 
	company,
	country
FROM layoffs_cleaning 
WHERE company = 'Fit Analytics'
OR company = 'Ludia'

-- The two companies have unknown countries. Therefore, they will be set to NULL.

UPDATE layoffs_cleaning 
SET country = NULL
WHERE TRIM(country) = '';

-- Check whether the 2 rows that have missing stage values have been filled with NULL values.

SELECT 
	COUNT(*) AS null_or_missing
FROM layoffs_cleaning 
WHERE country IS NULL;

SELECT 
	COUNT(*) AS null_or_missing
FROM layoffs_cleaning 
WHERE date_added IS NULL 
OR TRIM(date_added) = '';

-- No NULL or missing values found in the date_added column.

-- ============================================================================
-- 4. STANDARDIZING COLUMNS 
-- ============================================================================

-- Change the data types of columns that needs to be changed.

-- Company and location columns are already in the text data type. Therefore, it doesn't need to be changed.

-- total_laid_off column is in text data type. Change it to integer.

-- Check first whether the total_laid_off column does not contain any decimal values.

SELECT *
FROM layoffs_cleaning 
WHERE total_laid_off % 1 <> 0;

-- No decimal values found in the total_laid_off column.

ALTER TABLE layoffs_cleaning 
MODIFY total_laid_off INT;

-- Check for any date format inconsistencies.

SELECT DISTINCT `date`
FROM layoffs_cleaning;

SELECT 
	`date`
FROM layoffs_cleaning 
WHERE STR_TO_DATE(`date`, '%m/%d/%Y') IS NULL
AND `date` IS NOT NULL;

-- No inconsistencies found in the date format.

-- Change the date type of date column into DATE.

UPDATE layoffs_cleaning 
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_cleaning 
MODIFY `date` DATE;

-- Change the data type of the percentage_laid_off into decimal.

-- Check first whether the percentage_laid_off contains decimal values.

SELECT DISTINCT percentage_laid_off
FROM layoffs_cleaning;

ALTER TABLE layoffs_cleaning
MODIFY percentage_laid_off DECIMAL(5, 4);

-- The industry and stage columns are already in text data type.

-- Check whether funds_raised column have any decimal value before converting it into INT data type.

SELECT *
FROM layoffs_cleaning
WHERE funds_raised % 1 <> 0;

-- Various rows have decimal values in the funds_raised column.
-- Therefore, change it into decimal data type.

ALTER TABLE layoffs_cleaning 
MODIFY funds_raised DECIMAL(10, 2);

-- Country column is already in the text data type.

-- Check for any format inconsistencies in the date_added column.

SELECT DISTINCT date_added 
FROM layoffs_cleaning;

SELECT 
	date_added
FROM layoffs_cleaning 
WHERE STR_TO_DATE(date_added, '%m/%d/%Y') IS NULL
AND date_added IS NOT NULL;

-- No format inconsistencies found in the date_added column.

-- Change the data type of the date_added column into DATE.

UPDATE layoffs_cleaning
SET date_added =  STR_TO_DATE(date_added, '%m/%d/%Y');

ALTER TABLE layoffs_cleaning
MODIFY date_added DATE;

-- ============================================================================
-- 5. REMOVING ROWS THAT HAVE MULTIPLE MISSING VALUES
-- ============================================================================

-- Check for rows that have missing total_laid off and percentage_laid off values.

SELECT COUNT(*)
FROM layoffs_cleaning
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- 727 rows have both NULL values for the total_laid_off and percentage_laid_off column.

-- These rows will be deleted from the table since they don't have any signifiance for further analysis. 

DELETE FROM layoffs_cleaning
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- ============================================================================
-- 6. FINAL DATA QUALITY CHECK
-- ============================================================================

SELECT *
FROM layoffs_cleaning;

SELECT
	COUNT(*) AS remaining_rows
FROM layoffs_cleaning;

DESCRIBE layoffs_cleaning;


