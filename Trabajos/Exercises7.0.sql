USE JARDINERIA

						---------------------------
						-- EJERCICIOS UD7 - TSQL -- 
						---------------------------
-------------------------------------------------------------------------------------------
-- NOTA: Recuerda cuidar la limpieza del código (tabulaciones, nombres de tablas en mayúscula,
--		nombres de variables en minúscula, poner comentarios sin excederse, código organizado y fácil de seguir, etc.)
-------------------------------------------------------------------------------------------
-- ¡IMPORTANTE! Siempre que sea posible deberás utilizar variables 	(no es correcto indicar directamente el valor en una SELECT)
--  Esta práctica incorrecta se conoce como "hardcoding" y genera muchos problemas en el código y en su depuración
--  Aquí tenéis más información: https://es.wikipedia.org/wiki/Hard_code
-------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------
-- 1. Crea un script que obtenga el nombre de la gama que tenga más cantidad de productos diferentes
--
-- Salida: 'La gama que más productos tiene es Ornamentales'
-------------------------------------------------------------------------------------------
DECLARE @nombreGama VARCHAR(50)
SELECT @nombreGama = c.nombre
  FROM PRODUCTOS p INNER JOIN CATEGORIA_PRODUCTOS c
    ON p.codCategoria = c.codCategoria
 WHERE p.codCategoria = (SELECT TOP(1) codCategoria
                           FROM PRODUCTOS
                          GROUP BY codCategoria
                          ORDER BY COUNT(codCategoria) DESC               
      )
PRINT CONCAT('La gama que más productos tiene es ', @nombreGama)




-------------------------------------------------------------------------------------------
-- 2. Crea un script que obtenga el nombre del empleado con id 7 y el nombre de su jefe
--
-- Salida: 'El empleado Carlos Soria Jimenez tiene como jefe al empleado Alberto Soria Carrasco'
-------------------------------------------------------------------------------------------

-- Declarar Variables
DECLARE @codEmpleado INT
    SET @codEmpleado = 7
DECLARE @nomEmpleado VARCHAR(160)
DECLARE @nomEmpleadoJefe VARCHAR(160)
--        
SELECT @nomEmpleado = CONCAT(e.nombre, ' ',e.apellido1, ' ',e.apellido2),
       @nomEmpleadoJefe = CONCAT(j.nombre, ' ',j.apellido1, ' ',j.apellido2)
  FROM EMPLEADOS e INNER JOIN EMPLEADOS j
    ON e.codEmplJefe = j.codEmpleado
   AND e.codEmpleado = @codEmpleado

PRINT CONCAT('El empleado ', @nomEmpleado, ' tiene como jefe al empleado ', @nomEmpleadoJefe)




-------------------------------------------------------------------------------------------
-- 3. Crea un script que devuelva el número de pedidos realizados por el cliente 9
--
-- Salida: 'El cliente Naturagua ha realizado 5 pedido/s'
-------------------------------------------------------------------------------------------

-- Declarar Variables
DECLARE @codCliente INT
SET @codCliente = 9
DECLARE @cantPedidos INT
DECLARE @nomCliente VARCHAR(80)


-- Sacar cantPedidos
SELECT @cantPedidos = COUNT(codPedido)
  FROM PEDIDOS 
 WHERE codCliente = @codCliente

-- Sacar nomCliente
 SELECT @nomCliente = nombre_cliente
   FROM CLIENTES
  WHERE codCliente = @codCLiente 

 PRINT CONCAT('El cliente ', @nomCliente, ' ha realizado ', @cantPedidos, ' pedido/s.')




-------------------------------------------------------------------------------------------
-- 4. Crea un script que dado un codPedido en una variable, obtenga la siguiente información:
--		nombre_cliente, Fecha pedido, estado
--
-- Salida: 'El pedido XXXX realizado por el cliente YYYYYYY se realizó el ZZ/ZZ/ZZZZ y su estado es EEEEEEEE
-------------------------------------------------------------------------------------------
DECLARE @codPedido INT
  SET @codPedido = NEWID(PRODUCTOS)
DECLARE @nombre_cliente VARCHAR(100)
DECLARE @FechaPedido DATE
DECLARE @estado CHAR(1)
SELECT @codPedido = p.codPedido,
       @nombre_cliente = nombre_cliente,
       @FechaPedido = p.fecha_pedido,
       @estado = p.codEstado
  FROM CLIENTES c INNER JOIN PEDIDOS p
    ON c.codCliente = p.codCliente
   AND p.codPedido = @codPedido


PRINT CONCAT('El pedido ', @codPedido, ' realizado por el cliente ',
             @nombre_cliente, ' se realizo el ', @FechaPedido, ' y su estado es ', @estado) 



-------------------------------------------------------------------------------------------
-- 5. Crea un script que dadas dos variables: porcentaje y gama
--		Incremente el precio de los productos de dicha gama en el porcentaje que se le pasa
--
-- Salida: 'Se ha aumentado el precio un XXXX% de la gama YYYY'
-------------------------------------------------------------------------------------------




-------------------------------------------------------------------------------------------
-- 6. Crea un script que devuelva cuántos clientes han realizado algún pedido de
--   al menos 3 productos (siendo el número de productos una variable).
--	
-- Salida: 'Existen XXXX clientes en la BD que han realizado pedidos de al menos YYYY productos'
-------------------------------------------------------------------------------------------





-------------------------------------------------------------------------------------------
-- 7. Crea un script que a partir de una variable codCliente devuelva el nombre completo de su
-- 		representante de ventas y la ciudad de la oficina en la que trabaja.
--	
-- Salida: 'El cliente XXXX tiene como representante a YYYY y trabaja en la ciudad de ZZZZ'
-------------------------------------------------------------------------------------------



USE JARDINERIA



DECLARE @i INT = 1

/*
WHILE @i <= 30
BEGIN
    IF @i % 5 = 0
    BEGIN
        PRINT @i
    END
    SET @i += 1
END
*/
WHILE @i <= 200
BEGIN
    IF @i % 7 = 0 AND @i <> 7
    BEGIN
        PRINT @i
        BREAK
    END
    SET @i += 1
END

DECLARE @minCodCliente INT
DECLARE @maxCodCliente INT

DECLARE @nombreCliente VARCHAR(50)

SELECT @minCodCliente = MIN(codCliente),
       @maxCodCliente = MAX(codCliente)
  FROM CLIENTES

WHILE @minCodCliente <= @maxCodCliente
BEGIN
    SET @nombreCliente = NULL
    SELECT @nombreCliente = nombre_cliente
      FROM CLIENTES
     WHERE codCliente = @minCodCliente
    IF @nombreCliente IS NOT NULL
    BEGIN
        PRINT(@nombreCliente) 
    END
    SET @minCodCliente += 1
END
