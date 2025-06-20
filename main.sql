-- Importing csv as table.

COPY "Census_1" FROM 'path to dataset/Dataset1.csv' DELIMITER ',' CSV HEADER ;

COPY "Census_2" FROM 'path to dataset/Dataset2.csv' DELIMITER ',' CSV HEADER ;

SELECT * FROM "Census_1";

SELECT * FROM "Census_2";


-- Finding any duplicate or NA values.

SELECT DISTINCT("State") FROM "Census_1" ORDER BY "State";

SELECT DISTINCT("State") FROM "Census_2" ORDER BY "State";

SELECT DISTINCT("District")
FROM "Census_1"
ORDER BY "District";

SELECT DISTINCT("District")
FROM "Census_2"
ORDER BY "District";


-- removing #N/A value from State

DELETE FROM "Census_2" WHERE "State" = '#N/A';

SELECT DISTINCT("State") FROM "Census_2" ORDER BY "State";


-- getting the total, average and median population

SELECT SUM("Population") FROM "Census_2";

SELECT AVG("Population") FROM "Census_2";

SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY "Population") FROM "Census_2";


-- median growth

SELECT PERCENTILE_CONT(0.5) 
WITHIN GROUP (ORDER BY "Growth%") AS "Median Growth" 
FROM "Census_1";


-- median literacy

SELECT PERCENTILE_CONT(0.5) 
WITHIN GROUP (ORDER BY "Literacy") AS "Median Literacy" 
FROM "Census_1";


-- median sex ratio

SELECT PERCENTILE_CONT(0.5) 
WITHIN GROUP (ORDER BY "Sex_Ratio") AS "Median Sex Ratio" 
FROM "Census_1";


-- Combining Census_1 and Census_2 and getting states name with literacy above average

SELECT DISTINCT(C1."State")
FROM "Census_1" AS C1
INNER JOIN "Census_2" AS C2 ON C1."State" = C2."State"
WHERE "Literacy" < (SELECT AVG("Literacy") FROM "Census_1")
ORDER BY C1."State";


-- Getting district and states name with literacy above 95%

SELECT DISTINCT(C1."District"), C1."State"
FROM "Census_1" AS C1
INNER JOIN "Census_2" AS C2 ON C1."State" = C2."State"
GROUP BY C1."Literacy", C1."District", C1."State"
HAVING C1."Literacy" > (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY "Literacy") FROM "Census_1")
ORDER BY C1."State";


-- Getting district and states name with literacy below 25%

SELECT DISTINCT(C1."District"), C1."State"
FROM "Census_1" AS C1
INNER JOIN "Census_2" AS C2 ON C1."State" = C2."State"
GROUP BY C1."Literacy", C1."District", C1."State"
HAVING C1."Literacy" < (SELECT PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY "Literacy") FROM "Census_1")
ORDER BY C1."State";


-- Getting top 5 most populus states

SELECT DISTINCT(C1."State"), SUM(C2."Population") AS total_pop
FROM "Census_1" AS C1
INNER JOIN "Census_2" AS C2 ON C1."State" = C2."State"
GROUP BY C1."State"
ORDER BY total_pop DESC
LIMIT 5;


-- Getting top 5 growth%

SELECT DISTINCT("State"), FLOOR(SUM("Growth%")) AS tot_growth
FROM "Census_1"
GROUP BY "State"
ORDER BY tot_growth DESC
LIMIT 5;


-- Top 5 Population vs Area

SELECT "State", SUM("Population") AS total_pop, SUM("Area_km2") AS total_area
FROM "Census_2"
GROUP BY "State"
ORDER BY total_pop DESC, total_area DESC
LIMIT 5;
