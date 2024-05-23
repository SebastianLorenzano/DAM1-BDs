USE SUPERTIENDA


-------------------------------------------------------------------------------------------
-- 2. Implementa un procedimiento que cree una nueva subcategoría de producto.
--		Parámetros de entrada: codCategoria, nombreSubCategoria
--		Parámetros de salida: codSubCategoria
--		Tabla: SUBCATEGORIAS

--		# Se debe comprobar que todos los parámetros obligatorios están informados, sino devolver -1 y finalizar
--		# Se debe comprobar que el idCategoria SI existe en la tabla (sino no podemos crear la subcategoria)
--			Si no existiera, imprimir un mensaje indicándolo, devolver -1 y finalizar
--		
--		El procedimiento devolverá 0 si finaliza correctamente.
--		Debes utilizar TRY/CATCH, validación de parámetros y transacciones si fueran necesarias.
--		
--	  *Comprueba que el funcionamiento es correcto realizando una desde un script y comprobando la finalización del mismo
-------------------------------------------------------------------------------------------
GO
CREATE OR ALTER PROCEDURE CrearSubCategoria(@codCategoria CHAR(2), @nombreSubCategoria VARCHAR(100), @codSubCategoria INT OUT)
AS
BEGIN
    IF @codCategoria IS NULL
    BEGIN
        PRINT 'El codCategoria es Null'
        RETURN -1
    END
    IF @codCategoria NOT IN (SELECT codCategoria FROM CATEGORIAS)
    BEGIN
        PRINT 'El codCategoria proporcionado no existe'
        RETURN -2
    END
    SET @codSubCategoria = NULL

    INSERT INTO SUBCATEGORIAS(codCategoria, nombre)
    VALUES (@codCategoria, @nombreSubCategoria)

    SET @codSubCategoria = SCOPE_IDENTITY()
END


GO
DECLARE @codCategoria CHAR(2) = 'AL', @nombreSubCategoria VARCHAR(100) = 'España', @codSubCategoria INT, @result INT
EXEC @result = CrearSubCategoria @codCategoria, @nombreSubCategoria, @codSubCategoria OUT
IF @result <> 0
BEGIN
    PRINT 'CrearSubCategoria no se ha podido ejecutar correctamente'
    RETURN
END


GO
-------------------------------------------------------------------------------------------
--8. Implementa una función llamada getNumPedidos que reciba como parámetro un idCliente y devuelva
--		el número de pedidos realizados por dicho cliente.
--	
--	Recuerda que debes incluir la SELECT y comprobar el funcionamiento
--
--  Ayuda: recuerda incluir el prefijo dbo. al llamar a la función
--   En las funciones nunca debes indicar un valor directamente (es decir, "hardcodeado")
-------------------------------------------------------------------------------------------
GO
--SELECT codCliente, <llamada a tu funcion>
--  FROM CLIENTES;

USE SUPERTIENDA

GO
CREATE OR ALTER FUNCTION getNumPedidos (@idCliente INT)
RETURNS INT
AS
BEGIN
    IF @idCliente IS NULL OR @idCliente <= 0
    BEGIN
        RETURN 0
    END
    RETURN  (SELECT COUNT(codPedido) 
                     FROM PEDIDOS
                    WHERE codCliente = @idCliente)
END


GO
SELECT TOP(10) codCliente, dbo.getNumPedidos(codCliente) NumPedidos
  FROM CLIENTES
GO
/* C) Crea un cursor que itere por la tabla EMPLEADOS, muestre su código, nombre y el 
	número de clientes que tienen a su cargo (con doble cursor o con SELECT).*/

USE JARDINERIA
GO


DECLARE @num INT = 0, @count INT
SELECT @count = COUNT(codEmpleado) FROM EMPLEADOS
DECLARE @codEmpleado INT, @nombreEmpleado VARCHAR(100), @numClientes INT
WHILE @num <= 20
BEGIN
    SELECT @codEmpleado = codEmpleado, @nombreEmpleado = nombre
      FROM EMPLEADOS
     ORDER BY codEmpleado
    OFFSET @num ROWS
     FETCH NEXT 1 ROWS ONLY 
     
     SELECT @numClientes = COUNT(codCliente) FROM CLIENTES WHERE codEmpl_ventas = @codEmpleado

    PRINT CONCAT('Empleado: ', @codEmpleado, CHAR(10), 'Nombre: ', @nombreEmpleado, CHAR(10), 'NumClientes: ', @numClientes)
    SET @num += 1
END



GO
/*   Crea un cursor que itere por la tabla PRODUCTOS e indique la siguiente información:
	El producto XXX con referencia YYY aparece ZZZ veces en la tabla DETALLE_PEDIDOS. */


-- DECLARACIÓN DEL CURSOR
DECLARE Cur_Productos CURSOR FOR
SELECT codProducto ,nombre, refInterna
  FROM PRODUCTOS

DECLARE @codProducto INT, @nombre VARCHAR(100), @refInterna VARCHAR(15), @numApariciones INT

OPEN Cur_Productos

FETCH NEXT FROM Cur_Productos INTO @codProducto, @nombre, @refInterna
WHILE (@@FETCH_STATUS = 0)
BEGIN
    SELECT @numApariciones = COUNT(codProducto) FROM DETALLE_PEDIDOS WHERE codProducto = @codProducto
    PRINT CONCAT('CodProducto: ', @codProducto, CHAR(10), 'Nombre: ', @nombre, CHAR(10), 'RefInterna: ', @refInterna, CHAR(10), 'NumApariciones: ', @numApariciones, CHAR(10))
    FETCH NEXT FROM Cur_Productos INTO @codProducto, @nombre, @refInterna
END 

CLOSE Cur_Productos

DEALLOCATE Cur_Productos
