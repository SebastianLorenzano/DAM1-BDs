
		--------------------------------------------------
		-- Exercise 5.2. Write the following queries
		--					using the database TIENDA
		--------------------------------------------------

				--------------------------
				--		QUERIES		    --
				--------------------------

-- 1. List the name of all the products in the product table.
SELECT nombre 
  FROM PRODUCTO

-- 2. List the names and prices of all products in the product table.
SELECT nombre, precio
  FROM PRODUCTO
-- 3. List all columns in the product table.
SELECT *
  FROM PRODUCTO

-- 4. List the names and prices of all products in the product table, making the names capitalized.
SELECT UPPER(nombre), precio 
  FROM PRODUCTO

-- 5. List the names and prices of all products in the product table, converting the names to lowercase.
SELECT LOWER(nombre), precio
  FROM PRODUCTO

-- 6. List the name of all manufacturers in one column, and in another column capitalize the first two characters of the manufacturer's name.
SELECT nombre, UPPER(LEFT(nombre, 2))
  FROM FABRICANTE

-- 7. List the names and prices of all products in the product table, rounding the value of the price to the first decimal place.
SELECT nombre, ROUND(precio, 0)
  FROM PRODUCTO

-- 8. List the names and prices of all products in the product table, 
--    truncating the value of the price to display it without any decimal places.
SELECT nombre, FLOOR(ROUND(precio, 1))
  FROM PRODUCTO

-- 9. List the names of manufacturers sorted in ascending order.
SELECT nombre
  FROM FABRICANTE 
 ORDER BY nombre ASC

-- 10. List the names of manufacturers sorted downwards.
SELECT nombre
  FROM FABRICANTE 
 ORDER BY nombre DESC

-- 11. List the names of the products sorted first by the name 
--     ascending and second by the price descending.
SELECT nombre, precio
  FROM PRODUCTO
 ORDER BY nombre ASC, precio DESC

-- 12. Return a list with the first 5 rows of the manufacturer table.
SELECT *
  FROM FABRICANTE
 WHERE codigo >= 5

-- 13. List the name of all manufacturer products whose manufacturer code 
--      is equal to 2.
SELECT nombre
  FROM FABRICANTE
 WHERE codigo = 2

-- 14. List the name of the products that have a price less than or 
--      equal to � 120.
SELECT nombre
  FROM PRODUCTO
 WHERE precio <= 120

-- 15. List the name of the products that have a price greater than
--       or equal to � 400.
SELECT nombre
  FROM PRODUCTO
 WHERE precio >= 400

-- 16. List the name of the products that do not have a price greater 
--      than or equal to � 400.
SELECT nombre
  FROM PRODUCTO
 WHERE precio >= 400

-- 17. List all products that have a price between 80� and 300�. 
--      Without using the BETWEEN operator.
SELECT *
  FROM PRODUCTO
 WHERE precio BETWEEN 80 AND 300


-- 18. List all products that have a price between 60� and 200�. 
--      Using the BETWEEN operator.
SELECT 

-- 19. List all products where the manufacturer code is 1, 3, or 5. Without using the IN operator.


-- 20. List all products where the manufacturer code is 1, 3, or 5. Using the IN operator.


-- 21. List the name and price of the products in cents (The value of the price will have to be multiplied by 100). Create an alias for the column that contains the price that is called cents.


-- 22. List the names of manufacturers whose name begins with the letter S.


-- 23. List the names of manufacturers whose name ends with the vowel e.


-- 24. List the names of manufacturers whose name contains the character w.


-- 25. List the names of manufacturers whose name is 4 characters.


-- 26. Return a list with the name of all products that contain the �Port�til� string in the name.


-- 27. Return a list with the name of all products that contain the �Monitor� string in the name and are priced less than 215�.


-- 28. List the name and price of all products that have a price greater than or equal to � 180. Sort the result first by price (in descending order) and second by name (in ascending order).