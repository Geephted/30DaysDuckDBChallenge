
--Day 6 & 7 Tasks 

--1. Identify Players who possess high value but receive relatively Low Wages

SELECT AVG(Wage) FROM fifa21_data2;

SELECT AVG(Value) FROM fifa21_data2;



SELECT Full_Name, Value, Wage 
FROM fifa21_data2 
WHERE Value >(SELECT AVG(Value) 
			  FROM fifa21_data2) 
			  AND Wage <(SELECT AVG(Wage) FROM fifa21_data2 ) 
ORDER BY Value DESC LIMIT 15;

--2. Determine the count of players avaliable in the dataset for each position

SELECT Best_Position, COUNT(Full_Name) Count_of_Players 
FROM fifa21_data2 
GROUP BY Best_Position 
ORDER BY Count_of_Players DESC;


--3. Find out which club has the largest representation of players in the dataset

SELECT Club, COUNT(Full_name) as Count_of_Players 
FROM fifa21_data2 
GROUP BY Club 
ORDER BY COUNT (Full_name) DESC 
--LIMIT 1;


--4 List the top 10 players with the highest OVA and POT values.

SELECT  Name_on_shirt, OVA, Pot 
FROM fifa21_data2
ORDER BY OVA DESC, POT DESC
LIMIT 10;



--Day 8 & 9 Tasks 


--1. Find players with the highest OVA and POT within each club.

SELECT Full_name,  Club, OVA, POT,
FROM (SELECT Club, Full_name, OVA, POT, 
     RANK() OVER (PARTITION BY Club ORDER BY OVA DESC, POT DESC) AS Player_rank 
    FROM fifa21_data2) AS RankedPlayers
WHERE Player_rank = 1 ORDER BY OVA DESC, POT DESC


--2. Calculate the average OVA for players under 25 years old and over 30 years old in each club.

SELECT Club,
       Round (AVG(CASE WHEN age < 25 THEN OVA ELSE NULL END)) Average_OVA_Under_25,
       Round (AVG(CASE WHEN age > 30 THEN OVA ELSE NULL END)) Average_OVA_Over_30
FROM fifa21_data2
GROUP BY Club
ORDER BY Average_OVA_Under_25 DESC, 
		 Average_OVA_Over_30 DESC;
		
--3. List the players who have the same age within each club.		

SELECT Club, Age, ARRAY_AGG(Full_Name) Prayers_with_Same_Age
FROM fifa21_data2
    GROUP BY Club, Age
    HAVING COUNT(*) > 1
    
    
--4. Find the player with the highest POT for each nationality
		
SELECT Full_name, Nationality, POT,
FROM (SELECT  Full_name, Nationality, POT, 
     RANK() OVER (PARTITION BY Nationality ORDER BY POT DESC) AS Player_rank 
    FROM fifa21_data2) AS RankedPlayers
WHERE Player_rank = 1 ORDER BY POT DESC


--5. Rank players by their OVA in descending order within each club

SELECT  Full_Name, Club, OVA, 
    DENSE_RANK  () OVER (PARTITION BY Club
    ORDER BY OVA DESC) OVA_Player_Ranking 
FROM fifa21_data2 
ORDER BY OVA DESC



































