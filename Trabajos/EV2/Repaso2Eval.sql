CREATE DATABASE REPASO2EVAL
USE REPASO2EVAL
/*
CREACIÓN / MODIFICACIÓN DE TABLAS
Crea las siguientes tablas:
STREAMERS (codStreamer, nombre, apellidos, pais, edad)
PK: codStreamer (NO se incrementa automáticamente)
*/
CREATE TABLE STREAMERS (
    codStreamer         INT,
    nombre              VARCHAR(100) NOT NULL,
    apellidos           VARCHAR(100),
    pais                VARCHAR(50),
    edad               TINYINT

    CONSTRAINT PK_STREAMERS PRIMARY KEY (codStreamer)
)

ALTER TABLE STREAMERS 
ADD CONSTRAINT CK_STREAMERS_EDAD CHECK(edad BETWEEN 1 AND 150)

CREATE INDEX IX_STREAMERS_nombre
    ON STREAMERS (nombre)


/*
TEMATICAS (codTematica, nombre)
PK: codTematica (se incrementa automáticamente)
*/
CREATE TABLE TEMATICAS (
    codTematica INT IDENTITY,
    nombre      VARCHAR(200) NOT NULL

    CONSTRAINT PK_TEMATICAS PRIMARY KEY (codTematica)
)
/*
CANALES (codStreamer, codTematica, idioma, medio, milesSeguidores)
PK: codStreamer, codTematica
FK: codStreamer  STREAMERS
FK: codTematica  TEMATICAS
*/
CREATE TABLE CANALES (
    codStreamer INT,
    codTematica INT,
    idioma      VARCHAR(200),
    medio       VARCHAR(200),
    milesSeguidores     DECIMAL(9,2)

    CONSTRAINT PK_CANALES PRIMARY KEY (codStreamer, codTematica),
    CONSTRAINT FK_CANALES_STREAMERS FOREIGN KEY (codStreamer) REFERENCES STREAMERS(codStreamer),
    CONSTRAINT FK_CANALES_TEMATICAS FOREIGN KEY (codTematica) REFERENCES TEMATICAS(codTematica)
)

/*
GESTIÓN DE TABLAS
Inserta los siguientes STREAMERS:
-	Ibai Llanos de España
-	AuronPlay de España
-	Nate Gentile de España
-	Linus Tech Tips de Canadá
-	DYI Perks sin ningún país
-	Alexandre Chappel de Noruega
-	Tekendo de España
-	Caddac Tech de ningún país
*/
INSERT INTO STREAMERS(codStreamer, nombre, apellidos, pais)
VALUES  (1, 'Ibai', 'Llanos', 'España'),
        (2, 'AuronPlay', null, 'España'),
        (3,	'Nate', 'Gentile','España'),
        (4,	'Linus Tech Tips', null, 'Canadá'),
        (5, 'DYI Perks', null, null),
        (6, 'Alexandre', 'Chappel', 'Noruega'),
        (7, 'Tekendo', null, 'España'),
        (8, 'Caddac Tech', null, null)

SELECT * FROM STREAMERS
/*
Inserta los siguientes TEMAS:
-	Informática
-	Tecnología en general
-	Gaming
-	Variado
-	Bricolaje
-	Viajes
-	Humor
*/
INSERT INTO TEMATICAS (nombre)
VALUES  ('Informática'),
        ('Tecnología en general'),
        ('Gaming'),
        ('Variado'),
        ('Bricolaje'),
        ('Viajes'),
        ('Humor')
/*
Inserta las siguientes TEMATICAS de STREAMERS:
STREAMER	TEMATICA	idioma	medio	milesSeguidores
1, 'Variado', 'Español', 'Twitch', 12800
2	'Gaming'	'Español'	'YouTube'	29200
2  'Variado', 'Español', 'Twitch', 14900
3   'Informática'	'Español'	'YouTube'	2450
4 'Informática'	'Inglés'	'YouTube'	15200
5 'Bricolaje'	'Inglés'	'YouTube'	4140
6 'Bricolaje'	'Inglés'	'YouTube'	370
8 'Informática'	'Inglés'	'YouTube'	3
*/
SELECT * FROM TEMATICAS

INSERT INTO CANALES (codStreamer, codTematica, idioma, medio, milesSeguidores)
VALUES  (1, 4, 'Español', 'Twitch', 12800),
        (2, 4, 'Español', 'Twitch', 14900),
        (3, 1, 'Español', 'YouTube', 2450),
        (4, 1, 'Inglés', 'YouTube', 15200),
        (5, 5, 'Inglés', 'YouTube', 4140),
        (6, 5, 'Inglés', 'YouTube', 370),
        (8, 1, 'Inglés', 'YouTube', 3)

        

-----------------
--  CONSULTAS  --
-----------------
-- 01. Nombre de las temáticas que tenemos almacenadas, ordenadas alfabéticamente.
SELECT nombre
  FROM TEMATICAS
 ORDER BY nombre ASC
-- 02. Cantidad de streamers cuyo país es "España".
SELECT COUNT(codStreamer)
  FROM  STREAMERS
 WHERE pais IN ('España')
-- 03, 04, 05. Nombres de streamers cuya segunda letra no sea una "B" (quizá en minúsculas), de 3 formas distintas.
SELECT nombre
  FROM STREAMERS
 WHERE RIGHT(LEFT(nombre, 2), 1) NOT IN ('b', 'B')

 SELECT nombre
  FROM STREAMERS
 WHERE nombre NOT LIKE '%_B%'
   OR nombre NOT LIKE '%_b%'

 SELECT nombre 
   FROM STREAMERS
  WHERE SUBSTRING(nombre, 2, 1) NOT IN ('b', 'B') 
-- 06. Media de suscriptores para los canales cuyo idioma es "Español".
SELECT AVG(st.milesSeguidores)
  FROM CANALES st, STREAMERS s
 WHERE s.codStreamer = st.codStreamer
   AND st.idioma LIKE '%Español%'
-- 07. Media de seguidores para los canales cuyo streamer es del país "España".
SELECT s.nombre
  FROM STREAMERS s, CANALES st 
 WHERE s.codStreamer = st.codStreamer
   AND s.pais = 'España'
-- 08. Nombre de cada streamer y medio en el que habla, para aquellos que tienen entre 5.000 y 15.000 miles de seguidores, 
    --usando BETWEEN.
SELECT s.nombre, st.medio
  FROM STREAMERS s, CANALES st 
 WHERE s.codStreamer = st.codStreamer
   AND milesSeguidores BETWEEN 5000 AND 15000
-- 09. Nombre de cada streamer y medio en el que habla, para aquellos que tienen entre 5.000 y 15.000 miles de seguidores, sin usar BETWEEN.
SELECT s.nombre, st.medio
  FROM STREAMERS s, CANALES st 
 WHERE s.codStreamer = st.codStreamer
   AND milesSeguidores >= 5000
   AND milesSeguidores <= 15000
-- 10. Nombre de cada temática y nombre de los idiomas en que tenemos canales de esa temática 
--(quizá ninguno), sin duplicados.
SELECT DISTINCT t.nombre, st.idioma
  FROM TEMATICAS t, CANALES st 
 WHERE t.codTematica = st.codTematica
  
-- 11. Nombre de cada streamer, nombre de la temática de la que habla y del medio en el que habla de esa temática, usando INNER JOIN.
SELECT s.nombre, st.codTematica, st.medio
  FROM STREAMERS s INNER JOIN CANALES st
    ON s.codStreamer = st.codStreamer
-- 12. Nombre de cada streamer, nombre de la temática de la que habla y del medio en el que habla de esa temática, usando WHERE.
SELECT s.nombre, st.codTematica, st.medio
  FROM STREAMERS s,
        CANALES st
 WHERE s.codStreamer = st.codStreamer
-- 13. Nombre de cada streamer, del medio en el que habla y de la temática de la que habla en ese medio, 
  --incluso si de algún streamer no tenemos dato del medio o de la temática.
SELECT s.nombre, st.codTematica, st.medio
  FROM STREAMERS s LEFT JOIN CANALES st
    ON s.codStreamer = st.codStreamer
-- 14. Nombre de cada medio y cantidad de canales que tenemos anotados en él, ordenado alfabéticamente por el nombre del medio.
SELECT c.medio, COUNT(c.medio)
  FROM CANALES c
 GROUP BY c.medio
 ORDER BY c.medio ASC

-- 15, 16, 17, 18. Medio en el que se emite el canal de más seguidores, de 4 formas distintas.
SELECT c.medio
  FROM CANALES c
 WHERE milesSeguidores >= ALL (SELECT milesSeguidores FROM CANALES)

 SELECT c.medio
  FROM CANALES c
 WHERE milesSeguidores = (SELECT MAX(milesSeguidores) FROM CANALES)

SELECT TOP(1) medio 
  FROM CANALES
 ORDER BY milesSeguidores DESC
 
-- 19. Categorías de las que tenemos 2 o más canales.
SELECT t.nombre, COUNT(c.codTematica) cantStreamers
  FROM CANALES c, TEMATICAS t
 WHERE c.codTematica = t.codTematica
 GROUP BY t.codTematica, t.nombre
 HAVING (COUNT(c.codTematica) >= 2)
-- 20. Categorías de las que no tenemos anotado ningún canal, ordenadas alfabéticamente, 
  --empleando COUNT.
SELECT t.nombre
  FROM TEMATICAS t LEFT JOIN CANALES c 
    ON t.codTematica = c.codTematica 
 GROUP BY t.codTematica, t.nombre
HAVING COUNT(t.codTematica) = 0
-- 21. Categorías de las que no tenemos anotado ningún canal, ordenadas alfabéticamente, 
--empleando IN / NOT IN.
SELECT t.nombre
  FROM TEMATICAS t
 WHERE t.codTematica NOT IN (SELECT codTematica FROM CANALES)

-- 22. Categorías de las que no tenemos anotado ningún canal, ordenadas alfabéticamente, empleando ALL / ANY.
SELECT t.nombre
  FROM TEMATICAS t
 WHERE t.codTematica <> ALL (SELECT codTematica FROM CANALES)
-- 23. Categorías de las que no tenemos anotado ningún canal, ordenadas alfabéticamente, empleando EXISTS / NOT EXISTS.
SELECT t.nombre
  FROM TEMATICAS t
 WHERE NOT EXISTS(SELECT 1 FROM CANALES c WHERE c.codTematica = t.codTematica)
-- 24. Tres primeras letras de cada país y tres primeras letras de cada idioma, en una misma lista.
SELECT s.pais
  FROM STREAMERS s, CANALES c
 WHERE LEFT(s.pais, 2) LIKE LEFT(c.idioma, 2)
-- 25, 26, 27, 28. Tres primeras letras de países que coincidan con las tres primeras letras de un idioma, sin duplicados, de cuatro formas distintas.


-- 29. Nombre de streamer, nombre de medio y nombre de temática, para los canales que están por encima de la media de suscriptores.

-- 30. Nombre de streamer y medio, para los canales que hablan de la temática "Bricolaje".

-- 31. Crea una tabla de "juegos". Para cada juego querremos un código (clave primaria), un nombre (hasta 20 letras, no nulo) y una referencia al streamer que más habla de él (clave ajena a la tabla "streamers").

-- 32. Añade a la tabla de juegos la restricción de que el código debe ser 1000 o superior.

-- 33. Añade 3 datos de ejemplo en la tabla de juegos. Para uno indicarás todos los campos, para otro no indicarás el streamer, ayudándote de NULL, y para el tercero no indicarás el streamer porque no detallarás todos los nombres de los campos.

-- 34. Borra el segundo dato de ejemplo que has añadido en la tabla de juegos, a partir de su código.


-- 35. Muestra el nombre de cada juego junto al nombre del streamer que más habla de él, si existe. Los datos aparecerán ordenados por nombre de juego y, en caso de coincidir éste, por nombre de streamer.

-- 36. Modifica el último dato de ejemplo que has añadido en la tabla de juegos, para que sí tenga asociado un streamer que hable de él.

-- 37. Crea una tabla "juegosStreamers", volcando en ella el nombre de cada juego (con el alias "juego") y el nombre del streamer que habla de él (con el alias "streamer").

-- 38. Añade a la tabla "juegosStreamers" un campo "fechaPrueba".

-- 39. Pon la fecha de hoy (prefijada, sin usar GetDate) en el campo "fechaPrueba" de todos los registros de la tabla "juegosStreamers".

-- 40. Muestra juego, streamer y fecha de ayer (día anterior al valor del campo "fechaPrueba") para todos los registros de la tabla "juegosStreamers".

-- 41. Muestra todos los datos de los registros de la tabla "juegosStreamers" que sean del año actual de 2 formas distintas (por ejemplo, usando comodines o funciones de cadenas).

-- 42. Elimina la columna "streamer" de la tabla "juegosStreamers".

-- 43. Vacía la tabla de "juegosStreamers", conservando su estructura.

-- 44. Elimina por completo la tabla de "juegosStreamers".

-- 45. Borra los canales del streamer "Caddac Tech".

-- 46. Muestra la diferencia entre el canal con más seguidores y la media, mostrada en millones de seguidores. Usa el alias "diferenciaMillones".

-- 47. Medios en los que tienen canales los creadores de código "ill", "ng" y "ltt", sin duplicados, usando IN (pero no en una subconsulta).

-- 48. Medios en los que tienen canales los creadores de código "ill", "ng" y "ltt", sin duplicados, sin usar IN.

-- 49. Nombre de streamer y nombre del medio en el que habla, para aquellos de los que no conocemos el país.

-- 50. Nombre del streamer y medio de los canales que sean del mismo medio que el canal de Ibai Llanos que tiene 12800 miles de seguidores (puede aparecer el propio Ibai Llanos).

-- 51. Nombre del streamer y medio de los canales que sean del mismo medio que el canal de Ibai Llanos que tiene 12800 miles de seguidores (sin incluir a Ibai Llanos).

-- 52. Nombre de cada streamer, medio y temática, incluso si para algún streamer no aparece ningún canal o para alguna temática no aparece ningún canal.

-- 53. Nombre de medio y nombre de cada temática, como parte de una única lista (quizá desordenada).

-- 54. Nombre de medio y nombre de cada temática, como parte de una única lista ordenada alfabéticamente.

-- 55. Nombre de medio y cantidad media de suscriptores en ese medio, para los que están por encima de la media de suscriptores de los canales.

-- 56. Nombre de los streamers que emiten en YouTube y que o bien hablan en español o bien sus miles de seguidores están por encima de 12.000.

-- 57. Añade información ficticia sobre ti: datos como streamer, temática sobre la que supuestamente y medio en el que hablas sobre ella, sin indicar cantidad de seguidores. Crea una consulta que muestre todos esos datos a partir de tu código.

-- 58. Muestra el nombre de cada streamer, medio en el que emite y cantidad de seguidores, en millones, redondeados a 1 decimal.

-- 59. Muestra el nombre de cada streamer y el país de origen. Si no se sabe este dato, deberá aparecer "(País desconocido)".

-- 60. Muestra, para cada streamer, su nombre, el medio en el que emite (precedido por "Emite en: ") y el idioma de su canal (precedido por "Idioma: ")

SELECT s.nombre,
       CONCAT('Emite en: ', c.medio),
       CONCAT('Idioma: ', c.idioma)
  FROM CANALES c,
       STREAMERS s
 WHERE c.codStreamer = s.codStreamer