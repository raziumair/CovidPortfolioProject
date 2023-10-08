select *
from PortfolioProject. .CovidDeaths
where continent is not null
order by 3,4

--select specific data
--select location, date, population, total_cases, total_deaths, new_cases, new_cases_per_million, new_cases_smoothed
--from PortfolioProject. .CovidDeaths
--order by 1,2

--change the column from varchar to int
--select location, date, population, total_cases, total_deaths
--from PortfolioProject. .CovidDeaths
--order by 1,2
--alter table  PortfolioProject. .CovidDeaths
--alter column total_cases float

----total_deaths vs total_cases
--death percentage in the Germany
select location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from PortfolioProject. .CovidDeaths
where location like 'germany'
order by 1,2

--looking at total cases vs population
select location, date, population, total_cases, total_deaths, (total_cases/population)*100 as Covidpercentage
from PortfolioProject. .CovidDeaths
--where location like 'germany'
order by 1,2

--looking for which country is more infected
select location, population, Max(total_cases), Max((total_cases/population))*100 as Covidpercentage
from PortfolioProject. .CovidDeaths
--where location like 'germany'
Group by location, population
Order by Covidpercentage ASC

--looking for highest deaths per population
select location, Max(total_deaths) as totaldeathcount
from PortfolioProject. .CovidDeaths
--where location like 'germany'
where continent is not null
Group by location
Order by totaldeathcount desc

--Now let's breaks thing with continents
select continent, Max(total_deaths) as totaldeathcount
from PortfolioProject. .CovidDeaths
--where location like 'germany'
where continent is not null
Group by continent
Order by totaldeathcount desc

--Global Number
select sum(new_cases) as newcases, sum(new_deaths) as newdeaths, (sum(new_deaths)/sum(new_cases))*100 as DeathPercentage
from PortfolioProject. .CovidDeaths
where continent is not null
--Group by location, population
--group by date
--order by 1,2


--Now the Other file about Covid Vaccination
with popvsvac (continent, location, date, population, new_vaccination, vaccinatedpeople) 
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) over (Partition by dea.location order by dea.date) as vaccinatedpeople
from PortfolioProject. .CovidDeaths Dea
join PortfolioProject. .CovidVaccination Vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (vaccinatedpeople/population)*100
from popvsvac

--TEMP Table
drop table if exists #Populationvaccinated
create table #Populationvaccinated
(
continent nvarchar (255),
location nvarchar (255),
date datetime,
population numeric,
new_vaccinated numeric,
vaccinatedpeople numeric
)
insert into #Populationvaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) over (Partition by dea.location order by dea.date) as vaccinatedpeople
from PortfolioProject. .CovidDeaths Dea
join PortfolioProject. .CovidVaccination Vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
select *, (vaccinatedpeople/population)*100
from #Populationvaccinated

select *
from PortfolioProject. .CovidVaccination
alter table PortfolioProject. .CovidVaccination
alter column new_vaccinations float

Create View Populationvaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) over (Partition by dea.location order by dea.date) as vaccinatedpeople
from PortfolioProject. .CovidDeaths Dea
join PortfolioProject. .CovidVaccination Vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null