 
 --What was the survival rate of males in the third passenger class 
    
 SELECT
    Round(AVG(T.Survived), 2)  AS SurvivalRate
FROM
   Train T Left join Gender G ON T.survived = G.survived JOIN Test T2 ON T.Pclass = T2.Pclass
WHERE
    T.Pclass = 3
    AND T2.Sex = 'male'; 


--What is the percentage survived between Sex, Embarked, and PClass
 
  SELECT
    T.Sex,
    T.Embarked,
    T.Pclass,
    Round(AVG(G.Survived), 3) * 100 AS SurvivalPercentage
FROM
    Train T LEFT JOIN Gender G on T.survived = G.survived LEFT JOIN Test T2 ON T.Pclass = T2.Pclass
GROUP BY
    T.Sex,
    T.Embarked,
    T.Pclass
ORDER BY 
	T.Pclass;
   
--If you were to advise your chances of survival on the Titanic, what would you say? If you are of the below data (Sex:Male, Age: 36, Pclass:2, Emabrked:C)

 SELECT
    AVG(T.Survived) * 100 AS SurvivalPercentage
FROM
    Train T LEFT JOIN Gender G ON T.Survived = G.survived JOIN Test T2 ON T.Pclass = T2.Pclass
WHERE
    T.Sex = 'male'
    AND T.Age = 36
    AND T.Pclass = 2
    AND T.Embarked = 'C';
    
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   