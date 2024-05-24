USE JARDINERIA
/*

1.- Cursor management (2 points)

Create a script that iterates through each of the records in the OFICINAS table

For each office, a line with the following information must be displayed:

"The office XXX, located in YYY, has a total of ZZZ employees"

Being:
      XXX: The office’s code
      YYY: The city of the office
      ZZZ: the number of employees working on it.

*/
GO
DECLARE @codOficina CHAR(6), @ciudad VARCHAR(40), @numEmpleados INT
DECLARE @num INT = 0, @count INT
SELECT @count = COUNT(codOficina) FROM OFICINAS

WHILE @num <= @count
BEGIN
    SELECT @codOficina = codOficina,
           @ciudad = ciudad
      FROM OFICINAS
     ORDER BY codOficina
    OFFSET @num ROW
     FETCH NEXT 1 ROWS ONLY

    SELECT @numEmpleados = COUNT(codEmpleado)
     FROM EMPLEADOS
    WHERE codOficina = @codOficina

    PRINT CONCAT('La oficina ', @codOficina, ', ubicada en la ciudad ', @ciudad, ', tiene un total de ', @numEmpleados, ' empleados.')
        SET @num += 1
END


GO


/*
2.- Function implementation and call (3 points)

Create a function called countProductsCategory that receives as parameters a codCategoria, 
a minPrice and a maxPrice; and returns the number of products included in it whose price is between minPrice and maxPrice.

Create a function called getOrderTotalCost that receives as a parameter codPedido and returns the total cost of that order 
(it is NOT allowed the use of fields such as totalLinea, you should calculate it inside the function).

Implement as well, two SELECTs in which you test that the functions countProductsCategory and getOrderTotalCost work as expected.

*/
GO

CREATE OR ALTER FUNCTION countProductsCategory(@codCategoria CHAR(2), @minPrice DECIMAL(9,2), @maxPrice DECIMAL(9,2))
RETURNS INT
AS
BEGIN
     RETURN (SELECT COUNT(codProducto)
      FROM PRODUCTOS
     WHERE codCategoria = @codCategoria
       AND precio_venta >= @minPrice
       AND precio_venta <= @maxPrice)
END

GO

CREATE OR ALTER FUNCTION getOrderTotalCost(@codPedido INT)
RETURNS DECIMAL(9,2)
AS
BEGIN
    RETURN (SELECT SUM(precio_unidad)
              FROM DETALLE_PEDIDOS
             WHERE codPedido = @codPedido)
END

GO

DECLARE @minPrice DECIMAL(9,2) = 20, @maxPrice DECIMAL(9,2) = 100, @codPedido INT

SELECT codCategoria, dbo.countProductsCategory(codCategoria, @minPrice, @maxPrice)
  FROM CATEGORIA_PRODUCTOS

  SELECT codPedido, dbo.getOrderTotalCost(codPedido)
    FROM PEDIDOS


GO
/*
3.- Procedure implementation and call (4 points)

Create a procedure named realizarPago that receives as input parameters: “codCliente”, “codFormaPago”, “importe_pago” y “codPedido”. The procedure should: 

1º Check that the input parameters are correct

2º Insert a new row into the table PAGOS. The fields that the table has are:
-	codCliente, codFormaPago, importe_pago, codPedido: input paramters
-	fechaHora_pago: system date
-	id_transaccion: we should calculate it inside the procedure. Notice that they all follow the same structure: "ak-std-NNNNNN", with N being a 6-digit number filled with zeros on the left. 
For example, if the last number is "ak-std-000026" the procedure should get the "ak-std-000027", and so on.

3º Update the field codEstado in the table PEDIDOS related to the codPedido to ‘F’ (finalizado) and concatenate at the end of the field “observaciones” the string “Pago realizado.” 
(respecting what was previously there).

If all the actions of the procedure are carried out without problems, a message will be printed within the procedure indicating that the payment has been made successfully.


IMPORTANT: Consider using EVERYTHING we've seen in class.
*/

GO

CREATE OR ALTER PROCEDURE realizarPago(@codCliente INT, @codFormaPago CHAR(1), @importe_pago DECIMAL(9,2), @codPedido INT)
AS
BEGIN
    IF @codCliente IS NULL OR NOT EXISTS(SELECT 1 FROM CLIENTES WHERE codCliente = @codCliente)
    BEGIN
        PRINT 'El codCliente es invalido.'
        RETURN -1
    END

    IF @codFormaPago IS NULL OR NOT EXISTS(SELECT 1 FROM FORMA_PAGO WHERE codFormaPago = @codFormaPago)
    BEGIN
        PRINT 'El codFormaPago es invalido.'
        RETURN -2
    END

    IF @importe_pago IS NULL OR @importe_pago <= 0
    BEGIN
        PRINT 'El importe_pago es invalido.'
        RETURN -3
    END


        DECLARE @idTransaccion CHAR(15), @num INT                          -- La hago comprimida pq es un examen y tengo tiempo pero es medio inentendible así
        SELECT @num = MAX(RIGHT(id_transaccion, 8)) + 1 FROM PAGOS

        SELECT @idTransaccion = CONCAT(LEFT(id_transaccion, 7),   
                                REPLICATE('0', 8 - LEN(@num)),        
                                (@num))                  
          FROM PAGOS 
          PRINT @idTransaccion

    BEGIN TRY  
        BEGIN TRAN
        
            INSERT INTO PAGOS(codCliente, id_transaccion, fechaHora_pago, importe_pago, codFormaPago, codPedido)
            VALUES (@codCliente, @idTransaccion, GETDATE(), @importe_pago, @codFormaPago, @codPedido)

            UPDATE PEDIDOS
            SET codEstado = 'F', 
                comentarios = CONCAT(comentarios, ' Pago Realizado.')
            WHERE codPedido = @codPedido
        COMMIT
    END TRY

    BEGIN CATCH
        PRINT CONCAT ('Error: ', ERROR_NUMBER(), CHAR(10), 
                      'Linea: ', ERROR_MESSAGE(), CHAR(10), 
                      'Mensaje: ', ERROR_LINE())

        ROLLBACK
    END CATCH
END


GO

DECLARE @result INT
EXEC @result = realizarPago 15, 'B', 5762, 12
IF @result <> 0
BEGIN
    PRINT 'El procedimiento realizarPago no se ha completado correctamente.'
    RETURN
END



        DECLARE @idTransaccion CHAR(15), @num INT, @numVarchar VARCHAR                            -- La hago comprimida pq es un examen y tengo tiempo pero es medio inentendible así
        SET @numVarchar = @num

        SELECT @idTransaccion = CONCAT(LEFT(MAX(id_transaccion), 7),   
                                'Pepe1',        
                                'Pepe')                  
          FROM PAGOS 
        PRINT @idTransaccion

GO

CREATE TABLE HIST_CAT_PRODUCTOS(
    codCategoria            CHAR(2),
    nombre                  VARCHAR(50),
    descripcion_texto       VARCHAR(100),
    descripcion_html        VARCHAR(100),
    imagen                  VARCHAR(255),
    fechaOperacion          DATE


    CONSTRAINT PK_HIST_CAT_PRODUCTOS PRIMARY KEY (codCategoria)

)


GO

CREATE OR ALTER TRIGGER TR_CATEGORIA_PRODUCTOS ON CATEGORIA_PRODUCTOS
AFTER UPDATE, DELETE
AS
BEGIN
    SET XACT_ABORT ON
    DECLARE @codCategoria CHAR(2), @nombre VARCHAR(50), @descripcion_texto VARCHAR(100), @descripcion_html VARCHAR(100), @imagen VARCHAR(255)

    SELECT @codCategoria = codCategoria, 
           @nombre = nombre, 
           @descripcion_texto = descripcion_texto,
           @descripcion_html = descripcion_html,
           @imagen = imagen
      FROM deleted

    INSERT INTO HIST_CAT_PRODUCTOS (codCategoria, nombre, descripcion_texto, descripcion_html, imagen, fechaOperacion)
    VALUES (@codCategoria, @nombre, @descripcion_texto, @descripcion_html, @imagen, GETDATE())
END



UPDATE CATEGORIA_PRODUCTOS
SET nombre = 'Pepe'
WHERE codCategoria = 'AA'
SELECT * FROM CATEGORIA_PRODUCTOS WHERE codCategoria = 'AA'







SELECT MAX(id_transaccion) FROM PAGOS
