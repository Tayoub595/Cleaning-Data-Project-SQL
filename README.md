# Cleaning-Data-Project-SQL
This project focuses on cleaning and standardizing a dataset of company layoffs. It involves removing duplicates, trimming and standardizing text fields, converting dates, and handling NULL values. The aim is to ensure data integrity and consistency for accurate analysis and reporting.
## Table of Contents

- [Table Creation](#table-creation)
- [Removing Duplicates](#removing-duplicates)
- [Standardizing Data](#standardizing-data)
- [Handling NULL Values](#handling-null-values)


## Table Creation

The script begins by creating a table named `Layoffs` with the following columns:
- `company`: Name of the company
- `location`: Location of the company
- `industry`: Industry of the company
- `total_laid_off`: Total number of employees laid off
- `percentage_laid_off`: Percentage of employees laid off
- `date`: Date of the layoffs
- `stage`: Stage of the layoffs
- `country`: Country of the company
- `funds_raised_millions`: Funds raised by the company in millions

```sql
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
