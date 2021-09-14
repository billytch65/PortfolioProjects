

-- Looking at Cases in different countries

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject.dbo.CovidDeaths
Where continent is not null
Order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if contracting Covid in the UK

Select Location, date, total_cases, total_deaths, (Total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths
Where continent is not null and	Location = 'United Kingdom'
Order by 1,2


-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid in the UK

Select Location, date, Population, total_cases, (Total_Cases/population)*100 as InfectedPercentage
From PortfolioProject.dbo.CovidDeaths
Where continent is not null and	Location = 'United Kingdom'
Order by 1,2


-- Looking at Countries with the highest infection rate

Select Location, Population, max(total_cases) as HighestInfectionCount, max((Total_Cases/population))*100 as PercentPopulationInfected
From PortfolioProject.dbo.CovidDeaths
Where continent is not null
Group by Location, Population
Order by PercentPopulationInfected desc


-- Showing the Countries with the highest death count

Select Location, max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject.dbo.CovidDeaths
Where continent is not null
Group by Location
Order by TotalDeathCount desc


-- Showing the continents with the highest death count

Select continent, max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject.dbo.CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeathCount desc


-- LOOKING AT GLOBAL NUMBERS - Death Percentage by day

Select date, sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_Percentage
From PortfolioProject.dbo.CovidDeaths
Where continent is not null
Group by date
Order by 1,2

Select sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_Percentage
From PortfolioProject.dbo.CovidDeaths
Where continent is not null
Order by 1,2



-- Looking at Total Population vs Vaccinations (Using CTE)

With PopvsVac (continent, location, date, population, New_Vaccinations, RollingPeopleVaccinated)
As 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) Over (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100 as Vaccinated_Percentage
From PopvsVac



-- Creating View to store data for future visualisation

Create View UKcasesvsDeath as
Select Location, date, total_cases, total_deaths, (Total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths
Where continent is not null and	Location = 'United Kingdom'
--Order by 1,2


Create View UKcasesvsPopulation as
Select Location, date, Population, total_cases, (Total_Cases/population)*100 as InfectedPercentage
From PortfolioProject.dbo.CovidDeaths
Where continent is not null and	Location = 'United Kingdom'
--Order by 1,2

Create View GlobalVacvsPopulation as
With PopvsVac (continent, location, date, population, New_Vaccinations, RollingPeopleVaccinated)
As 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) Over (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100 as Vaccinated_Percentage
From PopvsVac
