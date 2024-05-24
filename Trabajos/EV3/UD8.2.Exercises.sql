-- Hola carlos, no llegue a completar todos pero hice algunos de los avanzados para preparar el examen :D

USE SUPERTIENDA
GO
				---------------------------
				--   UD8  -  PROC & FUNC -- 
				---------------------------
-------------------------------------------------------------------------------------------
-- NOTA: Recuerda cuidar la limpieza del código (tabulaciones, nombres de tablas en mayúscula,
--		nombres de variables en minúscula, poner comentarios sin excederse, código organizado y fácil de seguir, etc.)
--
--	Si alguna tabla fuera IDENTITY y haces una inserción, puedes obtener el id llamando a la función SCOPE_IDENTITY()
--
-------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------
-- 1. Implementa un procedimiento llamado 'crearCategoria' que inserte una nueva categoría de productos.
--		Parámetros de entrada: codCategory, nameCategory

--		Parámetros de salida: <ninguno>
--		Tabla: CATEGORIAS
--		
--		# Se debe comprobar que todos los parámetros obligatorios están informados, sino devolver -1 y finalizar
--		# Se debe comprobar que el codCategory no exista en la tabla, y si así fuera, 
--			imprimir un mensaje indicándolo, devolver -1 y finalizar
--		
--		El procedimiento devolverá 0 si finaliza correctamente.
--		Debes utilizar TRY/CATCH, validación de parámetros y transacciones si fueran necesarias.
--	
--	  * Comprueba que el funcionamiento es correcto realizando una desde un script y comprobando la finalización del mismo
-------------------------------------------------------------------------------------------
GO

CREATE OR ALTER PROCEDURE CreateCategory(@codCategory CHAR(2), @name
 VARCHAR(100))
AS
BEGIN
	BEGIN TRY
		IF @codCategory IS NULL
		BEGIN
			RETURN -1
		END
    		IF @name
         IS NULL
		BEGIN
			RETURN -2
		END

		IF EXISTS (SELECT @codCategory FROM CATEGORIAS WHERE codCategoria = @codCategory)
		BEGIN
			RETURN -3
		END

		INSERT INTO CATEGORIAS (codCategoria, nombre)
			VALUES (@codCategory, @name
      )
	END TRY
    BEGIN CATCH
        PRINT CONCAT ('CODERROR: ', ERROR_NUMBER(),
 				', DESCRIPCION: ', ERROR_MESSAGE(),
 				', LINEA: ', ERROR_LINE())
    END CATCH
END

----------------------
GO
DECLARE @codCategory CHAR(2) = 'PP'
DECLARE @name VARCHAR(100) = 'Categoría de prueba PP'
DECLARE @result INT

EXEC @result = CreateCategory @codCategory, @name
IF @result <> 0
BEGIN
	PRINT 'The procedure named "CreateCategory" failed.'
  PRINT @result
	RETURN
END
-------------------------------------------------------------------------------------------
-- 2. Implementa un procedimiento que cree una nueva subcategoría de producto.
--		Parámetros de entrada: codCategory, nombreSubCategoria
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

---------------------------

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


-------------------------------------------------------------------------------------------
-- 4. Implementa un procedimiento que cree una nueva valoración de un cliente a un producto
--		Parámetros de entrada: codCliente, codProducto, estrellas, fechaValoracion y comentario
--		Parámetros de salida: <ninguno>
--		Tabla: VALORACIONES_PRODUCTOS
--		
--		El procedimiento devolverá 0 si finaliza correctamente.
--		Debes utilizar TRY/CATCH, validación de parámetros, transacciones si fueran necesarias, etc.
--	
--	 
--	  * Comprueba que el funcionamiento es correcto realizando una desde un script y comprobando la finalización del mismo
-------------------------------------------------------------------------------------------
GO
USE SUPERTIENDA
GO
CREATE OR ALTER PROCEDURE CrearValoracionProducto(@codCliente INT, @codProducto INT, 
												  @estrellas TINYINT, @fechaValoracion DATE, @comentario VARCHAR(250))
AS
BEGIN
	IF @codCliente IS NULL OR NOT EXISTS (SELECT 1 FROM CLIENTES WHERE codCliente = @codCliente)
	BEGIN
		PRINT 'El codCliente es invalido.'
		RETURN -1
	END
	IF @codProducto IS NULL OR NOT EXISTS (SELECT 1 FROM PRODUCTOS WHERE codProducto = @codProducto)
	BEGIN
		PRINT 'El codProducto es invalido.'
		RETURN -2
	END

	INSERT INTO VALORACIONES_PRODUCTOS (codCliente, codProducto, estrellas, fechaValoracion, comentario)
	VALUES (@codCliente, @codProducto, @estrellas, @fechaValoracion, @comentario)
END


GO

-------------------------------------------------------------------------------------------
-- 5. Implementa un procedimiento que cree un nuevo pedido
--		Parámetros de entrada: codCliente, codVendedor, codTransportista, costeEnvio, recogidaTiendaSN
--		Parámetros de salida: codPedido
--		Tabla: PEDIDOS
--		
--		# Se debe comprobar que los parámetros codCliente e codVendedor están informados, sino devolver -1 y finalizar
--		# El resto de campos de la tabla que no se pasan como parámetro de entrada se informarán a cero en la sentencia INSERT
--		# NO hace falta comprobar que el codCliente y el codVendedor existan. Si no existieran, fallará la sentencia INSERT
--		
--		El procedimiento devolverá 0 si finaliza correctamente.
--		Debes utilizar TRY/CATCH, validación de parámetros y transacciones si fueran necesarias.
--		
--	  * Comprueba que el funcionamiento es correcto realizando una desde un script y comprobando la finalización del mismo
-------------------------------------------------------------------------------------------




-------------------------------------------------------------------------------------------
-- 6. Implementa un procedimiento crearLineaPedido que cree una nueva línea de pedido
--		Parámetros de entrada: codPedido, codProducto y unidades
--		Parámetros de salida: <ninguno>
--		Tabla: LINEAS_PEDIDOS
--		
--		# El precio del producto (campo 'precioCompra') debes obtenerlo previamente de la tabla PRODUCTOS
--		# El campo totalLinea es un campo derivado (se actualiza automáticamente), por lo que NO hay que indicarlo en la INSERT.
--		# Se debe comprobar que los parámetros codPedido, codProducto y unidades están informados, sino devolver -1 y finalizar
--		# NO hace falta comprobar que el codPedido y el codProducto existan. Si no existieran, fallará la sentencia INSERT
--		
--		El procedimiento devolverá 0 si finaliza correctamente.
--		Debes utilizar TRY/CATCH, validación de parámetros y transacciones si fueran necesarias.
--		
--	  * Comprueba que el funcionamiento es correcto realizando una desde un script y comprobando la finalización del mismo
-------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------
-- 7. Implementa un script que utilice los procedimientos crearPedido y crearLineaPedido y 
--		que cree un nuevo pedido y que el pedido tenga dentro 2 productos cualesquiera.
--	
--	Recuerda la utilización de TRY/CATCH y transacciones.
--		Ejemplo. Si se llega a crear el pedido y falla la creación de una de las líneas,
--			deberá retroceder los cambios al estado inicial (ROLLBACK)
--
--  Ayuda 1: Considera quitar las transacciones de dentro de los procedimientos.
--  Ayuda 2: Utiliza una transacción que se inicie en el script de llamada
--     y que el COMMIT se haga al final
-------------------------------------------------------------------------------------------




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

-------------------------------------------------------------------------------------------
-- 9. Implementa una función llamada getCostePedidos que reciba como parámetro un idCliente y devuelva
--		el coste de todos los pedidos realizados por dicho cliente.
--	
--	Recuerda que debes incluir la SELECT y comprobar el funcionamiento
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
-- 10. Implementa una función llamada ventasTotalesVendedor que reciba como parámetro un idVendedor y devuelva
--		el importe vendido por dicho vendedor.
--	
--	Recuerda que debes incluir la SELECT y comprobar el funcionamiento
-------------------------------------------------------------------------------------------
SELECT codVendedor, <llamada a tu funcion>
  FROM VENDEDORES;




-------------------------------------------------------------------------------------------
-- 11. Ampliación Describe el funcionamiento e implementa un procedimiento que incluya 
--	TRY/CATCH y transacciones utilizando la BD TIENDA_DB.
-------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------
-- 12. Ampliación Describe el funcionamiento e implementa una función que utilice
--	alguna de las tablas de la BD TIENDA_DB.
-------------------------------------------------------------------------------------------

