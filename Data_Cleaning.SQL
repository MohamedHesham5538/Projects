
-- DATA CLEANING
select *
from layoffs;

-- 1. remove dublicates
-- 2. standarize the date
-- 3. null values blank values
-- 4. remove any columns OR rows

create table layoffs_staging
like layoffs;

select *
from layoffs_staging;
insert layoffs_staging
select *
from layoffs;

select *,
row_number() over(
partition by company, industry,total_laid_off,percentage_laid_off, `date`) as row_num
from layoffs_staging;

with duplicate_CTE as
( 
select *,
row_number() over(
partition by company,location, industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoffs_staging
)
delete 
from duplicate_cte
where row_num > 1;



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

select *
from layoffs_staging2
where row_num >1;
insert into layoffs_staging2
select *,
row_number() over(
partition by company,location, industry,total_laid_off,percentage_laid_off, `date`,stage,country,funds_raised_millions) as row_num
from layoffs_staging;

delete
from layoffs_staging2
where row_num >1;
select*
from layoffs_staging2
;


-- standardizing data

select company,trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select distinct industry
from layoffs_staging2;
 
 
 update layoffs_staging2
 set industry = 'crypto'
 where industry like 'crypto%';
 
 select * 
 from layoffs_staging2
 where country like 'united state%'
 order by 1;
 
 select distinct country, trim(trailing'.' from country)
 from layoffs_staging2
 order by 1;
 
 update layoffs_staging2
 set country = trim(trailing'.' from country)
 where country like 'united state%';
 
 
 
 
 
 -- change date from text to date
 select `date`
 from layoffs_staging2;
 
 
 update layoffs_staging2
 set `date` = str_to_date (`date` , '%m/%d/%Y');
 
 alter table layoffs_staging2
 modify column `date` date;
 
 
 
 
 
 -- null values blank values
 
 select *
 from layoffs_staging2
 where total_laid_off is null 
 and percentage_laid_off is null;
 
 update layoffs_staging2
 SET industry = NULL 
 WHERE industry = '';
 
 select *
  from layoffs_staging2
where industry is null 
or industry = '';


 select *
  from layoffs_staging2
  where company LIKE 'BALLY%';

 select T1.INDUSTRY,T2.INDUSTRY
  from layoffs_staging2 T1
  JOIN layoffs_staging2 T2
  ON T1.COMPANY = T2.COMPANY
  WHERE (T1.INDUSTRY IS NULL OR T1.INDUSTRY ='')
  AND T2.INDUSTRY IS NOT NULL;
  
  UPDATE layoffs_staging2 T1
  JOIN  layoffs_staging2 T2
	ON T1.COMPANY = T2.COMPANY
    SET T1.INDUSTRY = T2.INDUSTRY
   WHERE (T1.INDUSTRY IS NULL OR T1.INDUSTRY ='')
  AND T2.INDUSTRY IS NOT NULL;
 
 
  select *
  from layoffs_staging2
  WHERE total_laid_off IS NULL
  AND percentage_laid_offNIS IS NULL;
  
  delete 
  FROM layoffs_staging2
  WHERE  total_laid_off IS NULL
    AND percentage_laid_offNIS IS NULL;
  select* 
  FROM layoffs_staging2;
  
  ALTER table layoffs_staging2
  DROP COLUMN row_num; 
  
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
