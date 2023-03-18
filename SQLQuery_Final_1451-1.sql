CREATE TABLE PRESCRIPTION (
ACCOUNT_NO VARCHAR(30) PRIMARY KEY,
DRUGNAME VARCHAR(30),
COST INTEGER,
DOSAGE REAL,
TAKE_INSTRUCTIONS VARCHAR(30)
);

SELECT * FROM PRESCRIPTION

BULK INSERT PRESCRIPTION FROM 'C:\Users\emc166\Downloads\final_exam_rx.txt'
WITH(FIELDTERMINATOR = '\t', ROWTERMINATOR = '\n') 

-- 2a. Write one query to return DISTINCT drugs and take instructions Prior to going any further make sure you note which drugs are taken multiple times a day. Basically, what I’m telling you is that some drugs in your table have different dosage instructions, meaning, you have to remember that to plug in your formula above, when you begin writing your SQL. For example, “Every 8 hours” = 3 times taken per day.
SELECT DISTINCT DRUGNAME, TAKE_INSTRUCTIONS
FROM PRESCRIPTION

-- 2b. Add a new column to your table called freq_per_day. 
ALTER TABLE PRESCRIPTION
ADD FREQ_PER_DAY INTEGER

-- 2c. Write an update statement with a CASE statement to set freq_per_day equal to the amount the drug needs to be take per day. Use the query in part a above to figure out all the different “take instructions” variations.
UPDATE PRESCRIPTION
SET FREQ_PER_DAY = CASE
		WHEN TAKE_INSTRUCTIONS = 'Every 8 hours' THEN '3'
		WHEN TAKE_INSTRUCTIONS = 'Every 6 hours' THEN '4'
		WHEN TAKE_INSTRUCTIONS = 'Every 4 hours' THEN '6'
		WHEN TAKE_INSTRUCTIONS = 'Every hour' THEN '24'
		WHEN TAKE_INSTRUCTIONS = 'Once Daily' THEN '1'
		WHEN TAKE_INSTRUCTIONS = 'Twice Daily' THEN '2'
	END
FROM PRESCRIPTION 

-- 2d. Using the conversion chart in this week’s module. Write a query to figure out MME/day for each patients MME for ('OxyContin','Oxymorphone','Hydrocodone','Codeine') HINT: You will be writing one big CASE statement as part of your query. 
ALTER TABLE PRESCRIPTION
ADD MME VARCHAR(10)

UPDATE PRESCRIPTION
SET MME = CASE
		WHEN DRUGNAME = 'OxyContin' AND FREQ_PER_DAY = '4' AND DOSAGE = '5' THEN '30'
		WHEN DRUGNAME = 'OxyContin' AND FREQ_PER_DAY = '4' AND DOSAGE = '10' THEN '60'
		WHEN DRUGNAME = 'OxyContin' AND FREQ_PER_DAY = '4' AND DOSAGE = '15' THEN '90'
		WHEN DRUGNAME = 'OxyContin' AND FREQ_PER_DAY = '4' AND DOSAGE = '20' THEN '120'
		WHEN DRUGNAME = 'OxyContin' AND FREQ_PER_DAY = '3' AND DOSAGE = '20' THEN '90'
		WHEN DRUGNAME = 'Oxymorphone' AND FREQ_PER_DAY = '1' AND DOSAGE = '7.5' THEN '22.5'
		WHEN DRUGNAME = 'Hydrocodone' AND FREQ_PER_DAY = '1' AND DOSAGE = '20' THEN '20'
		WHEN DRUGNAME = 'Hydrocodone' AND FREQ_PER_DAY = '2' AND DOSAGE = '15' THEN '30'
		WHEN DRUGNAME = 'Hydrocodone' AND FREQ_PER_DAY = '2' AND DOSAGE = '20' THEN '40'
		WHEN DRUGNAME = 'Hydrocodone' AND FREQ_PER_DAY = '2' AND DOSAGE = '25' THEN '50'
		WHEN DRUGNAME = 'Hydrocodone' AND FREQ_PER_DAY = '2' AND DOSAGE = '30' THEN '60'
		WHEN DRUGNAME = 'Codeine' AND FREQ_PER_DAY = '3' AND DOSAGE = '15' THEN '6.75'
		WHEN DRUGNAME = 'Codeine' AND FREQ_PER_DAY = '3' AND DOSAGE = '30' THEN '13.50'
		WHEN DRUGNAME = 'Codeine' AND FREQ_PER_DAY = '3' AND DOSAGE = '65' THEN '29.25'
		WHEN DRUGNAME = 'Codeine' AND FREQ_PER_DAY = '4' AND DOSAGE = '15' THEN '9' 
	END
FROM PRESCRIPTION 

-- 2e. Write the same query as part d above, but sum MME by drugname. Show a screenshot of the output with your code. 
SELECT 
DRUGNAME, SUM(CASE
		WHEN DRUGNAME = 'OxyContin' THEN DOSAGE * FREQ_PER_DAY * 1.5
		WHEN DRUGNAME = 'Oxymorphone' THEN DOSAGE * FREQ_PER_DAY * 3
		WHEN DRUGNAME = 'Codeine' THEN DOSAGE * FREQ_PER_DAY * 0.15
		WHEN DRUGNAME = 'Hydrocodone' THEN DOSAGE * FREQ_PER_DAY * 1
		ELSE 0
END) AS SUM_MME
FROM PRESCRIPTION
GROUP BY DRUGNAME

-- 2f. What is the total drug cost by drugname by admit_year (sort descending by total cost)? 
SELECT SUM(COST) TOTAL_DRUG_COST, DRUGNAME, ADMIT_YEAR
FROM PRESCRIPTION P 
INNER JOIN ADMISSION A
ON P.ACCOUNT_NO = A.ACCOUNT_NUMBER
GROUP BY DRUGNAME, ADMIT_YEAR, COST
ORDER BY COST DESC

-- 2g. What is the frequency distribution of patients taking drugs (drugname)? 
SELECT DRUGNAME, COUNT(ACCOUNT_NO)DISTRIBUTION_TAKING_DRUGS
FROM PRESCRIPTION
GROUP BY DRUGNAME

-- 2h. Using your substance abuse table from a few weeks ago. Are there any patients on OxyContin that have a prior history of overdose? (Write the code) 
SELECT PRIOR_HIST_SUBSTANCE, P.ACCOUNT_NO, DRUGNAME
FROM PRESCRIPTION P
INNER JOIN SUBSTANCE_ABUSE S
ON P.ACCOUNT_NO = S.ACCOUNT_NO
WHERE S.PRIOR_HIST_OVERDOSE = 'YES' AND P.DRUGNAME = 'OxyContin' 
