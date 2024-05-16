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
    PRINT CONCAT('El fabricante ',@nomfabricante,' tiene un total acumulado de ',@total, ' € en productos.')
    FETCH NEXT FROM Cur_Fabricante INTO @codfabricante, @nomfabricante
    CLOSE Cur_Producto
    DEALLOCATE Cur_Producto
END
CLOSE Cur_Fabricante;
DEALLOCATE Cur_Fabricante

GO
--USE TIENDA;
--EXERCISE 4
GO

 

