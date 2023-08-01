

SELECT *
FROM ProyectoParquesIndustriales.dbo.ParquesIndustriales

SELECT *
FROM ProyectoParquesIndustriales.dbo.AnrsAprobados

SELECT *
FROM ParquesIndustriales

-- Puse los caracter que faltaban, habia algunos publicos y privados tambien
UPDATE ParquesIndustriales
SET caracter = 'MIXTO'
WHERE ID = 117

-- Borre todos los parques duplicados usando una CTE primero, para probar la consulta 
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

-- Aca hice la consulta definitiva para borrar los duplicados
SELECT ID,nombre,
  ROW_NUMBER() OVER (PARTITION BY 
                    ID,nombre
                    ORDER BY ID) AS DUPLICADO
  FROM ParquesIndustriales

DELETE DUPLICADO
FROM ParquesIndustriales


SELECT *
FROM ParquesIndustriales

-- Aca borre una fila que aparecia toda como NULL
DELETE
FROM ParquesIndustriales
WHERE nombre IS NULL

-- Reinicie los ID borrando y volviendo a crear la columna, haciendola autoincrementable
ALTER TABLE ParquesIndustriales DROP COLUMN ID

ALTER TABLE ParquesIndustriales ADD ID INT IDENTITY(1,1)

-- Cuento la cantidad total de parques
SELECT COUNT(nombre) AS TotalParques
FROM ParquesIndustriales

-- Cuento la cantidad total de parques públicos
SELECT COUNT(caracter) AS TotalParquesPúblicos
FROM ParquesIndustriales
WHERE caracter = 'PÚBLICO MUNICIPAL' OR caracter = 'PÚBLICO PROVINCIAL' OR caracter = 'PÚBLICO'

-- Cuento la cantidad total de parques mixtos
SELECT COUNT(caracter) AS TotalParquesMixtos
FROM ParquesIndustriales
WHERE caracter = 'MIXTO'

-- Cuento la cantidad total de parques privados
SELECT COUNT(caracter) AS TotalParquesPrivados
FROM ParquesIndustriales
WHERE caracter = 'PRIVADO'

--Contar cuantos parques recibieron ANR
SELECT COUNT(parque_industrial) AS ParquesAsistidos
FROM AnrsAprobados

--Monto total de los ANR
SELECT AVG(monto_anr) AS MontoTotal
FROM AnrsAprobados

-- Ver cuales parques fueron asistidos con ANR de todos los de la base
SELECT p.RL, a.parque_industrial, a.caracter, a.municipio, a.provincia, a.monto_anr, a.descripcion_obra, a.fecha_aprobacion
FROM ParquesIndustriales p
INNER JOIN AnrsAprobados a
ON p.RL = a.rl

--Agrego el parque nuevo que se inscribió
INSERT INTO ParquesIndustriales VALUES
('RL-2023-86884634-APN-CPI#MDP', 'PARQUE INDUSTRIAL RÍO CUARTO II (CECIS)', 'PÚBLICO', 'INSCRIPTO', '', 'RÍO CUARTO', '', 'CÓRDOBA', '', -33.17519, -64.38300)

SELECT *
FROM ParquesIndustriales

-- Calculo el porcentaje de parques publicos, mixtos y privados sobre el total
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


