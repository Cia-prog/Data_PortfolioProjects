/***************************************** Query for Covid Dashboard in TABLEAU *****************************************************/

--1. Just a double cjeck based off the data provided.
---Numbers are extremely close so we will keep them
---The second includes "International" location.

SELECT SUM(CovidDeaths_table1$.new_cases) as TotalCases, SUM(CAST(CovidDeaths_table1$.new_deaths as int)) as TotalDeaths, 
 (SUM(CAST(CovidDeaths_table1$.new_deaths as int))/SUM(CovidDeaths_table1$.new_cases))*100 as DeathRateInfected
From PortfolioProject..CovidDeaths_table1$
Where continent is not null
Order by 1,2
 

--2. We take these out as they are not included in the above queries and want to stay consistent
----European Union is part of Europe

/************Looking at Total Death by continent ***********/
Select continent, SUM(Cast(new_deaths as int)) as TotalDeathsByContinent
From PortfolioProject..CovidDeaths_table1$
--and location not in (select continent from PortfolioProject..CovidDeaths_table1$ where continent is not null)
Where continent is not null
 and location not in ('World','Upper middle income','High income','Lower middle income','European Union','International') 
Group by continent
Order by TotalDeathsByContinent desc

--3. Infected Rate By Population & Country
---Looking at Countries with Highest Infecteion Rate Compared to Population
Select location, Max(population) as PopulationByLocation, Max(total_cases) as HighestTotalCases, (Max(total_cases)/Max(population))*100 as InfectedRateByCountry
From PortfolioProject..CovidDeaths_table1$
Where continent is not null
Group by location
Order by InfectedRateByCountry desc


--4. Rolling Infection Rate Vs Population


--Select vac.continent, vac.location, vac.date, death.population, death.new_cases,
-- SUM(Convert(bigint, death.new_cases)) OVER (PARTITION BY vac.location order by vac.date) as RollingInfectionCases,
-- (SUM(Convert(bigint, death.new_cases)) OVER (PARTITION BY vac.location order by vac.date)/Max(population) OVER (PARTITION BY vac.location))*100 as RollingInfectionRateVsPopulation
--From PortfolioProject..CovidDeaths_table1$ death
--Join PortfolioProject..CovidVaccination_table2 vac
--On death.date=vac.date
-- and death.location=vac.location
--Where death.continent is not null
--Order by 3,1,2

Select vac.continent, vac.date,
 Max(Convert(bigint, death.total_cases)) as RollingTotalCases,
(Max(Convert(bigint, death.total_cases)) /Max(population))*100 as RollingInfectionRateVsPopulation
From PortfolioProject..CovidDeaths_table1$ death
Join PortfolioProject..CovidVaccination_table2 vac
On death.date=vac.date
 and death.location=vac.location
Where death.continent is not null
Group by vac.continent,vac.date
Order by 2,1


