/*
===============================================================================
Exploratory Data Analysis
===============================================================================

Purpose: 
	- To perform exploratory data analysis on the cleaned layoffs dataset.
	
Highlights:

		1. Layoffs overview
		2. Layoffs trend analysis (Yearly and Monthly)
		3. Monthly rolling total
		4. Top 5 companies that have the highest layoffs
		5. Top companies per year
		6. Top 5 companies that have the highest percentage layoffs
		7. Total layoffs by country
		8. Total layoffs by industry
		9. Total layoffs by location
		10. Total layoffs by stages

Business Questions Answered:
		•	How many unique companies are included in the dataset?
		•	Which year recorded the highest number of layoffs?
		•	What is the monthly layoff trend?
		•	What is the monthly rolling total of layoffs?
		•	Which companies experienced the highest number of layoffs?
		•	Which companies had the highest layoff percentages?
		•	Which companies recorded the highest layoffs each year?
		•	Which countries experienced the highest layoffs?
		•	Which industries were most affected?
		•	Which locations recorded the highest layoffs?
		•	Which funding stages experienced the highest layoffs?
		
===============================================================================
*/

-- ============================================================================
-- 1. LAYOFFS OVERVIEW
-- ============================================================================

SELECT 
	COUNT(DISTINCT company) AS unique_companies,
	SUM(total_laid_off) AS overall_layoffs,
	MAX(total_laid_off) AS max_layoffs,
	MIN(total_laid_off) AS min_layoffs,
	MAX(`date`) AS max_date,
	MIN(`date`) AS min_date,
	DATEDIFF(MAX(`date`), MIN(`date`)) AS layoffs_duration_days
FROM layoffs_cleaning;
	
 -- ============================================================================
-- 2. LAYOFFS TREND ANALYSIS (YEARLY AND MONTHLY)
-- =============================================================================

-- Yearly
WITH pct AS
(
SELECT 
	YEAR(`date`) AS date_year,
	SUM(total_laid_off) AS layoffs_per_year
FROM layoffs_cleaning
GROUP BY date_year
)
SELECT *,
	SUM(layoffs_per_year) OVER() AS total_layoffs,
	ROUND(layoffs_per_year*100/SUM(layoffs_per_year) OVER(), 2) AS dist_pct
FROM pct
ORDER BY date_year;

WITH rolling_total AS
(
-- Monthly
SELECT 
	DATE_FORMAT(`date`, '%Y-%m-01') AS date_month,
	SUM(total_laid_off) AS layoffs_per_month
FROM layoffs_cleaning
GROUP BY date_month
)
SELECT 
	date_month,
	layoffs_per_month,
-- ============================================================================
-- 3. MONTHLY ROLLING TOTAL
-- ============================================================================
	SUM(layoffs_per_month) OVER(PARTITION BY YEAR(date_month) ORDER BY date_month) AS rolling_layoffs_total
FROM rolling_total;

-- =============================================================================
-- 4. TOP 5 COMPANIES THAT HAVE THE HIGHEST LAID OFF
-- =============================================================================

SELECT 
	company,
	SUM(total_laid_off) AS layoffs_per_company
FROM layoffs_cleaning 
GROUP BY company
ORDER BY layoffs_per_company DESC
LIMIT 5;

-- =============================================================================
-- 5. TOP 5 COMPANIES PER YEAR
-- =============================================================================

WITH ranking_year AS 
(
SELECT 
	YEAR(`date`) AS date_year,
	company,
	SUM(total_laid_off) AS layoffs_per_year
FROM layoffs_cleaning
GROUP BY date_year, company
),
top_rank AS
(
SELECT 
	date_year,
	company,
	layoffs_per_year,
	DENSE_RANK() OVER(PARTITION BY date_year ORDER BY layoffs_per_year DESC) AS ranking
FROM ranking_year
)
SELECT *
FROM top_rank
WHERE ranking <= 5;

-- =============================================================================
-- 6. TOP 5 COMPANIES THAT HAVE THE HIGHEST PERCENTAGE LAYOFFS
-- =============================================================================

SELECT 
	company,
	MAX(percentage_laid_off) AS max_pct_layoffs
FROM layoffs_cleaning
GROUP BY company
ORDER BY max_pct_layoffs DESC
LIMIT 5;

-- =============================================================================
-- 7. TOTAL LAYOFFS BY COUNTRY
-- =============================================================================

WITH pct_country AS
(
SELECT
	country,
	SUM(total_laid_off) AS layoffs_per_country
FROM layoffs_cleaning
WHERE country IS NOT NULL
GROUP BY country
HAVING layoffs_per_country IS NOT NULL
)
SELECT *,
	SUM(layoffs_per_country) OVER() AS total_layoffs,
	ROUND(layoffs_per_country*100/SUM(layoffs_per_country) OVER(), 2) AS dist_pct
FROM pct_country
ORDER BY dist_pct DESC;

-- =============================================================================
-- 8. TOTAL LAYOFFS BY INDUSTRY
-- =============================================================================

SELECT
	industry,
	SUM(total_laid_off) AS layoffs_per_industry
FROM layoffs_cleaning
GROUP BY industry
ORDER BY layoffs_per_industry DESC;

-- =============================================================================
-- 9. TOTAL LAYOFFS BY LOCATION
-- =============================================================================
WITH loc_pct AS
(
SELECT
	location,
	SUM(total_laid_off) AS layoffs_per_location
FROM layoffs_cleaning
GROUP BY location
)
SELECT *,
	SUM(layoffs_per_location) OVER() AS total_layoffs,
	ROUND(layoffs_per_location*100/SUM(layoffs_per_location) OVER(), 2) AS dist_pct
FROM loc_pct 
ORDER BY dist_pct DESC;

-- =============================================================================
-- 10. TOTAL LAYOFFS BY STAGE
-- =============================================================================

WITH stg_pct AS
(
SELECT
	stage,
	SUM(total_laid_off) AS layoffs_per_stage
FROM layoffs_cleaning
GROUP BY stage
)
SELECT *,
	SUM(layoffs_per_stage) OVER() AS total_layoffs,
	ROUND(layoffs_per_stage*100/SUM(layoffs_per_stage) OVER(), 2) AS dist_pct
FROM stg_pct
ORDER BY dist_pct DESC;

