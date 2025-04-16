-- Select Database
USE unicorncompanies;

-- Table 1: Total Unicorn Companies
WITH UnicornCom AS (
    SELECT inf.ID, inf.Company, inf.Industry, inf.City, inf.Country, inf.Continent, 
           fin.Valuation, fin.Funding, inf.YearFounded, fin.Year, fin.SelectInvestors
    FROM unicorn_info AS inf
    INNER JOIN unicorn_finance AS fin
        ON inf.ID = fin.ID
)
SELECT COUNT(1) AS Unicorn
FROM UnicornCom
WHERE (Year - YearFounded) >= 0;

-- Total Countries
WITH UnicornCom AS (
    SELECT inf.ID, inf.Company, inf.Industry, inf.City, inf.Country, inf.Continent, 
           fin.Valuation, fin.Funding, inf.YearFounded, fin.Year, fin.SelectInvestors
    FROM unicorn_info AS inf
    INNER JOIN unicorn_finance AS fin
        ON inf.ID = fin.ID
)
SELECT COUNT(DISTINCT Country) AS Country
FROM UnicornCom
WHERE (Year - YearFounded) >= 0;

-- Table 2: Company and Country List
WITH UnicornCom AS (
    SELECT inf.ID, inf.Company, inf.Industry, inf.City, inf.Country, inf.Continent,
           fin.Valuation, fin.Funding, inf.YearFounded, fin.Year, fin.SelectInvestors
    FROM unicorn_info AS inf
    INNER JOIN unicorn_finance AS fin
        ON inf.ID = fin.ID
)
SELECT Company, Country
FROM UnicornCom
WHERE (Year - YearFounded) >= 0;

-- Table 3: ROI Calculation
SELECT Company, 
       (CAST(Valuation AS UNSIGNED) - CAST(Funding AS UNSIGNED)) / CAST(Funding AS UNSIGNED) AS Roi
FROM unicorn_finance
ORDER BY Roi DESC;

-- Table 4: Unicorn Year Calculation
WITH UnicornCom AS (
    SELECT inf.ID, inf.Company, inf.Industry, inf.City, inf.Country, inf.Continent,
           fin.Valuation, fin.Funding, inf.YearFounded, fin.Year, fin.SelectInvestors
    FROM unicorn_info AS inf
    INNER JOIN unicorn_finance AS fin
        ON inf.ID = fin.ID
)
SELECT (Year - YearFounded) AS UnicornYear, COUNT(1) AS Frequency
FROM UnicornCom
WHERE (Year - YearFounded) >= 0
GROUP BY (Year - YearFounded)
ORDER BY COUNT(1) DESC;

-- Table 5: Industry Frequency
WITH UnicornCom AS (
    SELECT inf.ID, inf.Company, inf.Industry, inf.City, inf.Country, inf.Continent,
           fin.Valuation, fin.Funding, inf.YearFounded, fin.Year, fin.SelectInvestors
    FROM unicorn_info AS inf
    INNER JOIN unicorn_finance AS fin
        ON inf.ID = fin.ID
)
SELECT Industry, COUNT(1) AS Frequency,
       CAST(COUNT(1) * 100.0 / (SELECT COUNT(*) FROM UnicornCom) AS UNSIGNED) AS 'Percentage'
FROM UnicornCom
WHERE (Year - YearFounded) >= 0
GROUP BY Industry
ORDER BY Frequency DESC;

-- Table 6: Country Frequency
WITH UnicornCom AS (
    SELECT inf.ID, inf.Company, inf.Industry, inf.City, inf.Country, inf.Continent,
           fin.Valuation, fin.Funding, inf.YearFounded, fin.Year, fin.SelectInvestors
    FROM unicorn_info AS inf
    INNER JOIN unicorn_finance AS fin
        ON inf.ID = fin.ID
)
SELECT Country, COUNT(1) AS Frequency,
       CAST(COUNT(1) * 100.0 / (SELECT COUNT(*) FROM UnicornCom) AS UNSIGNED) AS 'Percentage'
FROM UnicornCom
WHERE (Year - YearFounded) >= 0
GROUP BY Country
ORDER BY Frequency DESC;

-- Table 7: Investors
SELECT value AS Investors, COUNT(*) AS UnicornsInvested
FROM unicorn_finance
    CROSS JOIN JSON_TABLE(
        CONCAT('["', REPLACE(SelectInvestors, ',', '","'), '"]'),
        '$[*]' COLUMNS(value VARCHAR(255) PATH '$')
    ) AS SplitInvestors
GROUP BY value
ORDER BY COUNT(*) DESC;

