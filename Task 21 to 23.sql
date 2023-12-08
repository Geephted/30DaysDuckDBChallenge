
--Task 1: Survival based on Cabin Level

WITH CabinLevels AS 
	(SELECT Ticket,
        MAX(CASE WHEN Cabin IS NOT NULL THEN SUBSTRING(Cabin FROM 1 FOR 1) ELSE 'Unknown' END) AS Cabin_Levels
    FROM
        Train 
    GROUP BY
        Ticket)
SELECT
    COUNT(*) AS Number_Of_Passengers,
   Round(AVG(Survived), 2) AS Survival_Rate,
    Cabin_Levels
FROM
    CabinLevels
JOIN
   Train ON CabinLevels.Ticket = train.Ticket
GROUP BY
    Cabin_Levels
ORDER BY Cabin_Levels;  
 

--Task 2: Categorize passengers into Solo Travelers, Family Travelers, and Mix Group

WITH PassengerGroups AS 
	(SELECT
        Ticket,
        SUBSTRING(Name FROM 1 FOR POSITION(',' IN Name) - 1) AS Surname,
        COUNT(*) OVER (PARTITION BY Ticket) AS PassengerCount
    FROM
        Train)
SELECT
    Ticket,
    Surname,
    CASE
        WHEN PassengerCount = 1 THEN 'Solo Traveler'
        WHEN MAX(PassengerCount) OVER (PARTITION BY Surname) > 1 THEN 'Family Traveler'
        ELSE 'Mixed Group'
    END AS TravelGroup
FROM
    PassengerGroups
--ORDER BY TravelGroup;


    
    
    
--Task 3: Family Size Calculation

SELECT
    Ticket,
    SUBSTRING(Name FROM 1 FOR POSITION(',' IN Name) - 1) AS Surname,
    CASE
        WHEN COUNT(*) OVER (PARTITION BY Ticket, SUBSTRING(Name FROM 1 FOR POSITION(',' IN Name) - 1)) = 1 THEN 1
        ELSE MAX(SibSp + Parch + 1) OVER (PARTITION BY Ticket, SUBSTRING(Name FROM 1 FOR POSITION(',' IN Name) - 1))
    END AS FamilySize
FROM
    Train;