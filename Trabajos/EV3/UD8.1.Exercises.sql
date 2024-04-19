USE JARDINERIA

				---------------------------
				--   UD8  -  PROC & FUNC -- 
				---------------------------
-------------------------------------------------------------------------------------------
-- NOTA: Recuerda cuidar la limpieza del código (tabulaciones, nombres de tablas en mayúscula,
--		nombres de variables en minúscula, poner comentarios sin excederse, código organizado y fácil de seguir, etc.)
-------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------
-- 1. Implementa un procedimiento llamado 'getNombreCliente' que devuelva el nombre de un cliente a partir de su código.
--		Parámetros de entrada:  codCliente INT
--		Parámetros de salida:   nombreCliente VARCHAR(50)
--		Tabla:                  CLIENTES
--		
--		El procedimiento devolverá 0 si finaliza correctamente.
--		Debes utilizar TRY/CATCH, validación de parámetros y transacciones si fueran necesarias.
--	
--	  * Comprueba que el funcionamiento es correcto realizando una llamada desde un script y comprobando la finalización del mismo
--      Recuerda utilizar en el script:
--              EXEC @ret = getNombreCliente @codCliente, @nombreCliente OUTPUT
--              IF @ret <> 0 ...
-------------------------------------------------------------------------------------------
GO




CREATE OR ALTER PROCEDURE getNombreCliente(@codCliente INT, @nombre VARCHAR(50) OUTPUT)
AS
BEGIN 
	BEGIN TRY
		IF @codCliente IS NULL OR @codCliente <= 0
		BEGIN
			PRINT 'El codCliente no es válido.'
			RETURN -1
		END

		SET @nombre = null
		SELECT @nombre = nombre_cliente
		  FROM CLIENTES
		 WHERE codCliente = @codCliente 

		IF @nombre IS NULL
		BEGIN
			PRINT 'No existe un cliente con ese codCliente.'
			RETURN -2
		END
	END TRY
    BEGIN CATCH
        PRINT CONCAT ('CODERROR: ', ERROR_NUMBER(),
 				', DESCRIPCION: ', ERROR_MESSAGE(),
 				', LINEA: ', ERROR_LINE())
    END CATCH
END


-------------------
GO

DECLARE @codCliente INT = 15
DECLARE @nombre VARCHAR(50)
DECLARE @result INT


EXEC @result = getNombreCliente @codCliente, @nombre OUTPUT
IF @result <> 0
BEGIN
	RETURN
END


-------------------------------------------------------------------------------------------
-- 2. Implementa un procedimiento llamado 'getPedidosPagosCliente' que devuelva el número de pedidos y de pagos a partir de un código de cliente.
--		Parámetros de entrada:  codCliente INT
--		Parámetros de salida:   numPedidos INT
--                              numPagos INT
--		Tabla:                  CLIENTES
--		
--		El procedimiento devolverá 0 si finaliza correctamente.
--		Debes utilizar TRY/CATCH, validación de parámetros y transacciones si fueran necesarias.
--	
--	  * Comprueba que el funcionamiento es correcto realizando una llamada desde un script y comprobando la finalización del mismo
--      Recuerda utilizar en el script:
--              EXEC @ret = getPedidosPagosCliente @codCliente, @numPedidos OUTPUT, @numPagos OUTPUT
--              IF @ret <> 0 ...
-------------------------------------------------------------------------------------------
GO

CREATE OR ALTER PROCEDURE getPedidosPagosCliente(@codCliente INT, @numPedidos INT OUTPUT, @numPagos INT OUTPUT)
AS
BEGIN
	BEGIN TRY
		IF @codCliente IS NULL OR @codCliente <= 0
		BEGIN
			PRINT 'El codCliente no es válido.'
			RETURN -1
		END

		SET @numPedidos = NULL 
		SET @numPagos = NULL

		SELECT @numPedidos = COUNT(codPedido)
		  FROM PEDIDOS
		 WHERE codCliente = @codCliente
		 GROUP BY codCliente

		SELECT @numPagos = COUNT(id_transaccion)
		  FROM PAGOS
		 WHERE codCliente = @codCliente
		 GROUP BY codCliente
	END TRY
    BEGIN CATCH
        PRINT CONCAT ('CODERROR: ', ERROR_NUMBER(),
 				', DESCRIPCION: ', ERROR_MESSAGE(),
 				', LINEA: ', ERROR_LINE())
    END CATCH
END


-------------------
GO

DECLARE @codCliente INT = 19
DECLARE @numPedidos INT, @numPagos INT
DECLARE @result INT


EXEC @result = getPedidosPagosCliente @codCliente, @numPedidos OUTPUT, @numPagos OUTPUT
IF @result <> 0
BEGIN
	PRINT 'El comando "getPedidosPagosCliente" dio error.'
	RETURN
END
PRINT CONCAT('El cliente ', @codCliente, ' tiene ', @numPedidos, ' pedidos y ', @numPagos, ' pagos.')


-------------------------------------------------------------------------------------------
-- 3. Implementa un procedimiento llamado 'crearCategoriaProducto' que inserte una nueva categoría de producto en la base de datos JARDINERIA.
--		Parámetros de entrada: codCategoria CHAR(2),
--							   nombre VARCHAR(50),
--                             descripcion_texto VARCHAR(MAX), 
--                             descripcion_html VARCHAR(MAX),
--                             imagen VARCHAR(256)

--		Parámetros de salida: <ninguno>
--		Tabla: CATEGORIA_PRODUCTOS
--		
--		# Se debe comprobar que todos los parámetros obligatorios están informados. Si falta alguno, devolver -1 y finalizar.
--		# Se debe comprobar que la categoría no exista previamente en la tabla. Si ya existe, imprimir mensaje indicándolo, devolver -1 y finalizar.
--		
--		El procedimiento devolverá 0 si finaliza correctamente.
--		Debes utilizar TRY/CATCH, validación de parámetros y transacciones si fueran necesarias.
--	
--	  * Comprueba que el funcionamiento es correcto realizando una llamada desde un script y comprobando la finalización del mismo
--      Recuerda utilizar en el script:
--              EXEC @ret = crearCategoriaProducto ...
--              IF @ret <> 0 ...
-------------------------------------------------------------------------------------------
GO

CREATE OR ALTER PROCEDURE crearCategoriaProducto(@codCategoria CHAR(2), @nombre VARCHAR(50), @descripcion_texto VARCHAR(100), @descripcion_html VARCHAR(100), @imagen VARCHAR(256))
AS
BEGIN
	BEGIN TRY
		IF @codCategoria IS NULL
		BEGIN
			PRINT 'El codCliente no es válido.'
			RETURN -1
		END


		--TODO: CHEQUEO POR SI NO ESTA
		INSERT INTO CATEGORIA_PRODUCTOS (codCategoria, nombre, descripcion_texto, descripcion_html, imagen)
			VALUES (@codCategoria, @nombre, @descripcion_texto, @descripcion_html, @imagen)



	END TRY
    BEGIN CATCH
        PRINT CONCAT ('CODERROR: ', ERROR_NUMBER(),
 				', DESCRIPCION: ', ERROR_MESSAGE(),
 				', LINEA: ', ERROR_LINE())
    END CATCH
END

----------------------
GO



-------------------------------------------------------------------------------------------
-- 4. Implementa un procedimiento llamado 'acuseRecepcionPedidosCliente' que actualice la fecha de entrega de los pedidos
--      a la fecha del momento actual y su estado a 'Entregado' para el codCliente pasado por parámetro y solo para los 
--      pedidos que estén en estado 'Pendiente' y no tengan fecha de entrega.

--		Parámetros de entrada: codCliente INT
--		Parámetros de salida:  numPedidosAct INT
--		Tabla: PEDIDOS

--	  * Comprueba que el funcionamiento es correcto realizando una llamada desde un script y comprobando la finalización del mismo
--
--      Ayuda: Recuerda utilizar:
--              EXEC @ret = acuseRecepcionPedidosCliente ...
--              IF @ret <> 0 ...
--
--	  * Ayuda para obtener el número de registros actualizados:
--		Se puede hacer una SELECT antes de ejecutar la sentencia de actualización o bien utilizar la variable @@ROWCOUNT
--
-------------------------------------------------------------------------------------------




-------------------------------------------------------------------------------------------
-- 5. Implementa un procedimiento llamado 'crearOficina' que inserte una nueva oficina en JARDINERIA.
--		Parámetros de entrada: codOficina CHAR(6)
--                             ciudad VARCHAR(40)
--                             pais VARCHAR(50)
--                             region VARCHAR(50) (no obligatorio)
--                             codigo_postal CHAR(5)
--                             telefono VARCHAR(15)
--                             linea_direccion1 VARCHAR(100)
--                             linea_direccion2 VARCHAR(100) (no obligatorio)

--		Parámetros de salida: <ninguno>
--		Tabla: OFICINAS
--		
--		# Se debe comprobar que todos los parámetros obligatorios están informados, sino devolver -1 y finalizar
--		# Se debe comprobar que el codOficina no exista previamente en la tabla, y si así fuera, 
--			imprimir un mensaje indicándolo y se devolverá -1
--		
--		El procedimiento devolverá 0 si finaliza correctamente.
--		Debes utilizar TRY/CATCH, validación de parámetros y transacciones si fueran necesarias.
--	
--	  * Comprueba que el funcionamiento es correcto realizando una llamada desde un script y comprobando la finalización del mismo
--
--      Ayuda: Recuerda utilizar:
--              EXEC @ret = crearOficina ...
--              IF @ret <> 0 ...
-------------------------------------------------------------------------------------------





-------------------------------------------------------------------------------------------
-- 6. Implementa un procedimiento llamado 'cambioJefes' que actualice el jefe/a de los empleados/as del
--      que tuvieran inicialmente (ant_codEmplJefe) al nuevo/a (des_codEmplJefe)
--    NOTA: Es un proceso que ocurre si alguien asciende de categoría.

--		Parámetros de entrada: ant_codEmplJefe INT
--                             des_codEmplJefe INT

--		Parámetros de salida: numEmpleados INT (número de empleados que han actualizado su jefe)
--		Tabla: EMPLEADOS

--	  * Comprueba que el funcionamiento es correcto realizando una llamada desde un script y comprobando la finalización del mismo
--
--      Ayuda: Recuerda utilizar:
--              EXEC @ret = cambioJefes ...
--              IF @ret <> 0 ...
-------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------
-- 7. Implementa una función llamada getCostePedidos que reciba como parámetro un codCliente y devuelva
--		el coste de todos los pedidos realizados por dicho cliente.
--	
--	Recuerda que debes incluir la SELECT y comprobar el funcionamiento
-------------------------------------------------------------------------------------------
SELECT idCliente, <llamada a tu funcion>
  FROM CLIENTES;


-------------------------------------------------------------------------------------------
-- 8. Implementa una función llamada numEmpleadosOfic que reciba como parámetro un codOficina y devuelva
--		el número de empleados que trabajan en ella
--	
--	Recuerda que debes incluir la SELECT y comprobar el funcionamiento
-------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------
-- 9. Implementa una función llamada clientePagos_SN que reciba como parámetro un codCliente y devuelva
--		'S' si ha realizado pagos y 'N' si no ha realizado ningún pago.
--	
--	Recuerda que debes incluir la SELECT y comprobar el funcionamiento
-------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------
-- 10. Implementa una función llamada pedidosPendientesAnyo que reciba como parámetros 'estado' y 'anyo'
--	    y devuelva una TABLA con los pedidos pendientes del año 2009 (estos datos deben ponerse directamente en la SELECT, NO son dinámicos)

--	Recuerda que debes incluir la SELECT y comprobar el funcionamiento
-------------------------------------------------------------------------------------------

