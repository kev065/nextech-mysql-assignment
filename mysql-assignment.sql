CREATE DATABASE llin_analysis;

USE llin_analysis; 

CREATE TABLE llin_distribution (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    `Number distributed` INT,
    location VARCHAR(255),
    country VARCHAR(255),
    year INT,
    by_whom VARCHAR(255),
    country_code VARCHAR(3)
);

SELECT * FROM llin_distribution;

-- total number of llins per country 
SELECT country, SUM(`Number distributed`) AS total_number_of_llins
FROM llin_distribution
GROUP BY country;


-- average number of linns per distribution event
SELECT AVG(`Number distributed`) AS average_number_of_llins
FROM llin_distribution;

-- Earliest and Latest Distribution Dates
SELECT MIN(year) AS earliest_year, MAX(year) AS latest_year
FROM llin_distribution;

-- total number of LLINs distributed by each organization
SELECT by_whom, SUM(`Number distributed`) AS total_llins_distributed_per_org
FROM llin_distribution
GROUP BY by_whom;

-- total number of LLINs distributed in each year
SELECT year, SUM(`Number distributed`) AS total_distributed
FROM llin_distribution
GROUP BY year;

-- location with the highest number of LLINs distributed.
SELECT location, SUM(`Number distributed`) AS highest_number_distributed
FROM llin_distribution
GROUP BY location
ORDER BY highest_number_distributed DESC
LIMIT 1;


-- Location with the lowest number of LLINs distributed
SELECT location, SUM(`Number distributed`) AS lowest_number_distributed
FROM llin_distribution
GROUP BY location
ORDER BY lowest_number_distributed ASC
LIMIT 1;

-- Determine if there's a significant difference in the number of 
-- LLINs distributed by different organizations.
SELECT by_whom, SUM(`Number distributed`) AS total_distributed
FROM llin_distribution
GROUP BY by_whom
ORDER BY total_distributed DESC;


-- Identify outliers for locations (beyond 2 standard deviations from the mean)
SELECT location, total_distributed
FROM (
    SELECT location, SUM(`Number distributed`) AS total_distributed
    FROM llin_distribution
    GROUP BY location
) AS location_distributions
WHERE total_distributed > (SELECT AVG(total_distributed) + 2 * STDDEV(total_distributed) FROM (
    SELECT location, SUM(`Number distributed`) AS total_distributed
    FROM llin_distribution
    GROUP BY location
) AS temp) 
OR total_distributed < (SELECT AVG(total_distributed) - 2 * STDDEV(total_distributed) FROM (
    SELECT location, SUM(`Number distributed`) AS total_distributed
    FROM llin_distribution
    GROUP BY location
) AS temp);

