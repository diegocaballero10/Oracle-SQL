-- =====================================================================
-- Practica 1 - Consultas Complejas
-- Curso de Bases de Datos
-- Pontificia Universidad Javeriana
-- Diego Caballero Sarmiento
-- =====================================================================
-- Base de datos: DB_world (country, city, countrylanguage)
-- Motor: Oracle SQL Developer
-- =====================================================================


-- =====================================================================
-- 1) Verificacion inicial
-- =====================================================================

-- 1.b) Estructura de las tablas
DESCRIBE country;
DESCRIBE city;
DESCRIBE countrylanguage;

-- 1.c) Verificar que las tablas tienen datos
SELECT * FROM country;
SELECT * FROM city;
SELECT * FROM countrylanguage;

-- Relacion entre las tablas:
-- country (Code PK) <--- city (CountryCode FK)
-- country (Code PK) <--- countrylanguage (CountryCode FK)
-- Es decir, country es la tabla maestra y las otras dos referencian su
-- clave primaria mediante CountryCode.


-- =====================================================================
-- 2) Busqueda basica
-- =====================================================================

-- 2.a) Diferentes tipos de gobierno en el mundo sin repetir
SELECT DISTINCT GovernmentForm
FROM country;

-- 2.b) Ciudades de Australia
SELECT c.Name
FROM city c
JOIN country co ON c.CountryCode = co.Code
WHERE co.Name = 'Australia';

-- 2.c) Paises con poblacion mayor a 30 millones, orden ascendente
SELECT Name, Population
FROM country
WHERE Population > 30000000
ORDER BY Population ASC;

-- 2.d) Paises con area > 1.000.000 y poblacion < 20.000.000
SELECT Name, SurfaceArea, Population
FROM country
WHERE SurfaceArea > 1000000
  AND Population < 20000000;


-- =====================================================================
-- 3) Busqueda de Strings
-- =====================================================================

-- 3.a) Consulta de ejemplo: ciudades en distritos con 'Aires' pero
--      cuyo nombre no contenga 'La Plata'
SELECT name
FROM city
WHERE district LIKE '%Aires%'
  AND name NOT LIKE '%La Plata%';

-- 3.b) Ciudades con exactamente una 'a' en su nombre y longitud > 22
SELECT name, LENGTH(name) AS longitud
FROM city
WHERE LENGTH(name) - LENGTH(REPLACE(LOWER(name), 'a', '')) = 1
  AND LENGTH(name) > 22;

-- 3.c) Ciudades con un unico tipo de vocal en su nombre
--      (ej: "Haag" solo tiene 'a', "Emmen" solo tiene 'e')
SELECT name
FROM city
WHERE (LOWER(name) NOT LIKE '%e%'
       AND LOWER(name) NOT LIKE '%i%'
       AND LOWER(name) NOT LIKE '%o%'
       AND LOWER(name) NOT LIKE '%u%'
       AND LOWER(name) LIKE '%a%')
   OR (LOWER(name) NOT LIKE '%a%'
       AND LOWER(name) NOT LIKE '%i%'
       AND LOWER(name) NOT LIKE '%o%'
       AND LOWER(name) NOT LIKE '%u%'
       AND LOWER(name) LIKE '%e%')
   OR (LOWER(name) NOT LIKE '%a%'
       AND LOWER(name) NOT LIKE '%e%'
       AND LOWER(name) NOT LIKE '%o%'
       AND LOWER(name) NOT LIKE '%u%'
       AND LOWER(name) LIKE '%i%')
   OR (LOWER(name) NOT LIKE '%a%'
       AND LOWER(name) NOT LIKE '%e%'
       AND LOWER(name) NOT LIKE '%i%'
       AND LOWER(name) NOT LIKE '%u%'
       AND LOWER(name) LIKE '%o%')
   OR (LOWER(name) NOT LIKE '%a%'
       AND LOWER(name) NOT LIKE '%e%'
       AND LOWER(name) NOT LIKE '%i%'
       AND LOWER(name) NOT LIKE '%o%'
       AND LOWER(name) LIKE '%u%');


-- =====================================================================
-- 4) Busqueda con condiciones numericas
-- =====================================================================

-- 4.0) Ejemplo: ciudades con poblacion mayor a 5 millones
SELECT name
FROM city
WHERE population > 5000000;
-- Explicacion: filtra de la tabla city solo aquellas filas cuya columna
-- population supera el valor de 5.000.000.

-- 4.0.1) Ejemplo con subquery y ROWNUM:
SELECT *
FROM (SELECT name FROM country ORDER BY indepyear DESC)
WHERE ROWNUM <= 5;
-- Explicacion: la subconsulta ordena los paises por anio de independencia
-- de mayor a menor; la consulta externa limita a las 5 primeras filas,
-- es decir, los 5 paises mas recientemente independizados.


-- 4.a) Top 5 paises mas densamente poblados (densidad = poblacion / area)
SELECT *
FROM (
    SELECT Name, Population, SurfaceArea,
           Population / SurfaceArea AS Densidad
    FROM country
    WHERE SurfaceArea > 0
    ORDER BY Densidad DESC
)
WHERE ROWNUM <= 5;

-- 4.b) Paises con superficie menor a 1/5 del promedio mundial
SELECT Name, SurfaceArea
FROM country
WHERE SurfaceArea < (SELECT AVG(SurfaceArea) / 5 FROM country);

-- 4.c) Promedio de la expectativa de vida mundial
SELECT AVG(LifeExpectancy) AS expectativa_vida_promedio
FROM country;

-- 4.d) Para cada continente: numero de paises y promedio de poblacion,
--      ordenado por nombre del continente
SELECT Continent,
       COUNT(*) AS num_paises,
       AVG(Population) AS poblacion_promedio
FROM country
GROUP BY Continent
ORDER BY Continent ASC;

-- 4.e) Pais mas poblado de cada continente (6 continentes esperados)
SELECT Continent, Name, Population
FROM country c1
WHERE Population = (
    SELECT MAX(Population)
    FROM country c2
    WHERE c2.Continent = c1.Continent
)
AND Continent IN ('Asia','Europe','Africa','Oceania',
                  'North America','South America')
ORDER BY Continent;


-- =====================================================================
-- 4.f / 4.g) JOIN: ejemplos y reescritura con sintaxis JOIN
-- =====================================================================

-- 4.f.1) Original (sintaxis antigua con WHERE)
SELECT city.name, country.name
FROM city, country
WHERE city.countrycode = country.code
  AND country.name LIKE 'Colombia%'
ORDER BY city.name;

-- 4.g.1) Reescrito con JOIN explicito
SELECT city.name AS ciudad, country.name AS pais
FROM city
JOIN country ON city.countrycode = country.code
WHERE country.name LIKE 'Colombia%'
ORDER BY city.name;

-- 4.f.2) Original: suma de poblacion de ciudades por pais
SELECT country.name, SUM(city.population)
FROM city, country
WHERE city.countrycode = country.code
GROUP BY country.name
ORDER BY country.name DESC;

-- 4.g.2) Reescrito con JOIN explicito
SELECT country.name AS pais,
       SUM(city.population) AS poblacion_ciudades
FROM city
JOIN country ON city.countrycode = country.code
GROUP BY country.name
ORDER BY country.name DESC;


-- =====================================================================
-- 4.h) Consultas adicionales con JOIN
-- =====================================================================

-- 4.h.i) Para cada pais: promedio entre la poblacion conocida y la suma
--        de poblacion de sus ciudades
SELECT country.name AS pais,
       country.population AS poblacion_conocida,
       SUM(city.population) AS poblacion_ciudades,
       (country.population + SUM(city.population)) / 2 AS promedio
FROM country
JOIN city ON city.countrycode = country.code
GROUP BY country.name, country.population
ORDER BY country.name;

-- 4.h.ii) Paises donde se habla ingles como idioma oficial
SELECT country.name AS pais
FROM country
JOIN countrylanguage ON country.code = countrylanguage.countrycode
WHERE countrylanguage.language = 'English'
  AND countrylanguage.isofficial = 'T'
ORDER BY country.name;

-- 4.h.iii) Ciudades de paises que se independizaron entre 1800 y 1900
--          (inclusive)
SELECT city.name AS ciudad,
       country.name AS pais,
       country.indepyear AS anio_independencia
FROM city
JOIN country ON city.countrycode = country.code
WHERE country.indepyear BETWEEN 1800 AND 1900
ORDER BY country.indepyear, city.name;
