USE JARDINERIA

DECLARE @varPrecio DECIMAL(9, 2)
SET @varPrecio = 75
SELECT * FROM PRODUCTOS WHERE precio_venta > @varPrecio

EXEC sp_tables
EXEC sp_columns PRODUCTOS




DECLARE @Pepe DECIMAL(9,2) = 0, @Pablo DECIMAL(9,2) = 5

DECLARE @codCategoria CHAR(2) = 'FR'
DECLARE @precioMin DECIMAL(9,2)
DECLARE @precioMax DECIMAL(9,2)

 SELECT @precioMin = MIN(precio_venta),
        @precioMax = MAX(precio_venta)
   FROM PRODUCTOS
  WHERE codCategoria = @codCategoria
  PRINT CONCAT('El precio mínimo es: ',@precioMin, CHAR(10),
                ' y el precio máximo es: ', @precioMax)

  SELECT MIN(precio_venta)
  FROM PRODUCTOS
 WHERE codCategoria = @codCategoria
