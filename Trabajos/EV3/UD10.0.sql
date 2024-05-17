USE TIENDA;
--EXERCISE 1
GO

DECLARE Cur_Producto CURSOR FOR
SELECT nombre
 FROM PRODUCTO;
DECLARE @nomfabricante AS VARCHAR(100);
OPEN Cur_Fabricante;
FETCH NEXT FROM Cur_Fabricante INTO @nomfabricante;
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @nomfabricante
    FETCH NEXT FROM Cur_Fabricante INTO @nomfabricante;
END
-- Cerramos y liberamos la memoria del cursor
CLOSE Cur_Fabricante;
DEALLOCATE Cur_Fabricante;

GO
--USE TIENDA;
--EXERCISE 2
GO

DECLARE Cur_Producto CURSOR FOR
SELECT nombre, precio
 FROM PRODUCTO
DECLARE @nomfabricante AS VARCHAR(100), @preciofabricante AS INT
OPEN Cur_Fabricante
FETCH NEXT FROM Cur_Fabricante INTO @nomfabricante, @preciofabricante
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT CONCAT('El producto ',@nomfabricante,' tiene un precio de ',@preciofabricante, ' €')
    FETCH NEXT FROM Cur_Fabricante INTO @nomfabricante, @preciofabricante
END
CLOSE Cur_Fabricante;
DEALLOCATE Cur_Fabricante;

GO
--USE TIENDA;
--EXERCISE 3
GO

DECLARE Cur_Fabricante CURSOR FOR
 SELECT codigo, nombre
   FROM FABRICANTE
DECLARE @codfabricante INT, @nomfabricante VARCHAR(100), @total DECIMAL(9,2)
DECLARE @codfabricante_fk INT, @precio DECIMAL(9, 2)
OPEN Cur_Fabricante
FETCH NEXT FROM Cur_Fabricante INTO @codfabricante, @nomfabricante
WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE Cur_Producto CURSOR FOR
     SELECT codigo_fabricante, precio
      FROM PRODUCTO 
    SET @total = 0
    OPEN Cur_Producto
    FETCH NEXT FROM Cur_Producto INTO @codfabricante_fk, @precio
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @codfabricante_fk = @codfabricante
        BEGIN
            SET @total += @precio
        END
            
        FETCH NEXT FROM Cur_Producto INTO @codfabricante_fk, @precio
    END
    PRINT CONCAT('El fabricante ',@nomfabricante,' tiene un total total de ',@total, ' € en productos.')
    FETCH NEXT FROM Cur_Fabricante INTO @codfabricante, @nomfabricante
    CLOSE Cur_Producto
    DEALLOCATE Cur_Producto
END
CLOSE Cur_Fabricante;
DEALLOCATE Cur_Fabricante

GO
--USE TIENDA
--EXERCISE 4
GO
DECLARE @nombre VARCHAR(50), @apellido1 VARCHAR(50), @apellido2 VARCHAR(50), @email VARCHAR(100),  @codEmpleado INT
DECLARE Cur_Empleado CURSOR FOR
SELECT nombre, apellido1, apellido2, email, codEmpleado
  FROM EMPLEADOS
OPEN Cur_GetDatosEmpleado 
FETCH NEXT FROM Cur_GetDatosEmpleado INTO @nombre, @apellido1, @apellido2, @email, @codEmpleado
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT CONCAT('Datos Empleado: ', CHAR(10), 'ID: ',@codEmpleado, CHAR(10),
                'nombre: ', @nombre, CHAR(10), 'apellido1: ', @apellido1, CHAR(10), 'apellido2: ', 
                @apellido2, CHAR(10), 'email: ', @email, CHAR(10))  
  FETCH NEXT FROM Cur_GetDatosEmpleado INTO @nombre, @apellido1, @apellido2, @email, @codEmpleado

END
-- Cerramos el cursor.
CLOSE Cur_GetDatosEmpleado
DEALLOCATE Cur_GetDatosEmpleado

GO
--USE TIENDA
--EXERCISE 5
GO
DECLARE @codPedido INT
DECLARE Cur_Pedido CURSOR FOR
SELECT codPedido FROM PEDIDOS
OPEN Cur_Pedido 

FETCH NEXT FROM Cur_Pedido INTO @codPedido
WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @total DECIMAL(14,2), @importe DECIMAL(13,2);
    SET @total = 0;
    DECLARE Cur_DetallePedidos CURSOR FOR
    SELECT cantidad * precio_unidad
      FROM DETALLE_PEDIDOS
     WHERE codPedido = @codPedido;

    OPEN Cur_DetallePedidos;
    FETCH NEXT FROM Cur_DetallePedidos INTO @importe
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @total = @total + @importe;
        FETCH NEXT FROM Cur_DetallePedidos INTO @importe;
    END
    CLOSE Cur_DetallePedidos
    DEALLOCATE Cur_DetallePedidos

    PRINT CONCAT('El pedido ', @codPedido , 'tiene un coste total de ', @total, ' €')
    FETCH NEXT FROM Cur_Pedido INTO @codPedido;
END

CLOSE Cur_Pedido
DEALLOCATE Cur_Pedido
 

