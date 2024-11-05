

---

# Layoffs Data Cleaning and Exploratory Data Analysis (EDA) – A Data Analyst Showcase

## Overview

This project demonstrates my data cleaning, transformation, and exploratory data analysis (EDA) skills using a real-world layoffs dataset. By working through the steps of data preparation and analysis, I showcase my ability to:

- Clean and prepare raw data for analysis.
- Perform in-depth exploratory data analysis (EDA) to uncover insights.
- Use SQL to manipulate and analyze data efficiently.
- Present findings that provide actionable insights for decision-making.

The dataset used in this project is a collection of layoffs data, detailing the number of layoffs, company information, and related attributes. Through this project, I highlight my ability to identify patterns, trends, and relationships in data, which are critical for making data-driven decisions.

## Key Skills Demonstrated

- **Data Cleaning**: 
  - Removing duplicates, handling null and blank values, and standardizing data.
  - Data transformation (e.g., trimming whitespace, fixing inconsistent naming conventions).
  - Dropping unnecessary columns to focus on relevant data for analysis.

- **SQL Proficiency**:
  - Complex SQL queries, including `JOIN`, `GROUP BY`, `WHERE`, and `CASE` statements.
  - Window functions (e.g., `ROW_NUMBER()`, `DENSE_RANK()`) for ranking and partitioning data.
  - Date handling and aggregation (e.g., monthly and yearly data analysis).

- **Exploratory Data Analysis (EDA)**:
  - Analysis of layoffs by company, location, industry, and year.
  - Trends in the layoffs data over time (monthly, yearly).
  - Identifying the largest layoffs in terms of both total headcount and percentage of employees affected.
  - Visualizing patterns in layoffs across different industries, countries, and funding stages.

## Project Steps

### 1. Data Cleaning

The first step involved cleaning the raw data, which consisted of multiple records with potential errors or inconsistencies. The following tasks were completed:

- **Duplicate Removal**: Identified and removed duplicate records based on key fields such as `company`, `location`, `industry`, and `total_laid_off`.
  
- **Data Standardization**: 
  - Trimmed leading/trailing whitespace from text fields like `company`, `industry`, and `country`.
  - Corrected inconsistent industry names (e.g., all "Crypto" companies were grouped under one consistent name).
  - Standardized country names by removing trailing periods (e.g., "United States." became "United States").
  - Converted date fields to a consistent `DATE` format.

- **Handling Missing Values**: 
  - Filled missing `industry` values where possible by using data from other rows.
  - Removed rows with critical missing information (e.g., missing both `total_laid_off` and `percentage_laid_off`).

### 2. Exploratory Data Analysis (EDA)

After cleaning the data, I performed EDA to uncover trends and insights:

- **Total Layoffs Analysis**:
  - Identified the companies with the largest layoffs and the industries most affected.
  - Analyzed layoffs by `location`, `industry`, and `funding_stage`.

- **Yearly and Monthly Layoffs**:
  - Aggregated layoffs by year and month to identify any trends or spikes.
  - Used window functions to calculate a rolling total of layoffs over time, providing a clear view of trends.

- **Percentage of Layoffs**:
  - Analyzed companies with the highest percentage of layoffs and explored the factors driving these decisions.

- **Top Companies by Layoffs**:
  - Ranked companies by total layoffs to highlight the most significant layoffs events in the dataset.
  - Explored patterns, such as whether larger companies tend to lay off more employees or if funding stages correlate with larger layoffs.

### 3. Insights and Visualizations

In addition to SQL queries, I used the cleaned data to generate insights that can inform business decisions:

- **Insight 1: Industry Trends**: Which industries have been most affected by layoffs? How have trends evolved over time?
  
- **Insight 2: Regional Layoff Patterns**: Are layoffs concentrated in specific countries or locations? Which regions are seeing the largest layoffs?

- **Insight 3: Funding Stage Analysis**: Is there a correlation between the company's funding stage (e.g., Series A, B, etc.) and the frequency or size of layoffs?

- **Insight 4: Company-Specific Layoffs**: Which companies are laying off the most employees? What do their funding levels and stages look like?

---

## SQL Queries & Code

The following key SQL queries were used in this project:

### Remove Duplicates

```sql
WITH duplicate_cte AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS row_num
    FROM layoffs_staging
)
DELETE FROM duplicate_cte WHERE row_num > 1;
```

### Standardizing Company Names and Industry

```sql
UPDATE layoffs_staging2 SET company = TRIM(company);
UPDATE layoffs_staging2 SET industry = 'Crypto' WHERE industry LIKE 'Crypto%';
UPDATE layoffs_staging2 SET country = TRIM(TRAILING '.' FROM country) WHERE country LIKE 'United States%';
```

### Converting Date Format

```sql
UPDATE layoffs_staging2 SET date = STR_TO_DATE(date, '%m/%d/%Y');
ALTER TABLE layoffs_staging2 MODIFY COLUMN date DATE;
```

### Exploratory Data Analysis (EDA)

- **Total Laid Off by Company**

```sql
SELECT company, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY total_laid_off DESC
LIMIT 5;
```

- **Largest Layoffs by Year**

```sql
SELECT YEAR(date) AS year, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY year
ORDER BY year ASC;
```

- **Rolling Total of Layoffs by Month**

```sql
WITH date_cte AS (
    SELECT SUBSTRING(date, 1, 7) AS `month`, SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    WHERE SUBSTRING(date, 1, 7) IS NOT NULL
    GROUP BY `month`
    ORDER BY 1 ASC
)
SELECT `month`, total_laid_off, SUM(total_laid_off) OVER (ORDER BY `month` ASC) AS rolling_total_layoffs
FROM date_cte
ORDER BY `month` ASC;
```

## Results and Insights

- **Layoff Trends Over Time**: The analysis revealed that layoffs have been increasing steadily in recent years, with significant spikes during economic downturns or industry-specific shifts.
- **Industry Impact**: Certain industries (e.g., Tech, Crypto) have been disproportionately affected, with large layoffs often linked to financial instability or market shifts.
- **Regional Differences**: The US and Europe have seen the largest number of layoffs, with certain states and cities (e.g., California) particularly impacted.

---

## Conclusion

This project showcases my ability to clean and analyze data, providing meaningful insights into complex datasets. By performing data cleaning, standardization, and in-depth exploratory analysis, I demonstrate my proficiency in SQL and data manipulation techniques. These skills are essential for any data-driven decision-making process.

This project can be a valuable resource for companies looking to understand layoff trends, and I am excited to bring these skills to a full-time data analyst role.

## Contact

Feel free to reach out if you have any questions or would like to discuss my work further:

- **Email**: lbartuiyot@gmail.com
- **LinkedIn**: www.linkedin.com/in/leon-b-7b8a091b
- **GitHub**: https://github.com/Kipkiigen
