/* 
--------------------------------------------------------------------------------------------------------
Data Exploration for Unicorn Companies Analytics Project
--------------------------------------------------------------------------------------------------------

Research Questions
=======================================================================================================
- Which unicorn companies have had the biggest return on investment?
- How long does it usually take for a company to become a unicorn?
- Which industries have the most unicorns? 
- Which countries have the most unicorns? 
- Which investors have funded the most unicorns?
=======================================================================================================
*/

-- Select Database
USE unicorncompanies;

-- Display Sample Data
SELECT *
FROM unicorncompanies
ORDER BY 1 ASC;

SELECT *
FROM unicorncompanies
ORDER BY 1 ASC;

--------------------------------------------------------------------------------------------------------

-- Total Unicorn Companies
WITH UnicornCom AS (
    SELECT inf.Company, inf.Industry, inf.City, inf.Country, inf.Continent, 
           inf.Valuation, inf.Funding, inf.`Year Founded` AS YearFounded, 
           inf.`Date Joined` AS Year, inf.`Select Investors` AS SelectInvestors
    FROM unicorncompanies AS inf
)
SELECT COUNT(1) AS Unicorn
FROM UnicornCom
WHERE (Year - YearFounded) >= 0;

-- Total Countries
WITH UnicornCom AS (
    SELECT inf.Company, inf.Industry, inf.City, inf.Country, inf.Continent, 
           inf.Valuation, inf.Funding, inf.`Year Founded` AS YearFounded, 
           inf.`Date Joined` AS Year, inf.`Select Investors` AS SelectInvestors
    FROM unicorncompanies AS inf
)
SELECT COUNT(DISTINCT Country) AS Country
FROM UnicornCom
WHERE (Year - YearFounded) >= 0;

--------------------------------------------------------------------------------------------------------

/*
- Which unicorn companies have had the biggest return on investment?
*/

SELECT Company, 
       (CAST(Valuation AS UNSIGNED) - CAST(Funding AS UNSIGNED)) / CAST(Funding AS UNSIGNED) AS Roi
FROM unicorncompanies
ORDER BY Roi DESC
LIMIT 10;

--------------------------------------------------------------------------------------------------------

/*
- How long does it usually take for a company to become a unicorn?
*/

-- Find Average Years to Become a Unicorn
WITH UnicornCom AS (
    SELECT inf.Company, inf.Industry, inf.City, inf.Country, inf.Continent,
           inf.Valuation, inf.Funding, inf.`Year Founded` AS YearFounded, 
           inf.`Date Joined` AS Year, inf.`Select Investors` AS SelectInvestors
    FROM unicorncompanies AS inf
)
SELECT CAST(AVG(Year - YearFounded) AS UNSIGNED) AS AverageYear
FROM UnicornCom;

-- Details on Time to Become a Unicorn
WITH UnicornCom AS (
    SELECT inf.Company, inf.Industry, inf.City, inf.Country, inf.Continent,
           inf.Valuation, inf.Funding, inf.`Year Founded` AS YearFounded, 
           inf.`Date Joined` AS Year, inf.`Select Investors` AS SelectInvestors
    FROM unicorncompanies AS inf
)
SELECT (Year - YearFounded) AS UnicornYear, COUNT(1) AS Frequency
FROM UnicornCom
WHERE (Year - YearFounded) >= 0
GROUP BY (Year - YearFounded)
ORDER BY COUNT(1) DESC
LIMIT 10;

--------------------------------------------------------------------------------------------------------

/*
- Which industries have the most unicorns? 
*/

-- Number of Unicorn Companies by Industry
WITH UnicornCom AS (
    SELECT inf.Company, inf.Industry, inf.City, inf.Country, inf.Continent,
           inf.Valuation, inf.Funding, inf.`Year Founded` AS YearFounded, 
           inf.`Date Joined` AS Year, inf.`Select Investors` AS SelectInvestors
    FROM unicorncompanies AS inf
)
SELECT Industry, COUNT(1) AS Frequency
FROM UnicornCom
WHERE (Year - YearFounded) >= 0
GROUP BY Industry
ORDER BY COUNT(1) DESC;

--------------------------------------------------------------------------------------------------------

/*
- Which countries have the most unicorns? 
*/

-- Number of Unicorn Companies by Country
WITH UnicornCom AS (
    SELECT inf.Company, inf.Industry, inf.City, inf.Country, inf.Continent,
           inf.Valuation, inf.Funding, inf.`Year Founded` AS YearFounded, 
           inf.`Date Joined` AS Year, inf.`Select Investors` AS SelectInvestors
    FROM unicorncompanies AS inf
)
SELECT Country, COUNT(1) AS Frequency
FROM UnicornCom
WHERE (Year - YearFounded) >= 0
GROUP BY Country
ORDER BY COUNT(1) DESC;

--------------------------------------------------------------------------------------------------------

/*
- Which investors have funded the most unicorns?
*/

-- Display Sample Data
SELECT *
FROM unicorncompanies
ORDER BY 1 ASC;

-- Replace ', ' with ',' in Investor Data
UPDATE unicorncompanies
SET `Select Investors` = REPLACE(`Select Investors`, ', ', ',');

-- Split Investors List and Count
SELECT value AS Investors, COUNT(*) AS UnicornsInvested 
FROM unicorncompanies
    CROSS JOIN JSON_TABLE(
        CONCAT('["', REPLACE(`Select Investors`, ',', '","'), '"]'),
        '$[*]' COLUMNS(value VARCHAR(255) PATH '$')
    ) AS SplitInvestors
GROUP BY value
ORDER BY COUNT(*) DESC
LIMIT 10;
