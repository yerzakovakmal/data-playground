SELECT * FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY 3, 4;

SELECT * FROM covid_deaths
ORDER BY 3, 4;

SELECT * FROM covid_vaccinations
ORDER BY 3, 4;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid_deaths
ORDER BY 1, 2;

-- Total Cases VS Total Deaths
-- Shows likelihood dying if you contract covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths * 1.0 /total_cases) * 100 AS DeathPercentage
FROM covid_deaths
WHERE location = 'Uzbekistan'
ORDER BY 1, 2;



-- Total Cases VS Population
-- Shows what percentage of population got Covid
SELECT location, date, population, total_cases, (total_cases * 1.0 /population) * 100 AS PercentPopulationInfected
FROM covid_deaths
-- WHERE location = 'Uzbekistan'
ORDER BY 1, 2;

-- Highest Infection count per location
SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases * 1.0 /population)) * 100 AS PercentPopulationInfected
FROM covid_deaths
-- WHERE location = 'Uzbekistan'
GROUP BY population, location
ORDER BY PercentPopulationInfected DESC;

-- Countries with highest death count per population
SELECT location, MAX(CAST(total_deaths as INTEGER)) AS TotalDeathCount
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;


-- Breaking down the datas by continent
-- Showing the continents with the highest death count per population
SELECT continent, MAX(CAST(total_deaths as INTEGER)) AS TotalDeathCount
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Global Numbers

SELECT date, SUM(new_cases) AS total_cases, SUM(cast(new_deaths as INTEGER)) AS total_deaths, SUM(cast(new_deaths as INTEGER)) * 1.0 / SUM(new_cases) * 100 as DeathPercentageGlobally
FROM covid_deaths
GROUP BY date
ORDER BY DeathPercentageGlobally;


-- Total cases AND Total Deaths
SELECT date, SUM(new_cases) AS total_cases, SUM(cast(new_deaths as INTEGER)) AS total_deaths, SUM(cast(new_deaths as INTEGER)) * 1.0 / SUM(new_cases) * 100 as DeathPercentageGlobally
FROM covid_deaths
ORDER BY 1, 2;

---
-- Joining two tables

--- Looking at Total Population VS Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM covid_deaths dea
JOIN covid_vaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3;


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CAST(vac.new_vaccinations AS INTEGER)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM covid_deaths dea
JOIN covid_vaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3;

-- USE CTE
-- How many people in a country is vaccinated?
WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS INTEGER)) 
        OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
FROM covid_deaths dea
JOIN covid_vaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)

SELECT *, (RollingPeopleVaccinated * 1.0/population) * 100 AS Percentage
FROM PopvsVac;


-- TEMP TABLE
DROP TABLE if EXISTS PercentPopulationVaccinated;
CREATE TABLE PercentPopulationVaccinated
(
    continent TEXT,
    location TEXT,
    date TEXT,
    population NUMERIC,
    new_vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
);
--

INSERT INTO PercentPopulationVaccinated
SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS INTEGER)) 
        OVER (
            PARTITION BY dea.location 
            ORDER BY dea.date
        ) AS RollingPeopleVaccinated
FROM covid_deaths dea
JOIN covid_vaccinations vac
    ON dea.location = vac.location
   AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;
--

SELECT *,
       (RollingPeopleVaccinated * 1.0 / population) * 100 AS Percentage
FROM PercentPopulationVaccinated;



-- CREATE VIEW to store data for visualizations
DROP VIEW IF EXISTS PercentPopulationVaccinated;
CREATE VIEW PercentPopulationVaccinated AS
SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS INTEGER))
      OVER (
        PARTITION BY dea.location 
        ORDER BY dea.date
    ) AS RollingPeopleVaccinated
FROM covid_deaths dea
JOIN covid_vaccinations vac
    ON dea.location = vac.location
   AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

-- List view information
SELECT * FROM PercentPopulationVaccinated;

-- List views
SELECT name 
FROM sqlite_master
WHERE type = 'view';