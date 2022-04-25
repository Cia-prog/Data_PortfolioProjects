Select location, AVG(population) as AvgPopulationByLocation, max(cast(total_deaths as int))*100 as TotalDeathByCountry
From PortfolioProject..CovidDeaths_table1$
Where location is not null 
and location not in ('World','Upper middle income','High income','Lower middle income','European Union')
and location not in (select continent from PortfolioProject..CovidDeaths_table1$ where continent is not null)
Group by location
order by TotalDeathByCountry desc
Select * 
From PortfolioProject..CovidDeaths_table1$
Where continent is not null
Order by 3, 4

--Select * 
--From PortfolioProject..CovidVaccination_Table2$
--Order by 3, 4

/**Select Data that we are going to be using **/

Select location, date, total_cases, New_cases, total_deaths, population
From PortfolioProject..CovidDeaths_table1$
where continent is not null
Order by 1,2
/**Looking at Total Cases vs Total Deaths**/

/*****************************Shows likelihood of dying ig you contract covid in your country**************************************/

Select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathRate
From PortfolioProject..CovidDeaths_table1$
Where location Like '%states%'
and continent is not null
Order by 1,2

/**Looking at Total Cases vs Population**/

Select location, date,population, total_cases, (total_cases/population)*100 as InfectedRate
From PortfolioProject..CovidDeaths_table1$
--Where location Like '%states%'
Where continent is not null
Order by 1,2

/**Looking at Countries with Highest Infecteion Rate Compared to Population**/
Select location, Avg(population) as AvgPopulationByLocation, Max(total_cases/population)*100 as InfectedRateByCountry
From PortfolioProject..CovidDeaths_table1$
--Where location Like '%states%'
where continent is not null
Group by location
Order by InfectedRateByCountry desc

/**Looking at the changes Infecteion Rate Compared to Population by Country and Date**/

Select location, date, (total_cases/population)*100 as InfectedRate
From PortfolioProject..CovidDeaths_table1$
--Where location Like '%states%'
Where continent is not null
Order by location, date

/**Looking at Countries with Highest Infecteion Rate Compared to Population**/
Select location, Avg(population) as AvgPopulationByLocation, Max(total_cases/population)*100 as InfectedRateByCountry
From PortfolioProject..CovidDeaths_table1$
where continent is not null
Group by location
--having location like '%united%'

/**Looking at Countries with New InfectedCases Compared to Population Rate with Date **/
Select 
location, date, Avg(population) as AvgPopulationByLocation, Avg(new_cases/population)*100 as NewInfectedRateByCountry
From PortfolioProject..CovidDeaths_table1$
Where population > 50000000
and continent is not null
Group by date, location
Order by date

Select Count(distinct(location)) 
From PortfolioProject..CovidDeaths_table1$
Where continent is not null

select Count(distinct(location)) 
from PortfolioProject..CovidDeaths_table1$
where population > 50000000
and continent is not null


/*******************Looking at Total Deaths Rate Compared to Population per ByCountry **************************/
Select location, Avg(population) as AvgPopulationByLocation, Max(Cast(total_deaths as int)/population)*100 as TotalDeathsRateByCountry
From PortfolioProject..CovidDeaths_table1$
Where location is not null
or location not in (select continent from PortfolioProject..CovidDeaths_table1$)
--where continent is not null
Group by location
Order by TotalDeathsRateByCountry desc

/**Looking at New Death Rate Compared to Population with Date per ByCountry **/

Select 
location, date, Avg(population) as AvgPopulationByLocation, Avg(Cast(new_deaths as int)/population)*100 as NewDeathsRateByCountry
From PortfolioProject..CovidDeaths_table1$
Where population > 50000000
and continent is not null
Group by date, location
Order by date asc


/************Looking at Total Deaths Rate Compared to Population per By Country ***********/
Select location, AVG(population) as AvgPopulationByLocation, Max(Cast(total_deaths as int))*100 as TotalDeathsByCountry
From PortfolioProject..CovidDeaths_table1$
Where location is not null 
and location not in ('World','Upper middle income','High income','Lower middle income','European Union') 
and location not in (select continent from PortfolioProject..CovidDeaths_table1$ where continent is not null)
--where continent is not null
Group by location
Order by TotalDeathsByCountry desc

/************Looking at Total Deaths per By Country ***********/
Select location, AVG(population) as AvgPopulationByCountry, Max(Cast(total_deaths as int)) as TotalDeathsByCountry
From PortfolioProject..CovidDeaths_table1$
Where continent is not null
Group by location
Order by TotalDeathsByCountry desc

/**Looking at Total Deaths By Contitnent **/
Select continent, Avg(population) as AvgPopulationByCountry, Max(Cast(total_deaths as int)) as TotalDeathsByContinent
From PortfolioProject..CovidDeaths_table1$
Where continent is not null
Group by continent
order by TotalDeathsByContinent desc 

/**Looking at Total Death Rate Compared to Population with Date per By Contitnent **/
Select continent, Avg(population) as AvgPopulationByCountry, Max(Cast(total_deaths as int)/population)*100 as TotalDeathRateByContinent
From PortfolioProject..CovidDeaths_table1$
Where continent is not null
Group by continent
Order by TotalDeathRateByContinent desc 


/**GLOBAL New Cases**/
Select date, Sum(new_cases) as GlobalNewCases
From PortfolioProject..CovidDeaths_table1$
--Where location Like '%states%'
where continent is not null
Group by date
Order by date

/**GLOBAL Death Rate**/

Select date, (Sum(Cast(new_deaths as int))/Sum(new_cases))*100 as GlobalDeathRate
From PortfolioProject..CovidDeaths_table1$
--Where location Like '%states%'
Where continent is not null
Group by date
Order by date

----------JOIN----------------------------------

Select * 
From PortfolioProject..CovidDeaths_table1$ death
Join PortfolioProject..CovidVaccination_table2 vac
On death.date=vac.date
 and death.location=vac.location

 /**Looking at Total Population vs vaccinations & vaccination Rate by population**/
Select vac.continent, vac.location, Avg(death.population) as AvgPopulation, Max(vac.total_vaccinations) as TotalVaccinationCount, 
Round((max(vac.total_vaccinations)/Avg(death.population)),4)*100 as VaccinationRateByPopulation
From PortfolioProject..CovidDeaths_table1$ death
Join PortfolioProject..CovidVaccination_table2 vac
On death.date=vac.date
 and death.location=vac.location
Where death.continent is not null
Group by vac.continent,vac.location
Order by VaccinationRateByPopulation desc

 /**Looking at vaccination Rate by date**/
Select vac.continent, vac.date, Round((Max(vac.total_vaccinations)/Avg(death.population)),4)*100 as VaccinationRateByPopulation
From PortfolioProject..CovidDeaths_table1$ death
Join PortfolioProject..CovidVaccination_table2 vac
On death.date=vac.date
 and death.location=vac.location
Where death.continent is not null
Group by vac.date,vac.continent
Having Round((max(vac.total_vaccinations)/avg(death.population)),4)*100 > 100
Order by vac.date

/***********************************Rolling People Vaccinated ************************************************/
Select vac.continent, vac.location, vac.date, death.population, vac.new_vaccinations,
 SUM(Convert(bigint, vac.new_vaccinations)) OVER (PARTITION BY vac.location order by vac.date) as RolllingPeopleVaccinated
From PortfolioProject..CovidDeaths_table1$ death
Join PortfolioProject..CovidVaccination_table2 vac
On death.date=vac.date
 and death.location=vac.location
Where death.continent is not null
Order by 2,3;

 /**************************** CTE (Common Table Expression)  *********************************************************************/
WITH PopulationVsVaccination (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT vac.continent, vac.location, vac.date, death.population, vac.new_vaccinations,
 SUM(Convert(bigint, vac.new_vaccinations)) OVER (PARTITION BY vac.location order by vac.date) as RolllingPeopleVaccinated
FROM PortfolioProject..CovidDeaths_table1$ death
JOIN PortfolioProject..CovidVaccination_table2 vac
ON death.date=vac.date
 and death.location=vac.location
WHERE death.continent is not null
 --Order by 2,3 
 )
SELECT *, RollingPeopleVaccinated/Population as VaccinationVsPopulationRate
FROM PopulationVsVaccination


 /************************************* TEMP TABLE*******************************************************/
DROP TABLE IF EXISTS #VaccinationVsPopulationRateTable
 
 CREATE TABLE #VaccinationVsPopulationRateTable
 (
 Continent varchar(255),
 Location varchar(255),
 Date datetime,
 Population numeric,
 New_vaccination numeric,
 RolllingPeopleVaccinated numeric
 )
INSERT INTO #VaccinationVsPopulationRateTable
SELECT vac.continent, vac.location, vac.date, death.population, vac.new_vaccinations,
 SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY vac.location order by vac.date) as RolllingPeopleVaccinated
FROM PortfolioProject..CovidDeaths_table1$ death
JOIN PortfolioProject..CovidVaccination_table2 vac
ON death.date=vac.date
 and death.location=vac.location
WHERE death.continent is not null
--Order by 2,3 ---

SELECT *, RollingPeopleVaccinated/Population as VaccinationVsPopulationRate
FROM VaccinationVsPopulationRateTable;



/********************************************** Creating View to srote data for later visualizations **************************************/ 
Drop VIEW VaccinationVsPopulationRateTable1

CREATE VIEW VaccinationVsPopulationRateTable1 AS
SELECT vac.continent, vac.location, vac.date, death.population, vac.new_vaccinations,
 Sum(Convert(bigint, vac.new_vaccinations)) OVER (PARTITION BY vac.location ORDER BY vac.date) as RolllingPeopleVaccinated
FROM PortfolioProject..CovidDeaths_table1$ death
JOIN PortfolioProject..CovidVaccination_table2 vac
ON death.date=vac.date
 and death.location=vac.location
WHERE death.continent is not null
  --Order By 2,3
Select * 
From VaccinationVsPopulationRateTable1;