Select *
From PortfolioProject..CovidDeaths
Order by 3,

--Select  *
--From PortfolioProject..CovidVaccination
--Order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Order by 1,2

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%Ghana%'
Order by 1,2

Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulation
From PortfolioProject..CovidDeaths
--Where location like '%state%'
Order by 1,2

Select location, population, Max( total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%state%'
Group by location, population
Order by PercentPopulationInfected desc

Select location, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%state%'
where continent is not null
Group by location
Order by TotalDeathCount desc

Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%state%'
where continent is not null
Group by continent
Order by TotalDeathCount desc


Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as toatal_deaths, SUM(cast(new_deaths as int))/SUM(new_cases) as NewDeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Group  by date
Order by 1,2 

Select *
From PortfolioProject..CovidDeaths dea
Join PortfolioProject.. CovidVaccination vac
     On dea.location = vac.location
	 and dea.date = vac.date

	 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject.. CovidVaccination vac
     On dea.location = vac.location
	 and dea.date = vac.date
  where dea.continent is not null
  order by 2,3

  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) Over (Partition by dea.location)
From PortfolioProject..CovidDeaths dea
Join PortfolioProject.. CovidVaccination vac
     On dea.location = vac.location
	 and dea.date = vac.date
  where dea.continent is not null
  order by 2,3

  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(int, vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.date) as NewPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject.. CovidVaccination vac
     On dea.location = vac.location
	 and dea.date = vac.date
  where dea.continent is not null
  order by 2,3


  With PopvsVac(Continent, location, date, population, New_Vaccinations, NewPeopleVaccinated)
  as
  (
    Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(int, vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.date) as NewPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject.. CovidVaccination vac
     On dea.location = vac.location
	 and dea.date = vac.date
  where dea.continent is not null
  --order by 2,3
  )
  Select *, (NewPeopleVaccinated/population)*100
  From PopvsVac


  Create Table #PercentPopulationVaccinated
  (
  Continent nvarchar(255),
  location nvarchar(255),
  date datetime,
  population numeric,
  new_vaccinations numeric,
  NewPeopleVaccinated numeric
  )

	Insert into #PercentPopulationVaccinated
    Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(int, vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.date) as NewPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject.. CovidVaccination vac
     On dea.location = vac.location
	 and dea.date = vac.date
  where dea.continent is not null
  --order by 2,3
  
  Select *, (NewPeopleVaccinated/population)*100
  From #PercentPopulationVaccinated



  Drop table if exists #PercentPopulationVaccinated
   Create Table #PercentPopulationVaccinated
  (
  Continent nvarchar(255),
  location nvarchar(255),
  date datetime,
  population numeric,
  new_vaccinations numeric,
  NewPeopleVaccinated numeric
  )

	Insert into #PercentPopulationVaccinated
    Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(int, vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.date) as NewPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject.. CovidVaccination vac
     On dea.location = vac.location
	 and dea.date = vac.date
  where dea.continent is not null
  --order by 2,3
  
  Select *, (NewPeopleVaccinated/population)*100
  From #PercentPopulationVaccinated


 Create View PercentPopulationVaccinated as
   Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(int, vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.date) as NewPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject.. CovidVaccination vac
     On dea.location = vac.location
	 and dea.date = vac.date
  where dea.continent is not null
  --order by 2,3

 
 Create View NewDeathPercentage as
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as toatal_deaths, SUM(cast(new_deaths as int))/SUM(new_cases) as NewDeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Group  by date
--Order by 1,2 

Create View PercentPopulationInfected as
Select location, population, Max( total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%state%'
Group by location, population
--Order by PercentPopulationInfected desc

Select *
From PercentPopulationInfected


Select *
FRom  NewDeathPercentage 
where total_cases < 1000 