USE TIENDA
        --------------------------------------------------
		-- Exercise 5.3. Write the following queries
		--					using the database TIENDA
		--------------------------------------------------

				--------------------------
				--		QUERIES		    --
				--------------------------

SELECT * 
  FROM PRODUCTO
-- 1. Calculate the total number of products in the products table.

SELECT Count(codigo)
  FROM PRODUCTO

-- 2. Calculate the number of distinct manufacturer code values ​​that appear in the products table.

SELECT COUNT(DISTINCT(codigo_fabricante))
  FROM PRODUCTO

-- 3. Calculate the average price of all products.

SELECT AVG(precio)
  FROM PRODUCTO

-- 4. Calculate the cheapest price of all products.

SELECT MIN(precio)
  FROM PRODUCTO

-- 5. Calculate the most expensive price of all products.

SELECT MAX(precio)
  FROM PRODUCTO

-- 6. Calculate the sum of the prices of all the products.

SELECT SUM(precio)
  FROM PRODUCTO

-- 7. Calculate the cheapest price of all the products of the manufacturer Asus.

SELECT SUM(precio)
  FROM PRODUCTO
 WHERE codigo_fabricante = (    
                                SELECT codigo
                                  FROM FABRICANTE 
                                 WHERE nombre = 'Asus'
                            )

-- 8. Calculate the sum of all the products of the manufacturer Asus.

SELECT COUNT(codigo)
  FROM PRODUCTO
 WHERE codigo_fabricante =  (
                                SELECT codigo
                                FROM FABRICANTE
                                WHERE nombre = 'Asus'
                            )



-- 9. Get the maximum price, minimum price, average price, and the total number of products that Crucial manufacturer has.

SELECT MAX(precio), MIN(precio), AVG(precio), COUNT(codigo)
  FROM PRODUCTO
 WHERE codigo_fabricante = (
                                SELECT codigo
                                FROM FABRICANTE
                                WHERE nombre = 'Crucial'
                            )

-- 10. Calculate the number of products that have a price greater than or equal to 180 €.

SELECT COUNT(codigo)
  FROM PRODUCTO
 WHERE precio >= 180

-- 11. Calculate the number of products that each manufacturer has with a price greater than or equal to 180 €.

SELECT COUNT(codigo)
  FROM PRODUCTO
 WHERE precio >= 180
 GROUP BY (codigo_fabricante) 

-- 12. List the average price of each manufacturer's products.

SELECT AVG(precio)
  FROM PRODUCTO
 GROUP BY (codigo_fabricante)

-- 13. List the code of the manufacturers whose products have an average price greater than or equal to 150 €.


-- 14. Return a list with the codes of the manufacturers that have 2 or more products.


-- 15. Return a list with the manufacturers' codes and the number of products that each one has with a price greater than or equal to 220 €.
-- It is not necessary to display the name of the manufacturers that do not have products that meet the condition.
-- Example of the expected result.
	/*	codFabricante | NumProductos
		1				1
		2				2
		6				1			*/


-- 16. Return a list with the codes of the manufacturers where the sum of the price of all their products is greater than 1000 €.
