SELECT * FROM read_csv_auto('C:\Users\HP\Desktop\DA Training\Duckdb Challenge\Dataset\Test.csv');
CREATE TABLE Test AS SELECT * FROM read_csv_auto('C:\Users\HP\Desktop\DA Training\Duckdb Challenge\Dataset\Test.csv');

SELECT * FROM read_csv_auto('C:\Users\HP\Desktop\DA Training\Duckdb Challenge\Dataset\Train.csv');
CREATE TABLE Train AS SELECT * FROM read_csv_auto('C:\Users\HP\Desktop\DA Training\Duckdb Challenge\Dataset\Train.csv');

SELECT * FROM read_csv_auto('C:\Users\HP\Desktop\DA Training\Duckdb Challenge\Dataset\gender_submission.csv');
CREATE TABLE Gender AS SELECT * FROM read_csv_auto('C:\Users\HP\Desktop\DA Training\Duckdb Challenge\Dataset\gender_submission.csv');


SELECT * FROM Train 
SELECT * FROM Test 
SELECT * FROM Gender 

--QUESTION 1
--Perform an analysis of survival rates based on fare in the Titanic dataset. Utilize the ntile window function to evenly bucket 
--passengers into 6 bins. Calculate statistics for each bin, including survival rates. Examine if there is a correlation between fare amounts 
--and survival. Note any inconsistencies or noise in the fare column and present your findings.

-- Step 1: Create fare bins
CREATE VIEW Tem_Table AS
SELECT 
	T.PassengerId, 
	T.Fare, 
	G.Survived, 
	NITLE (6) OVER (ORDER BY T.Fare) AS FareBin, 
FROM Test T JOIN Gender G ON T.passengerid = G.passengerid LEFT JOIN Train T2 ON G.Survived = T2.Survived;

-- Step 2: Calculate survival rates
SELECT
  FareBin,
  COUNT(*) AS Total_Passengers,
  SUM(Survived) AS Survived,
  AVG(Survived) AS Survival_Rate,
  MIN(Fare) AS MinFare,
  MAX(Fare) AS MaxFare,
  Round(SUM (fare)) AS Fare_Amount
FROM
  Tem_Table
GROUP BY
  FareBin
ORDER BY
  FareBin;
 
 --QUESTION 2
--Conduct an analysis of survival rates based on sex in the Titanic dataset. Calculate the percentage of passengers who survived versus those
--who did not survive, focusing on the distinction between males and females. Express the survival rates and highlight any significant differences
--in survival ratios between genders. (use subqueries for higher marks)
 

 -- Calculate the total number of passengers for each gender
WITH GenderCounts AS
	(SELECT 
		T2.Sex, 
		COUNT(*) AS Total_Passengers
     FROM Test T JOIN Gender G ON T.passengerid = G.passengerid LEFT JOIN Train T2 ON G.Survived = T2.Survived
     GROUP BY T2.Sex),

-- Calculate the number of survivors for each gender
SurvivorCounts AS 
     (SELECT 
     	T2.Sex, 
     	COUNT(*) AS Total_Survivors
      FROM Test T JOIN Gender G ON T.passengerid = G.passengerid LEFT JOIN Train T2 ON G.Survived = T2.Survived
      WHERE G.Survived = 1
      GROUP BY T2.Sex)

-- Combine the counts and calculate survival rates
SELECT
    G.Sex,
    G.Total_Passengers,
    S.Total_Survivors,
    S.Total_Survivors * 100.0 / G.Total_Passengers AS Survival_Rate
FROM
    GenderCounts AS G
JOIN
    SurvivorCounts AS S ON G.Sex = S.Sex;

 
   --QUESTION 3
   --Explore the relationship between survival and age in the Titanic dataset. Calculate the survival rate for different age groups,
   --providing insights into how age correlates with the likelihood of survival. Consider any notable patterns or trends in survival based on age.
   
   -- Create age groups  
   CREATE VIEW age_groups AS
SELECT
    CASE
        WHEN T.Age < 18 THEN '0-17'
        WHEN T.Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN T.Age BETWEEN 31 AND 50 THEN '31-50'
        WHEN T.Age > 50 THEN '50+'
        ELSE 'Unknown'
    END AS AgeGroup,
    T2.Survived
FROM
   Test T JOIN Gender G ON T.passengerid = G.passengerid LEFT JOIN Train T2 ON G.Survived = T2.Survived
   
-- Calculate survival rates for each age group
SELECT
    AgeGroup,
    COUNT(*) AS Total_Passengers,
    SUM(Survived) AS Total_Survivors,
    AVG(Survived) AS Survival_Rate
FROM
    Age_groups
GROUP BY
    AgeGroup
ORDER BY
    AgeGroup;

 
 
