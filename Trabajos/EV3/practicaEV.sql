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

GO
/*
3.- Nested cursors in DB TIENDA
In this script you must use a cursor that runs through the FABRICANTE table and within this
cursor another that runs through the PRODUCT table. The objective is that within this second
cursor the price of the products of each manufacturer is accumulated and that something
similar to the following is shown:
Example of output.
“Fabricante: nombreFabricante tiene un total de acumulado € en productos.” (siendo las
palabras resaltadas en rojo variables)
*/

USE TIENDA
GO
DECLARE @count INT, @num INT = 0, @total DECIMAL(13,2), @codigoFab INT
SELECT @count = COUNT(codigo) FROM FABRICANTE

SELECT @count = COUNT(codigo) FROM FABRICANTE
WHILE @num <= @count
BEGIN
    SELECT  @codigoFab = codigo
      FROM FABRICANTE
     ORDER BY codigo
    OFFSET @num ROWS
     FETCH NEXT 1 ROWS ONLY
     SET @total = 0
     SELECT @total += precio 
       FROM PRODUCTO 
      WHERE codigo_fabricante = @codigoFab 

    PRINT CONCAT('Fabricante: ', @codigoFab, CHAR(10), 'Total: ', @total, CHAR(10))
    SET @num += 1 
END

SELECT * FROM FABRICANTE

GO
/*
D) Crea un trigger que se active cuando se inserte un nuevo cliente y que en caso 
	de no tener un limite_credito > 10000 se impida su inserción.

   Crea un trigger que haga una copia de seguridad de la tabla FORMA_PAGO en la tabla
	HIST_FORMA_PAGO cuando se actualice o borre algún registro de esta tabla.
	La tabla HIST_FORMA_PAGO tendrá además la fecha de operación que corresponderá
	con la fecha en la que se ejecute el trigger. */
USE JARDINERIA
GO

CREATE OR ALTER TRIGGER TX_CLIENTES_INSERT ON CLIENTES
INSTEAD OF INSERT
AS
BEGIN
    SET XACT_ABORT ON
    DECLARE @limite DECIMAL(9,2), @limite_credito DECIMAL(9,2) = 10000
    SELECT @limite = limite_credito FROM inserted
    INSERT INTO CLIENTES
    SELECT * 
      FROM inserted
     WHERE limite_credito > @limite_credito
    

END

GO

DECLARE @nuevoCliente INT;
SET @nuevoCliente = ISNULL((SELECT MAX(codCliente)
                              FROM CLIENTES), 0) + 1

INSERT INTO CLIENTES
VALUES (@nuevoCliente, 'Santi', 'Pls', 'Copion', '696969696', null, 'Argentina', null, 'Alicante', null, null, null, 15000),
       (@nuevoCliente + 1, 'Pedro', 'Gómez', 'López', '666666666', null, 'España', null, 'Madrid', null, null, null, 8000),
       (@nuevoCliente + 2, 'María', 'Fernández', 'García', '555555555', null, 'España', null, 'Barcelona', null, null, null, 12000),
       (@nuevoCliente + 3, 'Laura', 'Martínez', 'Rodríguez', '777777777', null, 'España', null, 'Valencia', null, null, null, 9500);

GO

-- 9. Implementa una función llamada getCostePedidos que reciba como parámetro un idCliente y devuelva
--        el coste de todos los pedidos realizados por dicho cliente.
--
--    Recuerda que debes incluir la SELECT y comprobar el funcionamiento
-------------------------------------------------------------------------------------------
GO
USE SUPERTIENDA
GO

CREATE OR ALTER FUNCTION getCostePedidos(@idCliente INT)
RETURNS DECIMAL(13,2)
AS
BEGIN
    RETURN (SELECT ISNULL(SUM(l.totalLinea), 0)
              FROM PEDIDOS p, LINEAS_PEDIDOS l
             WHERE p.codPedido = l.codPedido
              AND p.codCliente = @idCliente)
END

GO

SELECT codCliente, dbo.getCostePedidos(codCliente) FROM CLIENTES
GO

-------------------------------------------------------------------------------------------
-- 3. Implementa un procedimiento que cree un nuevo producto en la base de datos.
--		Parámetros de entrada: nombre, precioUnitario, IVA e codSubCategoria
--		Parámetros de salida: codProducto creado
--		Tabla: PRODUCTOS
--		
--		# Se debe comprobar que todos los parámetros *obligatorios* están informados, sino devolver -1 y finalizar
--		
--		El procedimiento devolverá 0 si finaliza correctamente.
--		Debes utilizar TRY/CATCH, validación de parámetros y transacciones si fueran necesarias.
--		
--	  * Comprueba que el funcionamiento es correcto realizando una desde un script y comprobando la finalización del mismo
-------------------------------------------------------------------------------------------
GO
USE SUPERTIENDA
GO

CREATE OR ALTER PROCEDURE CrearProducto(@nombre VARCHAR(100), @precioUnitario DECIMAL(9,2), @iva TINYINT, @codSubCategoria INT, @codProducto INT OUT)
AS
BEGIN
    IF @nombre IS NULL      -- No uso transaccion ya que no lo necesita, al ser un solo insert no hay posibilidades de que falle. 
    BEGIN
        PRINT 'El nombre es invalido.'
        RETURN -1
    END
    IF @precioUnitario IS NULL
    BEGIN
        PRINT 'El precio unitario es invalido.'
        RETURN -2
    END
    IF NOT EXISTS (SELECT 1 FROM TIPOS_IVA i WHERE i.IVA = @iva)
    BEGIN
        PRINT 'El IVA es invalido.'
        RETURN -3
    END
    IF @codSubCategoria IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM SUBCATEGORIAS s WHERE s.codSubcategoria = @codSubCategoria)
        BEGIN
            PRINT 'El CodSubcategoria es invalido.'
        END
    END
        INSERT INTO PRODUCTOS (nombre, precioUnitario, IVA, codSubcategoria)
        VALUES (@nombre, @precioUnitario, @iva, @codSubCategoria)
        SET @codProducto = SCOPE_IDENTITY()
END


GO

DECLARE @nuevoCodProducto INT, @result INT

-- Caso de error: nombre nulo
EXEC @result = CrearProducto @nombre = NULL, @precioUnitario = 100.00, @iva = 21, @codSubCategoria = 1, @codProducto = @nuevoCodProducto OUTPUT;
IF @result <> 0
BEGIN
    PRINT 'CrearProducto no se pudo realizar.'
    RETURN
END



-- Caso de error: precioUnitario nulo
EXEC CrearProducto @nombre = 'Camiseta', @precioUnitario = NULL, @iva = 21, @codSubCategoria = 2, @codProducto = @nuevoCodProducto OUTPUT;

-- Caso de error: iva nulo
EXEC CrearProducto @nombre = 'Leche', @precioUnitario = 1.50, @iva = 21, @codSubCategoria = 3, @codProducto = @nuevoCodProducto OUTPUT;


-- Caso de error: codSubCategoria inválido
EXEC CrearProducto @nombre = 'Ordenador', @precioUnitario = 1200.00, @iva = 21, @codSubCategoria = 99, @codProducto = @nuevoCodProducto OUTPUT;
GO

GO
USE JARDINERIA
GO

CREATE OR ALTER PROCEDURE CrearCliente(@nombre_cliente VARCHAR(50), @nombre_contacto VARCHAR(50), @apellido_contacto VARCHAR(50), @telefono VARCHAR(15), @email VARCHAR(100), )




