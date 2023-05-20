--SELECT *
--FROM PortfolioProject..Covid_vacination
--ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..Covid_death
--WHERE continent is not NULL
--ORDER BY 3,4

-- Daily_Global_numbers_cases_deaths_vaccinated from 03 Jan 2020 up to 19 Apr 2023 / cases / deaths / vaccinated (can be over 100%) / Death Rate

SELECT 
dea.location, 
dea.date, 
--dea.population, 
dea.Total_Cases, 
dea.total_deaths, 
vac.people_vaccinated
--dea.total_deaths/dea.population*100 as Death_Rate_Population
FROM PortfolioProject..Covid_death dea 
JOIN PortfolioProject..Covid_vacination vac
ON dea.location = vac.location 
and dea.date = vac.date  
WHERE dea.location not in ('Asia','Africa','World', 'European Union', 'International',
'low income', 'Lower middle income', 'Upper middle income', 'Europe', 'High income','oceana', 'North America', 'South America') 
--and dea.location like '%United states%'
GROUP BY dea.location, 
dea.date, 
--dea.population, 
dea.Total_Cases, 
dea.total_deaths, 
vac.people_vaccinated
ORDER BY dea.location 

--Total_Global_numbers_per_country up to 19 Apr 2023 / cases / deaths / vaccinated / Death Rate

SELECT dea.location, 
	MAX(population) as Population,
	MAX(dea.Total_Cases) as Max_Cases,
	MAX(dea.total_deaths) as Max_Deaths,
	MAX(dea.total_deaths)/MAX(dea.Total_Cases)*100 as Death_Rate, -- over cases
	MAX(COALESCE(people_vaccinated, 0)) AS max_people_vaccinated
FROM PortfolioProject..Covid_death dea
JOIN PortfolioProject..Covid_vacination vac
ON dea.location = vac.location 
and dea.date = vac.date
WHERE dea.location not in ('Asia','Africa','World', 'European Union', 'International',
'low income', 'Lower middle income', 'Upper middle income', 'Europe', 'High income','oceana', 'North America', 'South America') 
--AND dea.location LIKE '%American Samoa%'
AND dea.date BETWEEN '2020-01-03' AND '2021-01-03'
GROUP BY dea.location
ORDER BY dea.location


-- Total global numbers in % covering the whole preriod from 03 Jan 2020 up to 19 Apr 2023 per country / cases / deaths / vaccinated (can be over 100%)
-- excluding countries with % vaccinated > 100%

SELECT dea.location, 
	MAX(population) as Population,
	MAX(dea.Total_Cases)/MAX(dea.population)*100 as Total_Percent_Cases,
	MAX(dea.total_deaths)/MAX(dea.Total_Cases)*100 as Total_Percent_Deaths_vs_Cases,
	MAX(COALESCE(people_vaccinated, 0))/MAX(dea.population)*100 as Total_Percent_Vaccinated
FROM PortfolioProject..Covid_death dea
JOIN PortfolioProject..Covid_vacination vac
ON dea.location = vac.location 
and dea.date = vac.date
WHERE dea.location not in ('Asia','Africa','World', 'European Union', 'International',
'low income', 'Lower middle income', 'Upper middle income', 'Europe', 'High income','oceana', 'North America', 'South America') 
--and dea.location like '%United Kingdom%'
GROUP BY dea.location
ORDER BY dea.location

-- Query to choose vaccinated rate less than ,,,,,,,,% (and various %) HAVING MAX(vac.people_vaccinated)/MAX(dea.population)*100 < 10
SELECT dea.location, 
MAX(population) as Population,
MAX(dea.Total_Cases)/MAX(dea.population)*100 as Total_Percent_Cases,
MAX(dea.total_deaths)/MAX(dea.population)*100 as Total_Percent_Deaths_over_population,
MAX(COALESCE(people_vaccinated, 0))/MAX(dea.population)*100 as Total_Percent_Vaccinated
FROM PortfolioProject..Covid_death dea
JOIN PortfolioProject..Covid_vacination vac
ON dea.location = vac.location 
and dea.date = vac.date
WHERE dea.location not in ('Asia','Africa','World', 'European Union', 'International',
'low income', 'Lower middle income', 'Upper middle income', 'Europe', 'High income','oceana') 
--and dea.location like '%Afghanistan%'
GROUP BY dea.location
HAVING MAX(COALESCE(people_vaccinated, 0))/MAX(dea.population)*100 > 10 and  MAX(COALESCE(people_vaccinated, 0))/MAX(dea.population)*100 < 15
ORDER BY dea.location

-- Daily Death Rate per Country for the 1st year - without vaccines

SELECT 
dea.location, 
dea.date, 
dea.population,  
dea.total_deaths, 
dea.total_deaths/dea.population*100 as Death_Rate_over_population
FROM PortfolioProject..Covid_death dea 
JOIN PortfolioProject..Covid_vacination vac
ON dea.location = vac.location 
and dea.date = vac.date  
WHERE dea.location not in ('Asia','Africa','World', 'European Union', 'International',
'low income', 'Lower middle income', 'Upper middle income', 'Europe', 'High income','oceana', 'North America', 'South America') 
--and dea.date like '%2021%'
--AND dea.date BETWEEN '2020-01-03' AND '2021-01-03'
GROUP BY dea.location, 
dea.date, 
dea.population,  
dea.total_deaths
ORDER BY dea.location 


-- Daily Death Rate per Country for the 2nd year - without vaccines

--SELECT 
--dea.location, 
--dea.date, 
--dea.population,  
--dea.total_deaths, 
--dea.total_deaths/dea.population*100 as Death_Rate_over_population
--FROM PortfolioProject..Covid_death dea 
--JOIN PortfolioProject..Covid_vacination vac
--ON dea.location = vac.location 
--and dea.date = vac.date  
--WHERE dea.location not in ('Asia','Africa','World', 'European Union', 'International',
--'low income', 'Lower middle income', 'Upper middle income', 'Europe', 'High income','oceana', 'North America', 'South America') 
----and dea.date like '%2021%'
--AND dea.date BETWEEN '2021-01-03' AND '2022-01-03'
--GROUP BY dea.location, 
--dea.date, 
--dea.population,  
--dea.total_deaths
--ORDER BY dea.location 


-- Total Deaths per Country for the 1st year without vaccines / change date and minus 1st year = 2nd year / 3rd year

SELECT dea.location, 
	MAX(population) as Population,
	MAX(dea.total_deaths) as Total_Deaths
FROM PortfolioProject..Covid_death dea
JOIN PortfolioProject..Covid_vacination vac
ON dea.location = vac.location 
and dea.date = vac.date
WHERE dea.location not in ('Asia','Africa','World', 'European Union', 'International',
'low income', 'Lower middle income', 'Upper middle income', 'Europe', 'High income','oceana', 'North America', 'South America', 'England', 'Wales') 
AND dea.location LIKE '%United States%'
--AND dea.date BETWEEN '2020-01-03' AND '2023-04-18'
GROUP BY dea.location
ORDER BY dea.location


-- Counting Daily Global Numbers

SELECT 
    dea.date,
    SUM(dea.Total_Cases) AS Total_Global_Cases,
	SUM(dea.total_deaths) as total_Global_deaths,
	SUM(vac.people_vaccinated) as total_Global_vaccinated

	
FROM
    PortfolioProject..Covid_death dea
JOIN
    PortfolioProject..Covid_vacination vac ON dea.location = vac.location
        AND dea.date = vac.date
WHERE
    dea.location NOT IN ('Asia', 'Africa', 'World', 'European Union', 'International', 'low income', 'Lower middle income', 'Upper middle income', 'Europe', 'High income', 'oceana', 'North America', 'South America')
GROUP BY
    dea.date

ORDER BY
    dea.date;


ALTER TABLE PortfolioProject..Covid_vacination
ALTER COLUMN people_vaccinated BIGINT;

UPDATE PortfolioProject..Covid_vacination
SET people_vaccinated = NULL
WHERE ISNUMERIC(people_vaccinated) = 0;

--Select MAX Data concerning cases, deaths, vaccinated / per year

SELECT 
	dea.location,
	dea.population,
    MAX(dea.Total_Cases) AS total_Year_cases,
	MAX(dea.total_deaths) as total_Year_deaths,
	MAX(COALESCE(people_vaccinated, 0)) as total_Year_vaccinated


FROM PortfolioProject..Covid_death dea 
JOIN PortfolioProject..Covid_vacination vac
ON dea.location = vac.location 
and dea.date = vac.date  
WHERE dea.location not in ('Asia','Africa','World', 'European Union', 'International',
'low income', 'Lower middle income', 'Upper middle income', 'Europe', 'High income','oceana', 'North America', 'South America') 
--and dea.date like '%2021%'
AND dea.date BETWEEN '2022-01-03' AND '2023-04-18'
GROUP BY 
dea.location,
dea.population

ORDER BY dea.location 
