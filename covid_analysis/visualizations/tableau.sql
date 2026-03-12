/*

Queries used for Tableau Project - SQLite version

*/

-- 1.

SELECT 
    SUM(new_cases) AS total_cases,
    SUM(CAST(new_deaths AS INTEGER)) AS total_deaths,
    SUM(CAST(new_deaths AS INTEGER)) * 100.0 / SUM(new_cases) AS DeathPercentage
FROM covid_deaths
WHERE continent IS NOT NULL;


-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International" Location

-- SELECT 
--     SUM(new_cases) AS total_cases,
--     SUM(CAST(new_deaths AS INTEGER)) AS total_deaths,
--     SUM(CAST(new_deaths AS INTEGER)) * 100.0 / SUM(new_cases) AS DeathPercentage
-- FROM CovidDeaths
-- WHERE location = 'World';


-- 2.

-- We take these out as they are not included in the above queries and want to stay consistent
-- European Union is part of Europe

SELECT 
    location, 
    SUM(CAST(new_deaths AS INTEGER)) AS TotalDeathCount
FROM covid_deaths
WHERE continent IS NULL
  AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC;


-- 3.

SELECT 
    Location, 
    Population, 
    MAX(total_cases) AS HighestInfectionCount,  
    MAX((total_cases * 100.0) / population) AS PercentPopulationInfected
FROM covid_deaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;


-- 4.

SELECT 
    Location, 
    Population,
    date, 
    MAX(total_cases) AS HighestInfectionCount,  
    MAX((total_cases * 100.0) / population) AS PercentPopulationInfected
FROM covid_deaths
GROUP BY Location, Population, date
ORDER BY PercentPopulationInfected DESC;






-- Queries originally used, but excluded some because it created too long of video
-- Here only in case you want to check them out


-- 1.

SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population,
    MAX(vac.total_vaccinations) AS RollingPeopleVaccinated
FROM covid_deaths dea
JOIN covid_vaccinations vac
    ON dea.location = vac.location
   AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
GROUP BY dea.continent, dea.location, dea.date, dea.population
ORDER BY 1, 2, 3;


-- 2.

SELECT 
    SUM(new_cases) AS total_cases, 
    SUM(CAST(new_deaths AS INTEGER)) AS total_deaths, 
    SUM(CAST(new_deaths AS INTEGER)) * 100.0 / SUM(new_cases) AS DeathPercentage
FROM covid_deaths
WHERE continent IS NOT NULL;


-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International" Location

-- SELECT 
--     SUM(new_cases) AS total_cases, 
--     SUM(CAST(new_deaths AS INTEGER)) AS total_deaths, 
--     SUM(CAST(new_deaths AS INTEGER)) * 100.0 / SUM(new_cases) AS DeathPercentage
-- FROM covid_deaths
-- WHERE location = 'World';


-- 3.

-- We take these out as they are not included in the above queries and want to stay consistent
-- European Union is part of Europe

SELECT 
    location, 
    SUM(CAST(new_deaths AS INTEGER)) AS TotalDeathCount
FROM covid_deaths
WHERE continent IS NULL
  AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC;


-- 4.

SELECT 
    Location, 
    Population, 
    MAX(total_cases) AS HighestInfectionCount,  
    MAX((total_cases * 100.0) / population) AS PercentPopulationInfected
FROM covid_deaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;


-- 5.

-- SELECT Location, date, total_cases, total_deaths, (total_deaths * 100.0 / total_cases) AS DeathPercentage
-- FROM CovidDeaths
-- WHERE continent IS NOT NULL
-- ORDER BY 1,2

-- took the above query and added population
SELECT 
    Location, 
    date, 
    population, 
    total_cases, 
    total_deaths
FROM covid_deaths
WHERE continent IS NOT NULL 
ORDER BY 1, 2;


-- 6.

WITH PopvsVac (
    Continent, 
    Location, 
    Date, 
    Population, 
    New_Vaccinations, 
    RollingPeopleVaccinated
) AS
(
    SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        vac.new_vaccinations,
        SUM(CAST(vac.new_vaccinations AS INTEGER)) 
            OVER (
                PARTITION BY dea.Location 
                ORDER BY dea.date
            ) AS RollingPeopleVaccinated
    FROM covid_deaths dea
    JOIN covid_vaccinations vac
        ON dea.location = vac.location
       AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL 
)
SELECT 
    *,
    (RollingPeopleVaccinated * 100.0 / Population) AS PercentPeopleVaccinated
FROM PopvsVac;


-- 7.

SELECT 
    Location, 
    Population,
    date, 
    MAX(total_cases) AS HighestInfectionCount,  
    MAX((total_cases * 100.0) / population) AS PercentPopulationInfected
FROM covid_deaths
GROUP BY Location, Population, date
ORDER BY PercentPopulationInfected DESC;