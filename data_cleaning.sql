/* 
--------------------------------------------------------------------------------------------------------
Data Cleaning for Unicorn Companies Analytics Project
--------------------------------------------------------------------------------------------------------
*/

-- Select Database
USE unicorncompanies;

-- Display Data for Validation
SELECT *
FROM unicorncompanies
ORDER BY 1 ASC;

SELECT *
FROM unicorncompanies
ORDER BY 1 ASC;

--------------------------------------------------------------------------------------------------------

-- Check Duplicate Company Names
SELECT Company, COUNT(Company)
FROM unicorncompanies
GROUP BY Company
HAVING COUNT(Company) > 1;

SELECT Company, COUNT(Company)
FROM unicorncompanies
GROUP BY Company
HAVING COUNT(Company) > 1;

-- Bolt and Fabric appear twice in both data sets. 
-- Since they are in different cities/countries, we will keep them.

--------------------------------------------------------------------------------------------------------

-- Rename Columns (MySQL Syntax)
ALTER TABLE unicorncompanies
RENAME COLUMN `Year Founded` TO YearFounded;

ALTER TABLE unicorncompanies
RENAME COLUMN `Date Joined` TO DateJoined;

ALTER TABLE unicorncompanies
RENAME COLUMN `Select Investors` TO SelectInvestors;

SELECT *
FROM unicorncompanies;

--------------------------------------------------------------------------------------------------------

-- Standardize Date Joined Format & Split into Year, Month, Day

-- Add New Date Columns
ALTER TABLE unicorncompanies
ADD DateJoinedConverted DATE;

UPDATE unicorncompanies
SET DateJoinedConverted = STR_TO_DATE(DateJoined, '%m/%d/%Y');

-- Add Individual Date Parts
ALTER TABLE unicorncompanies ADD Year INT;
UPDATE unicorncompanies
SET Year = YEAR(DateJoinedConverted);

ALTER TABLE unicorncompanies ADD Month INT;
UPDATE unicorncompanies
SET Month = MONTH(DateJoinedConverted);

ALTER TABLE unicorncompanies ADD Day INT;
UPDATE unicorncompanies
SET Day = DAY(DateJoinedConverted);

SELECT *
FROM unicorncompanies;

--------------------------------------------------------------------------------------------------------

-- Drop Rows Where Funding Column Contains '$0M' or 'Unknown'
DELETE FROM unicorncompanies
WHERE Funding IN ('$0M', 'Unknown');

SELECT DISTINCT Funding
FROM unicorncompanies
ORDER BY Funding DESC;

--------------------------------------------------------------------------------------------------------

-- Reformat Currency Value for "Valuation" and "Funding" Columns

UPDATE unicorncompanies
SET Valuation = SUBSTRING(Valuation, 2);  -- Removes '$' from the start

UPDATE unicorncompanies
SET Valuation = REPLACE(REPLACE(Valuation, 'B', '000000000'), 'M', '000000');

UPDATE unicorncompanies
SET Funding = SUBSTRING(Funding, 2);  -- Removes '$' from the start

UPDATE unicorncompanies
SET Funding = REPLACE(REPLACE(Funding, 'B', '000000000'), 'M', '000000');

SELECT *
FROM unicorncompanies;

--------------------------------------------------------------------------------------------------------

-- Delete Unused Columns
ALTER TABLE unicorncompanies
DROP COLUMN DateJoined;

ALTER TABLE unicorncompanies
RENAME COLUMN DateJoinedConverted TO DateJoined;

SELECT *
FROM unicorncompanies;
