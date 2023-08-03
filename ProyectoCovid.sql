/*
Covid 19 Exploraci�n de datos 

Habilidades utilizadas: Joins, CTE's, Tablas temporales, Windows Functions, Aggregate Functions, Vistas, Convertir tipos de datos

*/

Select *
From CovidDeaths
Where continent is not null 
order by 3,4


-- Seleccionar datos con los que vamos a empezar

Select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
Where continent is not null 
order by 1,2


-- Total de casos vs Total de muertes
-- Muestra las probabilidades de morir si contraes covid en tu pais

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as PorcentajeMuertes
From CovidDeaths
Where location like '%Argentina%'
and continent is not null 
order by 1,2


-- Casos totales vs Poblaci�n
-- Muestra el porcentaje de la poblaci�n infectada por covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PorcentajePoblacioninfectada
From CovidDeaths
--Where location like '%Argentina%'
order by 1,2


-- Paises con mayor tasa de infecci�n respecto a poblaci�n

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as TasaInfeccionPoblacion
From CovidDeaths
--Where location like '%Argentina%'
Group by Location, Population
order by TasaInfeccionPoblacion desc


-- Paises con m�s muertes por poblaci�n

Select Location, MAX(cast(Total_deaths as int)) as TotalMuertes
From CovidDeaths
--Where location like '%Argentina%'
Where continent is not null 
Group by Location
order by TotalMuertes desc



-- SEPARANDO POR CONTINENTE

-- Mostrando continentes con m�s muertes por poblaci�n

Select continent, MAX(cast(Total_deaths as int)) as TotalMuertes
From CovidDeaths
--Where location like '%Argentina%'
Where continent is not null 
Group by continent
order by TotalMuertes desc



-- NUMEROS GLOBALES

Select SUM(new_cases) as total_casos, SUM(cast(new_deaths as int)) as total_muertes, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as PorcentajeMuertes
From CovidDeaths
--Where location like '%Argentina%'
where continent is not null
order by 1,2



-- Poblaci�n total vs Vacunaciones
-- Muestra porcentaje de la poblaci�n que recibi� al menos UNA dosis

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as SumaGenteVacunada
--, (SumaGenteVacunada/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Usando CTE para hacer calculo de Partition By en la consulta previa

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, SumaGenteVacunada)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as SumaGenteVacunada
--, (SumaGenteVacunada/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (SumaGenteVacunada/Population)*100 as PorcentajeGenteVacunada
From PopvsVac



-- Usando tabla temporal para hacer calculo de Partition By en la consulta previa

DROP Table if exists #PorcentajeGenteVacunada
Create Table #PorcentajeGenteVacunada
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
SumaGenteVacunada numeric
)

Insert into #PorcentajeGenteVacunada
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as SumaGenteVacunada
--, (SumaGenteVacunada/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (SumaGenteVacunada/Population)*100
From #PorcentajeGenteVacunada




-- Creando vista para almacenar datos para futuras visualizaciones

Create View PorcentajeGenteVacunada as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as SumaGenteVacunada
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

