CREATE DATABASE IF NOT EXISTS disease_surveillance;
USE disease_surveillance;

/*  Query1 - State wise Disease Burden */

SELECT state_ut, Disease_Grouped,
SUM(Cases) as Total_Cases,
ROUND(Avg(Cases_Per_Lakh),4) as Avg_Cases_Per_Lakh,
SUM(Deaths) as Total_Deaths,
COUNT(*) as Outbreaks_Count
FROM epiclem
GROUP BY state_ut, Disease_Grouped
ORDER BY Avg(Cases_Per_Lakh) DESC
LIMIT 20;

/* Query2 - Seasonal Disease Pattern */
SELECT Season, Disease_Grouped,
ROUND(Avg(Cases_Per_Lakh),4) as Avg_Cases_Per_Lakh,
SUM(Cases) as Total_Cases,
COUNT(DISTINCT state_ut) as State_Affected
FROM epiclem
GROUP BY Season,Disease_Grouped
ORDER BY Season,Total_Cases DESC;

/* Query 3- Resource Prioritization */
SELECT state_ut,
Disease_Grouped,
SUM(CASE WHEN Available_Deaths =1 THEN Cases ELSE 0 END) as Cases_with_Death_Data,
SUM(CASE WHEN Available_Deaths =1 THEN Deaths ELSE 0 END) AS Reported_Deaths,
ROUND(SUM(CASE WHEN Available_Deaths =1 THEN Deaths ELSE 0 END) *100 /
NULLIF(SUM(CASE WHEN Available_Deaths =1 THEN Cases ELSE 0 END),0),2) AS CFR_Percent,
COUNT(CASE WHEN Available_Deaths =0 THEN 1 END) as Missing_Death_Data
FROM epiclem
GROUP BY state_ut,Disease_Grouped
order by CFR_Percent DESC;


/*Query 4- YoY Outbreak Pattern */
SELECT Disease_Grouped, `year`,
SUM(Cases) as Annual_Cases,
ROUND(Avg(Cases_Per_Lakh),4) as Avg_Cases_Per_Lakh,
COUNT(DISTINCT state_ut) as State_Affected
FROM epiclem
GROUP BY `year`,Disease_Grouped
ORDER BY `year`,Annual_Cases DESC;

/* Climate Correlation Check */
SELECT Disease_Grouped, Season,
ROUND(AVG(Temp-273.15),2) as Avg_Temp,
ROUND(AVG(preci),4) as Avg_Rainfall,
ROUND(Avg(Cases_Per_Lakh),4) as Avg_Cases_Per_Lakh
FROM epiclem
GROUP BY Disease_Grouped, Season
ORDER BY Disease_Grouped, Avg_Cases_Per_Lakh;

