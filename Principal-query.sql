-- Create the Layoffs table
CREATE TABLE Layoffs (
    company NVARCHAR(255),
    location NVARCHAR(255),
    industry NVARCHAR(255),
    total_laid_off FLOAT,
    percentage_laid_off FLOAT,
    date DATE,
    stage NVARCHAR(255),
    country NVARCHAR(255),
    funds_raised_millions FLOAT
);


Select company from Layoffs
Where company is not NULL

-- Select all data from Layoffs table
SELECT * FROM Layoffs;

-- 1. Remove Duplicates
-- Select all columns and add a row number based on duplicate criteria
SELECT *,
ROW_NUMBER() OVER(
    PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date) AS row_num 
FROM layoffs_staging_2;

-- Create a common table expression (CTE) to identify duplicates
WITH duplicate_cte AS 
(
    SELECT *, 
    ROW_NUMBER() OVER(
        PARTITION BY company, [location], industry, total_laid_off, percentage_laid_off, [date], funds_raised_millions ORDER BY company) AS row_num 
    FROM layoffs_staging_2
)
-- Select duplicates
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

-- Add row_num column to layoffs_staging table
ALTER TABLE layoffs_staging
ADD row_num INT;

-- Insert data into layoffs_staging with row numbers for duplicates
INSERT INTO layoffs_staging
SELECT *, ROW_NUMBER() OVER(
    PARTITION BY company, [location], industry, total_laid_off, percentage_laid_off, [date], funds_raised_millions ORDER BY company) AS row_num 
FROM layoffs_staging_2;

-- Select duplicates from layoffs_staging
SELECT * FROM layoffs_staging
WHERE row_num > 1;

-- Delete duplicates from layoffs_staging
DELETE FROM layoffs_staging
WHERE row_num > 1;

-- Standardizing data

-- Trim whitespace from company names
UPDATE layoffs_staging
SET company = TRIM(company);

-- Select industries starting with 'Crypto'
SELECT industry FROM layoffs_staging
WHERE industry LIKE 'Crypto%';

-- Standardize 'Crypto' industry values
UPDATE layoffs_staging
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Trim trailing periods from country names
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging WHERE country LIKE 'United%'
ORDER BY 1;

-- Update country names to remove trailing periods
UPDATE layoffs_staging 
SET country = TRIM(TRAILING '.' FROM country);

-- Add a new column for standardized dates
ALTER TABLE layoffs_staging 
ADD new_date_column DATETIME;

-- Convert date column to DATETIME format
UPDATE layoffs_staging
SET new_date_column = CONVERT(DATETIME, [date], 120)
WHERE TRY_CONVERT(DATETIME, [date], 120) IS NOT NULL;

-- Select all data from layoffs_staging
SELECT * FROM layoffs_staging;

-- Select records where company names start with 'Bally'
SELECT * FROM layoffs_staging WHERE company LIKE 'Bally%';

-- Set industry to NULL where it's empty
UPDATE layoffs_staging
SET industry = NULL
WHERE industry = '';

-- Select records to fill NULL industry values based on matching companies
SELECT t1.industry, t2.industry
FROM layoffs_staging t1
JOIN layoffs_staging t2
    ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND (t2.industry IS NOT NULL AND t2.industry != '');

-- Update NULL industry values with matching non-NULL values from the same company
UPDATE t1 SET t1.industry = t2.industry 
FROM layoffs_staging t1
JOIN layoffs_staging t2
    ON t1.company = t2.company
WHERE (t1.industry IS NULL AND t2.industry IS NOT NULL);

-- Set total_laid_off to NULL where it's 'NULL'
UPDATE layoffs_staging
SET total_laid_off = NULL
WHERE total_laid_off = 'NULL';

-- Set percentage_laid_off to NULL where it's 'NULL'
UPDATE layoffs_staging
SET percentage_laid_off = NULL
WHERE percentage_laid_off = 'NULL';

-- Select all data from layoffs_staging
SELECT * FROM layoffs_staging;

-- Delete records where both total_laid_off and percentage_laid_off are NULL
DELETE FROM layoffs_staging WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

-- Drop the row_num column from layoffs_staging
ALTER TABLE layoffs_staging
DROP COLUMN row_num;
