
  ---QUESTION 1:A
  ---To Identify Unique titles in the Dataset

SELECT 
	  DISTINCT SUBSTRING (Name FROM POSITION(',' IN Name) + 2 FOR POSITION('.' IN Name) - POSITION(',' IN Name) - 2) AS Title
FROM Train 

--QUESTION 1:B
--Consolidate infrequent titles into broader categories (e.g., Mr, Mrs, Miss, Master)

SELECT
    CASE
        WHEN Title IN ('Mr', 'Miss', 'Mrs', 'Master','Dr', 'Major') THEN Title
        ELSE 'Others'
    END AS Consolidated_Title,
    COUNT(*) AS Title_Numbers
FROM (SELECT SUBSTRING(Name FROM POSITION(',' IN Name) + 2 FOR POSITION('.' IN Name) - POSITION(',' IN Name) - 2) AS Title  
      FROM Train) AS titles
GROUP BY Consolidated_Title
ORDER BY Consolidated_Title ASC;

--QUESTION 1:C
--Calculate and analyze survival rates for each title grouping

WITH TitleData AS 
  (SELECT
        PassengerId,
        SUBSTRING (Name FROM POSITION(',' IN Name) + 2 FOR POSITION('.' IN Name) - POSITION(',' IN Name) - 2) AS Title
    FROM Train)
SELECT
   Title,
   Count (Survived) AS Title_Numbers, 
   Round(AVG(Survived), 1) AS Survival_Rate
FROM 
    (SELECT
        TitleData.PassengerId,
        CASE
            WHEN TitleData.Title IN ('Mr', 'Miss', 'Mrs', 'Master','Dr', 'Major') THEN TitleData.Title
            ELSE 'Others'
        END AS Title,
        Train.Survived 
    FROM TitleData
    JOIN Train ON Train.PassengerId = TitleData.PassengerId) AS T
GROUP BY Title
ORDER BY Title ASC; 


--QUESTION  2: Evaluate the insights gained from a binary feature flagging passengers as women/children or adult men.
   
   WITH AgeGroup AS 
    (SELECT
        PassengerId,
        CASE
            WHEN Age < 18 THEN 'Child'
            WHEN Sex = 'female' THEN 'Woman'
            ELSE 'Adult Men'
        END AS AgeGroup
    FROM Train)  
SELECT
    AgeGroup,
    Count (Survived) AS Numbers_of_AgeGroup, 
     SUM(Survived) AS Survived_Numbers,
    Round(AVG(Survived), 2) AS Survival_Rate     
FROM 
    (SELECT
        AgeGroup.PassengerId,
        AgeGroup.AgeGroup,
        Train.Survived
    FROM AgeGroup
    JOIN Train ON Train.PassengerId = AgeGroup.PassengerId) AS T
GROUP BY AgeGroup;






 