

SELECT *
FROM ProyectoParquesIndustriales.dbo.ParquesIndustriales

SELECT *
FROM ProyectoParquesIndustriales.dbo.AnrsAprobados

SELECT *
FROM ParquesIndustriales

-- Updated missing park states (public, private and mixed)
UPDATE ParquesIndustriales
SET caracter = 'MIXTO'
WHERE ID = 117

-- Deleted all duplicated parks using a CTE first, to test the query 
WITH Cte_Parques
AS(
SELECT ID,nombre,
  ROW_NUMBER() OVER (PARTITION BY 
                    ID,nombre
                    ORDER BY ID) AS DUPLICADO
  FROM ParquesIndustriales
)
SELECT *
FROM Cte_Parques


WITH Cte_Parques
AS(
SELECT ID,nombre,
  ROW_NUMBER() OVER (PARTITION BY 
                    ID,nombre
                    ORDER BY ID) AS DUPLICADO
  FROM ParquesIndustriales
)
DELETE DUPLICADO
FROM Cte_Parques

-- Definitive query to delete duplicates
SELECT ID,nombre,
  ROW_NUMBER() OVER (PARTITION BY 
                    ID,nombre
                    ORDER BY ID) AS DUPLICADO
  FROM ParquesIndustriales

DELETE DUPLICADO
FROM ParquesIndustriales


SELECT *
FROM ParquesIndustriales

-- Deleted a NULL row
DELETE
FROM ParquesIndustriales
WHERE nombre IS NULL

-- Made ID autoincrement
ALTER TABLE ParquesIndustriales DROP COLUMN ID

ALTER TABLE ParquesIndustriales ADD ID INT IDENTITY(1,1)

-- Total count of parks
SELECT COUNT(nombre) AS TotalParques
FROM ParquesIndustriales

-- Total count of public parks
SELECT COUNT(caracter) AS TotalParquesPúblicos
FROM ParquesIndustriales
WHERE caracter = 'PÚBLICO MUNICIPAL' OR caracter = 'PÚBLICO PROVINCIAL' OR caracter = 'PÚBLICO'

-- Total count of mix parks
SELECT COUNT(caracter) AS TotalParquesMixtos
FROM ParquesIndustriales
WHERE caracter = 'MIXTO'

-- Total count of private parks
SELECT COUNT(caracter) AS TotalParquesPrivados
FROM ParquesIndustriales
WHERE caracter = 'PRIVADO'

--Total count of how many parks got financial aid (ANR)
SELECT COUNT(parque_industrial) AS ParquesAsistidos
FROM AnrsAprobados

--Total amount of financial aid (ANR)
SELECT AVG(monto_anr) AS MontoTotal
FROM AnrsAprobados

-- See which parks got financial aid(ANR)
SELECT p.RL, a.parque_industrial, a.caracter, a.municipio, a.provincia, a.monto_anr, a.descripcion_obra, a.fecha_aprobacion
FROM ParquesIndustriales p
INNER JOIN AnrsAprobados a
ON p.RL = a.rl

--Added a new park
INSERT INTO ParquesIndustriales VALUES
('RL-2023-86884634-APN-CPI#MDP', 'PARQUE INDUSTRIAL RÍO CUARTO II (CECIS)', 'PÚBLICO', 'INSCRIPTO', '', 'RÍO CUARTO', '', 'CÓRDOBA', '', -33.17519, -64.38300)

SELECT *
FROM ParquesIndustriales

-- Percentage of public, mixed and private parks over the total.
CREATE TABLE #temp_parques(
TotalPublicos int,
TotalMixtos int,
TotalPrivados int,
TotalParques int,
PorcentajePublicos float,
PorcentajeMixtos float,
PorcentajePrivados float)

ALTER TABLE #temp_parques DROP COLUMN PorcentajePublicos, PorcentajeMixtos, PorcentajePrivados

SELECT *
FROM #temp_parques

INSERT INTO #temp_parques VALUES
(310, 26, 48, 384)

SELECT TotalPublicos, TotalParques, (TotalPublicos*100 / TotalParques) AS PorcentajePublicos
FROM #temp_parques

SELECT TotalPublicos, TotalParques, (TotalMixtos*100 / TotalParques) AS PorcentajeMixtos
FROM #temp_parques

SELECT TotalPublicos, TotalParques, (TotalPrivados*100) / (TotalParques) AS PorcentajePrivados
FROM #temp_parques

