-- 1. First build the table LIFE_EXPECTANCY using above columns and make sure you have the correct datatypes.  
CREATE TABLE LIFE_EXPECTANCY ( 
ID INTEGER PRIMARY KEY,
COUNTRY VARCHAR(60), 
YEAR INTEGER,
MALE_LE_BIRTH numeric(5,2),
FEMALE_LE_BIRTH numeric(5,2),
MALE_LE_AGE60 numeric(5,2),
FEMALE_LE_AGE60 numeric(5,2),
MALE_HALE_BIRTH numeric(5,2), 
FEMALE_HALE_BIRTH numeric(5,2)
);

-- 2. Load using below bulk insert (if you run into permission errors, contact me) 
BULK INSERT LIFE_EXPECTANCY FROM 'C:\Users\emc166\Desktop\life_expectancy.txt'        
WITH(FIELDTERMINATOR = '\t', ROWTERMINATOR = '\n') 

-- 3. Once everything is loaded you might want to do a simple test to look at your data. For example, run: SELECT * FROM LIFE_EXPECTANCY.
SELECT * FROM LIFE_EXPECTANCY

-- For the questions below write the SQL. In addition to your SQL code, I want to see screenshots for the following questions below: a, b, c, e, f 

-- a. What is the female life expectancy(female_le_birth) for the USA in 2019? 
SELECT FEMALE_LE_BIRTH, COUNTRY, YEAR
FROM LIFE_EXPECTANCY
WHERE COUNTRY = 'United States of America' and YEAR = 2019 

-- b. What is the average male life expectancy (male_le_birth) in the year 2000? Hint: no need for a group by 
SELECT AVG(MALE_LE_BIRTH) MEAN_MALE_LE_BIRTH_2000 
FROM LIFE_EXPECTANCY
WHERE YEAR = 2000

-- c. What is the average female life expectancy by year?
SELECT AVG(FEMALE_LE_BIRTH) MEAN_FEMALE_LE_BIRTH, YEAR
FROM LIFE_EXPECTANCY
GROUP BY YEAR 
ORDER BY YEAR DESC 

-- d. How many different years are there by country? HINT: COUNT years and group by country 
SELECT COUNT(YEAR) DIFFERENT_YEAR_BY_COUNTRY
FROM LIFE_EXPECTANCY
GROUP BY COUNTRY

-- e. What is the average male healthy life expectancy at birth (male_hale_birth) for Canada? 
SELECT AVG(MALE_HALE_BIRTH) MEAN_MALE_HALE_BIRTH_CANADA 
FROM LIFE_EXPECTANCY
WHERE COUNTRY = 'Canada'

-- f. Are there any countries with the word “Tome” in the name? 
SELECT COUNTRY
FROM LIFE_EXPECTANCY
WHERE COUNTRY LIKE '%Tome%'

-- g. What is the average female life expectancy at age 60 (female_le_age60)? 
SELECT AVG(FEMALE_LE_AGE60) MEAN_FEMALE_LE_AGE60 
FROM LIFE_EXPECTANCY

-- h. What is the maximum male life expectancies (male_le_birth) for Ecuador by year?
SELECT MAX(MALE_LE_BIRTH) MAX_MALE_LE_BIRTH_ECUADOR, COUNTRY, YEAR 
FROM LIFE_EXPECTANCY
WHERE COUNTRY = 'Ecuador'
GROUP BY COUNTRY, YEAR

-- i. What is the average male life expectancies (male_le_birth) for Ecuador? 
SELECT AVG(MALE_LE_BIRTH) MEAN_MALE_LE_BIRTH_ECUADOR 
FROM LIFE_EXPECTANCY
WHERE COUNTRY = 'Ecuador'
