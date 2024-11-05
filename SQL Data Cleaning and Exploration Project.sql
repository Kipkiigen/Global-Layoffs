-- Data Cleaning

select *
from layoffs;

-- Creating a new table to do edits
create table layoffs_staging
like layoffs;

insert layoffs_staging
select *
from layoffs;

-- Data cleaning steps
-- 1. Check for duplicates and remove any
-- 2. Standardize data and fix errors
-- 3. Look at null values and see what 
-- 4. Remove any columns and rows that are not necessary 


-- 1. Remove Duplicates
 
 #Checking for duplicates
 
 select *
 from layoffs_staging;
 
select *,
row_number() over(
partition by company,location, industry,total_laid_off,percentage_laid_off,`date`,stage, country,funds_raised_millions) as row_num
from layoffs_staging;

with duplicate_cte as
(
select *,
row_number() over(
partition by company,location, industry,total_laid_off,percentage_laid_off,`date`,stage, country,funds_raised_millions) as row_num
from layoffs_staging
)
delete
from duplicate_cte
where row_num > 1;

# Creating a new table and deleting duplicates  
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoffs_staging2
(
select *,
row_number() over(
partition by company,location, industry,total_laid_off,percentage_laid_off,`date`,stage, country,funds_raised_millions) as row_num
from layoffs_staging
);

delete 
from layoffs_staging2
where row_num > 1;

select * 
from layoffs_staging2;

-- 2. Standardize the Data
select *
from layoffs_staging2;

select company, trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select  *
from layoffs_staging2
where industry like 'Crypto%';

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

select distinct country,trim(trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%';

# Converting date to date format
select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

alter table layoffs_staging2
modify column `date` date;

-- 3. Null values/ Blank values

update layoffs_staging2
set industry = null
where industry = '';

select *
from layoffs_staging2
where industry is null ;

select *
from layoffs_staging2
where company = 'Airbnb';

select *
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
where t1.industry is null 
and t2.industry is not null;
 
 update layoffs_staging2 t1
 join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
 where t1.industry is null 
 and t2.industry is not null;
 
-- 4. Remove any Columns

select*
from layoffs_staging2;

select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

alter table layoffs_staging2
drop column row_num;




-- Exploratory Data Analysis

select * 
from layoffs_staging2;

select max(total_laid_off)
from layoffs_staging2;

-- Looking at Percentage to see how big these layoffs were
select max(percentage_laid_off),  min(percentage_laid_off)
from layoffs_staging2
where  percentage_laid_off is not null;

-- Which companies had 100 percent of the company laid off
select *
from layoffs_staging2
where percentage_laid_off = 1;

-- How big were the companies that laid of all their employees
select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions DESC;

-- Companies with the total largest layoff
select company, total_laid_off
from layoffs_staging2
order by 2 desc
limit 5;

-- Companies with the most total layoffs
select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc
limit 10;

-- By location
select location, sum(total_laid_off)
from layoffs_staging2
group by location
order by 2 desc
limit 10;


-- Countries with the largest layoffs
select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

-- Total laid off each year
select year(date), sum(total_laid_off)
from layoffs_staging2
group by year(date)
order by 1 asc;


-- 	Total laid off in each industry
select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;


-- -- 	Total laid off in each funding stage
select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;


-- Ranking of company layoffs per year
with Company_Year as 
(
  select year(date) as years, sum(total_laid_off) as total_laid_off,company
  from layoffs_staging2
  group by company, year(date)
)
,Company_Year_Rank as (
  select company, years, total_laid_off, dense_rank() over (partition by years order by total_laid_off desc) as ranking
 from Company_Year
)
select company, years, total_laid_off, ranking
from Company_Year_Rank
where ranking <= 3
and years is not null
order by years asc, total_laid_off desc;




-- Rolling total of layoffs per month
select substring(date,1,7) as `month`, sum(total_laid_off) AS total_laid_off
from layoffs_staging2
where substring(date,1,7) is not null
group by `month`
order by `month` asc;


with date_cte as 
(
select substring(date,1,7) as `month`, sum(total_laid_off) AS total_laid_off
from layoffs_staging2
where substring(date,1,7) is not null
group by `month`
order by 1 asc
)
select `month`, total_laid_off, sum(total_laid_off) over (order by `month` asc) as rolling_total_layoffs
from date_cte
order by `month` asc;




