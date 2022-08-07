select location , date , total_cases , new_cases , total_deaths , population
from `serene-voltage-351210.Covid_data.covid_death`
order by total_cases;

#total cases vs total deaths

select location , date , total_cases , total_deaths , (total_deaths/total_cases)*100 as deathpercentage
from `serene-voltage-351210.Covid_data.covid_death`
where location like '%Indi0a%'
order by deathpercentage  desc;

#looking at total cases vs population
select location , date , total_cases ,population , (total_cases/population)*100 as casepercentage
from `serene-voltage-351210.Covid_data.covid_death`
where location like '%India%'
order by casepercentage  desc;

#countries with highest infection rate
select location , population , max(total_cases) as highestinfectioncount ,  max((total_cases/population))*100 as percentagepopulationinfected
from `serene-voltage-351210.Covid_data.covid_death`
group by location , population
order by percentagepopulationinfected desc ;

#countries with higest death rate
select location ,  max(total_deaths) as deathcount
from `serene-voltage-351210.Covid_data.covid_death`
where continent is not null
group by location
order by deathcount desc ;

#population vs vaccination
select dea.continent  ,  dea.location ,dea.date ,  dea.population, vac.new_vaccinations,sum(cast(vac.new_vaccinations as int64)) over(partition by dea.location order by  dea.location, dea.date) as rollingpeoplevaccinated

from `serene-voltage-351210.Covid_data.covid_death` dea
join `serene-voltage-351210.Covid_data.covid_vaccination` vac
   on dea.location   =  vac.location
  and dea.date  =  vac.date
where dea.continent is not null
order by 2,3;

#USING CTE
with cte as (
select dea.continent  ,  dea.location ,dea.date ,  dea.population, vac.new_vaccinations,sum(cast(vac.new_vaccinations as int64)) over(partition by dea.location order by  dea.location, dea.date) as rollingpeoplevaccinated

from `serene-voltage-351210.Covid_data.covid_death` dea
join `serene-voltage-351210.Covid_data.covid_vaccination` vac
   on dea.location   =  vac.location
  and dea.date  =  vac.date

where dea.continent is not null
--order by 1,2,3

)
select * , (rollingpeoplevaccinated/population)*100 from cte

#CREATING VIEWS 
create view Covid_data.percentagepopulationvaccinated  as
select dea.continent  ,  dea.location ,dea.date ,  dea.population, vac.new_vaccinations,sum(cast(vac.new_vaccinations as int64)) over(partition by dea.location order by  dea.location, dea.date) as rollingpeoplevaccinated

from `serene-voltage-351210.Covid_data.covid_death` dea
join `serene-voltage-351210.Covid_data.covid_vaccination` vac
   on dea.location   =  vac.location
  and dea.date  =  vac.date

where dea.continent is not null
#order by 1,2,3






