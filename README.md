# SQL-Data-Cleaning-and-Exploratory-Data-Analysis-EDA---Layoffs-Dataset

**Project Overview**

  This project demonstrates a complete SQL workflow for cleaning and analyzing a real-world layoffs dataset using MySQL. 
  The raw dataset was transformed into a clean and analysis-ready table through data validation, standardization, and handling of missing values before performing exploratory data analysis (EDA) to uncover trends and        business insights.
  
The project is divided into two main phases:

    •	Data Cleaning
    •	Exploratory Data Analysis (EDA)
    
**Tools Used**

    •	MySQL – Data cleaning, transformation, and analysis
    •	DBeaver – Database management and SQL query execution
    •	GitHub – Version control and project documentation

**Dataset**

The dataset was obtained from Kaggle and contains real-world layoff records from 2020 to 2026.

**Table Used**

    Layoffs
    
    The dataset contains the following information:
    
    •	Company
    •	Location
    •	Total Laid Off
    •	Date
    •	Percentage Laid Off
    •	Industry
    •	Funding Stage
    •	Funds Raised
    •	Country
    •	Date Added

**SQL Skills Demonstrated**

Throughout this project, I applied the following SQL concepts:

    •	Table creation and data preparation
    •	Duplicate identification using window functions
    •	Handling NULL and missing values
    •	Data standardization
    •	Data validation
    •	Data type conversion
    •	Common Table Expressions (CTEs)
    •	Window Functions
      o	ROW_NUMBER()
      o	DENSE_RANK()
      o	Running Totals
    •	Aggregate Functions
    •	Date Functions
    •	Trend Analysis
    •	Ranking and Segmentation

**Data Cleaning**

Objective

Transform the raw layoffs dataset into a clean and reliable dataset suitable for analysis.
Cleaning Process

The following data quality checks and transformations were performed:

    •	Created a separate working table to preserve the raw dataset
    •	Identified duplicate records
    •	Handled missing and NULL values
    •	Standardized data formats
    •	Validated date formats
    •	Converted columns to appropriate data types
    •	Removed unnecessary rows and columns
    •	Performed final data quality validation

**Exploratory Data Analysis (EDA)**

Objective

Analyze the cleaned dataset to identify layoff trends, company performance, and geographical patterns.

**Business Questions Answered**

    •	How many unique companies are included in the dataset?
    •	What were the minimum and maximum layoffs recorded each year?
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

**Key Findings**

    •	The dataset covers 2,289 days of layoff activity with a total of 924,670 employees laid off.
    •	2023 recorded the highest number of layoffs, accounting for 28.72% of all reported layoffs.
    •	Amazon, Intel, Meta, Oracle, and Microsoft experienced the highest total number of layoffs.
    •	The United States accounted for 71.15% of all layoffs in the dataset.
    •	The Other industry recorded the highest number of layoffs, followed by the Retail and Hardware industries.
    •	The San Francisco Bay Area recorded the highest number of layoffs, representing 34.56% of total layoffs.
    •	Companies in the Post-IPO funding stage accounted for 63.23% of all layoffs.

**Repository Structure**

    Layoffs-SQL-Project
    │
    ├── SQL Files
    │   ├── data_cleaning.sql
    │   └── exploratory_data_analysis.sql
    │
    ├── Tables Used
    │   └── layoffs1.csv
    │   └── layoffs_cleaning.csv
    │
    ├── Screenshots
    │   └── (project screenshots)
    │
    └── README.md

**What I Learned**

Through this project, I strengthened my ability to:

    •	Clean messy datasets using SQL
    •	Perform data validation and quality checks
    •	Handle missing data appropriately
    •	Apply window functions to solve analytical problems
    •	Conduct exploratory data analysis using SQL
    •	Translate business questions into SQL queries
    •	Document assumptions made during data cleaning

Author

**Bryan Rafael Eniego**

Aspiring Data Analyst | Petroleum Engineer

Skills: SQL • MySQL • Data Analytics
