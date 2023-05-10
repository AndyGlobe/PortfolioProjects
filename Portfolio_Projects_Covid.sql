SELECT *
FROM PortfolioProject..Covid_death
WHERE continent is not NULL
ORDER BY 3,4

SELECT *
FROM PortfolioProject..Covid_vacination
ORDER BY 3,4


-- Let's transform cases_per_million to total cases and add this as a new column to the table

--ALTER TABLE PortfolioProject..Covid_death ADD Total_Cases FLOAT;
--UPDATE PortfolioProject..Covid_death 
--SET Total_Cases = (total_cases_per_million*population)/1000000;


-- Select Data that we are going to use

SELECT location, date, total_cases, new_cases, total_deaths, population 
FROM PortfolioProject.. Covid_death
ORDER BY 1,2


---- Changing strings to int
--ALTER TABLE Covid_death
--ALTER COLUMN Total_deaths INT;

--ALTER TABLE Covid_death
--ALTER COLUMN Total_cases_per_million decimal(10,2);


SELECT location, date, population, total_cases, total_deaths, 
(total_deaths/total_cases*100) AS Death_Percentage
FROM PortfolioProject.. Covid_death
WHERE location like '%states%'
order by 1,2


-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

SELECT location, date, population, total_cases, 
total_cases/population*100 AS Percentage_of_population_got_Covid
FROM PortfolioProject.. Covid_death
WHERE location like '%Iceland%'
order by 1,2

-- Looking at Total Death vs Population		

SELECT location, date, population, 
(total_deaths/population*100) AS Percentage_of_population_Death
FROM PortfolioProject.. Covid_death
--WHERE location like '%Australia%'
WHERE continent is not NULL
order by 1,2


-- Looking at Countries with Highest Infection Rate compared to Population

SELECT location, population, MAX(Total_Cases) AS Total_Infected_Cases_Per_Country,
MAX((Total_Cases/population)*100) AS Percentage_Population_Infected
FROM PortfolioProject.. Covid_death
--WHERE location like '%russia%'
WHERE continent is not NULL
GROUP BY location, population
order by Percentage_Population_Infected DESC

-- Showing the counties with highest Death Count per population

SELECT location, MAX(total_deaths) AS Total_Death_Count
FROM PortfolioProject.. Covid_death
WHERE location like '%%'AND continent is not NULL
GROUP BY location
order by Total_Death_Count DESC

-- Let's Break Things Down By Continent

SELECT continent, MAX(total_deaths) AS Total_Death_Count
FROM PortfolioProject.. Covid_death
--WHERE location like '%%'
WHERE continent is not NULL
GROUP BY continent
order by Total_Death_Count DESC


-- Showing continents with the higest death count per population

SELECT continent, MAX(total_deaths) AS Total_Death_Count
FROM PortfolioProject.. Covid_death
--WHERE location like '%%'
WHERE continent is not NULL
GROUP BY continent
order by Total_Death_Count DESC


-- Global Numbers

SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, 
SUM(new_deaths)/SUM(new_cases)*100 AS Death_Percent_In_Cases
FROM PortfolioProject.. Covid_death
--WHERE location like '%Australia%'
WHERE new_cases <> 0
and location not in ('World', 'European Union', 'International',
'low income', 'Lower middle income', 'Upper middle income', 'Europe',
'High income') and
continent not in ('World', 'European Union', 'International',
'low income', 'Lower middle income', 'Upper middle income',
'High income')
--Group BY date
--order by 1,2



-- Looking at Total Population vs Vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.Location
ORDER BY dea.location, dea.Date) AS Rolling_People_Vaccinated
--Rolling_People_vaccinated/population)*100
FROM PortfolioProject..Covid_death dea
JOIN PortfolioProject..Covid_vacination vac
ON dea.location = vac.location 
and dea.date = vac.date
WHERE dea.continent is not null 
ORDER BY 2,3

--USE CTE
With PopvsVac (continent, location, date, population, new_vaccinations, Rolling_People_vaccinated)
AS 
(
SELECT dea.continent,dea.date, dea.location, dea.population, vac.new_vaccinations,
SUM(Convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.Location
ORDER BY dea.location, dea.Date) AS Rolling_People_Vaccinated
--Rolling_People_vaccinated/population)*100
FROM PortfolioProject..Covid_death dea
JOIN PortfolioProject..Covid_vacination vac
ON dea.location = vac.location 
and dea.date = vac.date
WHERE dea.continent is not null 
--ORDER BY 2,3
)
SELECT *, (Rolling_People_vaccinated/population)*100
FROM PopvsVac

-- TEMP TABLE

use portfolioproject

DROP TABLE IF exists #Percent_Population_Vaccinated
Create Table #Percent_Population_Vaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rolling_People_vaccinated numeric) 
Insert into #Percent_Population_Vaccinated
SELECT dea.continent, dea.location,  dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.Location
ORDER BY dea.location, dea.Date) AS Rolling_People_Vaccinated
--Rolling_People_vaccinated/population)*100
FROM PortfolioProject..Covid_death dea
JOIN PortfolioProject..Covid_vacination vac
ON dea.location = vac.location 
and dea.date = vac.date
--WHERE dea.continent is not null 
--ORDER BY 2,3

SELECT * ,(Rolling_People_vaccinated/population)*100 AS Percent_Vaccinated_Population
FROM #Percent_Population_Vaccinated 


-- Create view to store data for later visualizations

Create view Percent_Population_Vaccinated AS
SELECT dea.continent, dea.location,  dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.Location
ORDER BY dea.location, dea.Date) AS Rolling_People_Vaccinated
--Rolling_People_vaccinated/population)*100
FROM PortfolioProject..Covid_death dea
JOIN PortfolioProject..Covid_vacination vac
ON dea.location = vac.location 
and dea.date = vac.date
WHERE dea.continent is not null 
--ORDER BY 2,3

SELECT *
FROM Percent_Population_Vaccinated
