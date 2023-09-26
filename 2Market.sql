-- Create Database
CREATE DATABASE "2Market";

-- Create Table script for 2Market Database
-- Create Table "Marketing_Data"
CREATE TABLE "Marketing_Data"(
    "ID" INTEGER PRIMARY KEY,
    "Year_Birth" NUMERIC(4,0),
	"Age" NUMERIC(3,0),
	"Education" VARCHAR(20),
	"Marital_Status" VARCHAR(20),
	"Income" NUMERIC(6,0),
	"Duplicate" NUMERIC(1,0),
	"Duplicate Combined" NUMERIC(1,0),
	"TotalChildren" NUMERIC(1,0),
	"Kidhome" NUMERIC(1,0),
	"Teenhome" NUMERIC(1,0),
	"Dt_Customer" DATE,
	"Recency" NUMERIC(2,0),
	"AmtTotal" NUMERIC(4,0),
	"AmtLiq" NUMERIC(4,0),
	"AmtVege" NUMERIC(4,0),
	"AmtNonVeg" NUMERIC(4,0),
	"AmtPes" NUMERIC(4,0),
	"AmtChocolates" NUMERIC(4,0),
	"AmtComm" NUMERIC(4,0),
	"NumDeals" NUMERIC(2,0),
	"CountPurchase" NUMERIC(2,0),
	"NumWebBuy" NUMERIC(2,0),
	"NumWalkinPur" NUMERIC(2,0),
	"NumVisits" NUMERIC(2,0),
	"Response" NUMERIC(1,0),
	"Complain" NUMERIC(1,0),
	"Outlier" NUMERIC(1,0),
	"Country" VARCHAR(20),
	"Count_success" NUMERIC(1,0)
);
-- Create Table "Ad_Data"
CREATE TABLE "Ad_Data"(
    "ID" INTEGER PRIMARY KEY,
	"Bulkmail_ad" NUMERIC(1,0),
	"Twitter_ad" NUMERIC(1,0),
	"Instagram_ad" NUMERIC(1,0),
	"Facebook_ad" NUMERIC(1,0),
	"Brochure_ad" NUMERIC(1,0),
	"Total_ad" NUMERIC(1,0)
);
	
/*
-- Table Join statements for "Marketing_Data" & "Ad_Data"
*/

-- select all
SELECT *
FROM public."Marketing_Data"
INNER JOIN public."Ad_Data" USING ("ID")
ORDER BY "ID";

/*
-- Select "Marketing_Data" statements
-- Filter out "Duplicates", "Outliers" & "Marital_Status = N/A"
*/

-- Select all
SELECT *
FROM public."Marketing_Data"
ORDER BY "ID";

-- Total spend per country (removing duplicates, outliers & marital status errors)
SELECT "Country", SUM("AmtTotal") AS "TotalSpend"
FROM public."Marketing_Data"
WHERE "Duplicate" = '0'
AND "Outlier" = '0'
AND "Marital_Status" NOT LIKE ('%N/A%')
GROUP BY "Country"
ORDER BY "TotalSpend" DESC;

-- Total spend per product per country
-- Which products are the most popular in each country
SELECT 	"Country",
		SUM("AmtTotal") AS "TotalSpend",
		SUM("AmtLiq") AS "TotalAlcohol",
		SUM("AmtVege") AS "TotalVegetables",
		SUM("AmtNonVeg") AS "TotalMeat",
		SUM("AmtPes") AS "TotalFish",
		SUM("AmtChocolates") AS "TotalChocolates",
		SUM("AmtComm") AS "TotalCommodities"
FROM public."Marketing_Data"
WHERE "Duplicate" = '0'
AND "Outlier" = '0'
AND "Marital_Status" NOT LIKE ('%N/A%')
GROUP BY "Country"
ORDER BY "TotalSpend" DESC;
-- Answer: Spain, Alcohol & Meat

-- Total spend per product per marital status
-- Which products are the most popular in each marital status
SELECT 	"Marital_Status",
		SUM("AmtTotal") AS "TotalSpend",
		SUM("AmtLiq") AS "TotalAlcohol",
		SUM("AmtVege") AS "TotalVegetables",
		SUM("AmtNonVeg") AS "TotalMeat",
		SUM("AmtPes") AS "TotalFish",
		SUM("AmtChocolates") AS "TotalChocolates",
		SUM("AmtComm") AS "TotalCommodities"
FROM public."Marketing_Data"
WHERE "Duplicate" = '0'
AND "Outlier" = '0'
AND "Marital_Status" NOT LIKE ('%N/A%')
GROUP BY "Marital_Status"
ORDER BY "TotalSpend" DESC;
-- Answer: Married, Alcohol & Meat

-- Which products are the most popular based on whether or not there are children at home
SELECT 	SUM("AmtTotal") AS "TotalSpend",
		SUM("AmtLiq") AS "TotalAlcohol",
		SUM("AmtVege") AS "TotalVegetables",
		SUM("AmtNonVeg") AS "TotalMeat",
		SUM("AmtPes") AS "TotalFish",
		SUM("AmtChocolates") AS "TotalChocolates",
		SUM("AmtComm") AS "TotalCommodities"
FROM public."Marketing_Data"
WHERE "Duplicate" = '0'
AND "Outlier" = '0'
AND "Marital_Status" NOT LIKE ('%N/A%')
AND "TotalChildren" <> '0'
ORDER BY "TotalSpend" DESC;
-- Answer: Alcohol & Meat

/*
-- compare data between duplicates and originals
*/

-- select duplicates and compare data sets
-- the set we keep ("Duplicates Combined = 1") and the set we delete ("Duplicates Combined = 2")
SELECT 	"Duplicate Combined",
		COUNT("Duplicate Combined") AS "TotalDuplicates",
		ROUND(AVG("AmtTotal"),2) AS "AvgSpend",
		ROUND(AVG("AmtLiq"),2) AS "AvgAlcohol",
		ROUND(AVG("AmtVege"),2) AS "AvgVegetables",
		ROUND(AVG("AmtNonVeg"),2) AS "AvgMeat",
		ROUND(AVG("AmtPes"),2) AS "AvgFish",
		ROUND(AVG("AmtChocolates"),2) AS "AvgChocolates",
		ROUND(AVG("AmtComm"),2) AS "AvgCommodities"
FROM public."Marketing_Data"
WHERE "Duplicate Combined" > '0'
GROUP BY "Duplicate Combined"
ORDER BY "AvgSpend" DESC;



/*
-- Select "Ad_Data" statements
*/

-- select all
SELECT *
FROM public."Ad_Data"
ORDER BY "ID";

/*
-- Create new column in "Ad_Data" for text listing all adverts shown to customer
*/

-- add column "String_ad" to hold all advertising campaigns for each customer
ALTER TABLE public."Ad_Data"
ADD COLUMN "String_ad" VARCHAR(100);

-- write script to add "Email" to customer data for "Bulkmail_ad = 1"
UPDATE public."Ad_Data"
SET "String_ad" = 'Email'
WHERE "Bulkmail_ad" = 1
RETURNING *;

-- write script to add "Twitter" to customer data for "Twitter_ad = 1"
UPDATE public."Ad_Data"
SET "String_ad" = CONCAT("String_ad",',Twitter')
WHERE "Twitter_ad" = 1
RETURNING *;

-- write script to add "Instagram" to customer data for "Instagram_ad = 1"
UPDATE public."Ad_Data"
SET "String_ad" = CONCAT("String_ad",',Instagram')
WHERE "Instagram_ad" = 1
RETURNING *;

-- write script to add "Facebook" to customer data for "Facebook_ad = 1"
UPDATE public."Ad_Data"
SET "String_ad" = CONCAT("String_ad",',Facebook')
WHERE "Facebook_ad" = 1
RETURNING *;

-- write script to add "Brochure" to customer data for "Brochure_ad = 1"
UPDATE public."Ad_Data"
SET "String_ad" = CONCAT("String_ad",',Brochure')
WHERE "Brochure_ad" = 1
RETURNING *;

-- Remove comma from 1st character in "String_ad"
-- find
SELECT "String_ad" = LTRIM("String_ad",',')
FROM public."Ad_Data"
WHERE LEFT("String_ad",1) = ','; 
-- remove
UPDATE public."Ad_Data"
SET "String_ad" = LTRIM("String_ad",',')
WHERE LEFT("String_ad",1) = ','; 

/*
-- Finshed creating new column and adding data
*/


/*
-- Table Join statements for "Marketing_Data" & "Ad_Data"
*/

-- select all
SELECT *
FROM public."Marketing_Data"
INNER JOIN public."Ad_Data" USING ("ID")
ORDER BY "ID";

-- select all adverising campaigns with single exposure
-- control group with no advert
-- and those exposed to all 3 social media platforms (Facebook,Instagram,Twitter)
-- Filter out "Duplicates", "Outliers" & "Marital_Status = N/A
SELECT 	"String_ad" AS "Ad_Campaigns",
		COUNT("ID") AS "TotalCustomers",
		ROUND(AVG("Age"),2) AS "AvgAge",
		ROUND(AVG("Income"),2) AS "AvgIncome",
		ROUND(AVG("AmtTotal"),2) AS "AvgSpend",
		ROUND(AVG("AmtLiq"),2) AS "AvgAlcohol",
		ROUND(AVG("AmtVege"),2) AS "AvgVegetables",
		ROUND(AVG("AmtNonVeg"),2) AS "AvgMeat",
		ROUND(AVG("AmtPes"),2) AS "AvgFish",
		ROUND(AVG("AmtChocolates"),2) AS "AvgChocolates",
		ROUND(AVG("AmtComm"),2) AS "AvgCommodities"
FROM public."Marketing_Data"
INNER JOIN public."Ad_Data" USING ("ID")
WHERE 	"Duplicate" = '0'
	  	AND "Outlier" = '0'
	  	AND "Marital_Status" NOT LIKE ('%N/A')
		AND ("String_ad" IN ('Twitter,Instagram,Facebook') OR "Total_ad" < '2')
GROUP BY "Ad_Campaigns"
ORDER BY "AvgSpend" DESC;

-- filter by age and income (age > 50, income > 50000)
-- to be around average of dataset
-- this way we can compare dataset more accurately
-- filter out "Duplicates", "Outliers" & "Marital_Status = N/A
SELECT 	"String_ad" AS "Ad_Campaigns",
		COUNT("ID") AS "TotalCustomers",
		ROUND(AVG("Age"),2) AS "AvgAge",
		ROUND(AVG("Income"),2) AS "AvgIncome",
		ROUND(AVG("AmtTotal"),2) AS "AvgSpend",
		ROUND(AVG("AmtLiq"),2) AS "AvgAlcohol",
		ROUND(AVG("AmtVege"),2) AS "AvgVegetables",
		ROUND(AVG("AmtNonVeg"),2) AS "AvgMeat",
		ROUND(AVG("AmtPes"),2) AS "AvgFish",
		ROUND(AVG("AmtChocolates"),2) AS "AvgChocolates",
		ROUND(AVG("AmtComm"),2) AS "AvgCommodities"
FROM public."Marketing_Data"
INNER JOIN public."Ad_Data" USING ("ID")
WHERE 	"Duplicate" = '0'
	  	AND "Outlier" = '0'
	  	AND "Marital_Status" NOT LIKE ('%N/A')
		AND "Age" > '50'
		AND "Income" > '60000'
		AND ("String_ad" IN ('Twitter,Instagram,Facebook') OR "Total_ad" < '2')
GROUP BY "Ad_Campaigns"
ORDER BY "AvgSpend" DESC;

-- select all adverising campaigns with social media 
-- Filter out "Duplicates", "Outliers" & "Marital_Status = N/A
SELECT 	"String_ad" AS "Ad_Campaigns",
		COUNT("ID") AS "TotalCustomers",
		ROUND(AVG("Age"),2) AS "AvgAge",
		ROUND(AVG("Income"),2) AS "AvgIncome",
		ROUND(AVG("AmtTotal"),2) AS "AvgSpend",
		ROUND(AVG("AmtLiq"),2) AS "AvgAlcohol",
		ROUND(AVG("AmtVege"),2) AS "AvgVegetables",
		ROUND(AVG("AmtNonVeg"),2) AS "AvgMeat",
		ROUND(AVG("AmtPes"),2) AS "AvgFish",
		ROUND(AVG("AmtChocolates"),2) AS "AvgChocolates",
		ROUND(AVG("AmtComm"),2) AS "AvgCommodities"
FROM public."Marketing_Data"
INNER JOIN public."Ad_Data" USING ("ID")
WHERE 	"Duplicate" = '0'
	  	AND "Outlier" = '0'
	  	AND "Marital_Status" NOT LIKE ('%N/A%')
		AND (
			"String_ad" LIKE ('%Facebook%')
			 OR "String_ad" LIKE ('%Twitter%')
			 OR "String_ad" LIKE ('%Instagram%')
			)
GROUP BY "Ad_Campaigns"
ORDER BY "AvgSpend" DESC;

-- query advertising data by country
-- Filter out "Duplicates", "Outliers" & "Marital_Status = N/A
SELECT 	"Country",
		"String_ad" AS "Ad_Campaigns",
		COUNT("ID") AS "TotalCustomers",
		ROUND(AVG("Age"),2) AS "AvgAge",
		ROUND(AVG("Income"),2) AS "AvgIncome",
		ROUND(AVG("AmtTotal"),2) AS "AvgSpend",
		ROUND(AVG("AmtLiq"),2) AS "AvgAlcohol",
		ROUND(AVG("AmtVege"),2) AS "AvgVegetables",
		ROUND(AVG("AmtNonVeg"),2) AS "AvgMeat",
		ROUND(AVG("AmtPes"),2) AS "AvgFish",
		ROUND(AVG("AmtChocolates"),2) AS "AvgChocolates",
		ROUND(AVG("AmtComm"),2) AS "AvgCommodities"
FROM public."Marketing_Data"
INNER JOIN public."Ad_Data" USING ("ID")
WHERE 	"Duplicate" = '0'
	  	AND "Outlier" = '0'
	  	AND "Marital_Status" NOT LIKE ('%N/A')
		AND ("String_ad" IN ('Twitter,Instagram,Facebook') OR "Total_ad" < '2')
GROUP BY "Country", "Ad_Campaigns"
ORDER BY "AvgSpend" DESC;


/*
-- Create new table from query using only fields I require for analysis (final version of dataset)
*/
CREATE TABLE final_data AS
SELECT	md."ID",
		md."Age",
		md."Education",
		md."Marital_Status",
		md."Country",
		md."Income",
		md."TotalChildren",
		md."Dt_Customer",
		md."AmtTotal",
		md."AmtLiq",
		md."AmtVege",
		md."AmtNonVeg",
		md."AmtPes",
		md."AmtChocolates",
		md."AmtComm",
		md."NumDeals",
		md."CountPurchase",
		md."NumWebBuy",
		md."NumWalkinPur",
		md."NumVisits",
		md."Count_success",
		ad."Bulkmail_ad",
		ad."Twitter_ad",
		ad."Instagram_ad",
		ad."Facebook_ad",
		ad."Brochure_ad",
		ad."Total_ad",
		ad."String_ad",
		md."Duplicate",
		md."Outlier"
FROM public."Marketing_Data" md
INNER JOIN public."Ad_Data" ad USING ("ID")
ORDER BY "ID";

-- search & remove duplicates, outliers and marital status = n/a from data
SELECT *
FROM public."final_data"
WHERE "Duplicate" = '1';

DELETE FROM public."final_data"
WHERE "Duplicate" = '1';

SELECT *
FROM public."final_data"
WHERE "Outlier" = '1';

DELETE FROM public."final_data"
WHERE "Outlier" = '1';

SELECT *
FROM public."final_data"
WHERE "Marital_Status" LIKE ('%N/A');

DELETE FROM public."final_data"
WHERE "Marital_Status" LIKE ('%N/A');

-- remove columns "Duplicate" and "Outlier"
ALTER TABLE public."final_data"
DROP COLUMN "Duplicate",
DROP COLUMN "Outlier";

-- select all records from new clean table
SELECT *
FROM public."final_data";

-- update no adverts value text
SELECT *
FROM public."final_data"
WHERE "String_ad" IS NULL;

UPDATE public."final_data"
SET "String_ad" = 'No Adverts'
WHERE "String_ad" IS NULL;

-- export to CSV
COPY public."final_data" TO 'D:\Luke\Desktop\LSE\Assignment 1\LSE_DA101_Assignment_data\marketing_data_final.csv' DELIMITER ',' CSV HEADER;

-- Drop Tables
DROP TABLE "Marketing_Data"
DROP TABLE "Ad_Data"

-- Drop Database
DROP DATABASE "2Market";
