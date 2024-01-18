		--------------------------------------------------
		-- Exercise 5.4. Write the following queries
		--					using the database JARDINERIA
		--------------------------------------------------

				--------------------------
				--		QUERIES		    --
				--------------------------

---------------------------------------
-- A) Queries using a single table (17) --
---------------------------------------
USE JARDINERIA
SELECT * FROM EMPLEADOS
SELECT * FROM CLIENTES
SELECT * FROM PEDIDOS
SELECT * FROM PAGOS
SELECT * FROM FORMA_PAGO
SELECT * FROM PRODUCTOS 
SELECT * FROM CATEGORIA_PRODUCTOS
SELECT * FROM DETALLE_PEDIDOS

-- 1. Return a list with the office code and the city where there are offices.
SELECT codOficina, ciudad
  FROM OFICINAS

-- 2. Return a list with the city and the telephone number of the offices in Spain.
SELECT ciudad, telefono
  FROM OFICINAS

-- 3. Return a list with the first name, last name, and email of employees whose boss has a boss code equal to 7.
SELECT nombre, apellido1, apellido2, email
  FROM EMPLEADOS
 WHERE codEmplJefe = 7

-- 4. Return the name of the position, name, surname and email of the head of the company (jefe). Tip: You will recognise the boss because it does not have a boss.
SELECT nombre, apellido1, email 
  FROM EMPLEADOS
 WHERE codEmplJefe is NULL

-- 5. Return a list with the name, surname and post of those employees who are not sales representatives (remember that the != operator is not SQL standard and should not be used).
SELECT nombre, apellido1, puesto_cargo
  FROM EMPLEADOS
 WHERE puesto_cargo <> 'Representante Ventas'

-- 6. Return a list with the name of every Spanish clients.
SELECT nombre_cliente
  FROM CLIENTES
 WHERE pais = 'Spain'

-- 7. Return a list with the different states through which an order can pass (without repeating them).
SELECT DISTINCT(codEstado)
  FROM PEDIDOS

-- 8. Return a list with the customer code of those customers who made a payment in 2023. Please note that you will need to remove repeat customer codes.
SELECT DISTINCT(codCliente)
  FROM PAGOS
 WHERE YEAR(fechaHora_pago) = '2023'

-- 9. Return a listing with the order code, customer code, expected date and delivery date of orders that have not been delivered on time.
SELECT codPedido, codCliente, fecha_esperada, fecha_entrega
  FROM PEDIDOS
 WHERE fecha_entrega > fecha_esperada

-- 10. Return a list with the order code, customer code, expected date and delivery date of orders whose 
--      delivery date has been at least two days before the expected date. Using the DATEADD function
SELECT codPedido, codCliente, fecha_esperada, fecha_entrega
  FROM PEDIDOS 
 WHERE DATEADD(day, 2, fecha_entrega) <= fecha_esperada

-- 11. Same query, but using the DATEDIFF function
SELECT codPedido, codCliente, fecha_esperada, fecha_entrega
  FROM PEDIDOS 
 WHERE DATEDIFF(day, fecha_entrega, fecha_esperada) >= 2

-- 12. Return a list of all orders that were rejected (rechazados) in 2022
SELECT codPedido
  FROM PEDIDOS
 WHERE codEstado = 'R'

-- 13. Return a list of all orders that have been delivered in the month of January of any year
SELECT codPedido, fecha_entrega
  FROM PEDIDOS
 WHERE DATENAME(month, fecha_entrega) = 'January'  

-- 14. Return a list of all payments made in 2022 using ‘PayPal’. Sort the result from highest to lowest price (de mayor a menor)
SELECT id_transaccion
  FROM PAGOS
 WHERE codFormaPago = 'P'

-- 15. Return a list of all the payment methods that appear in the payment table. 
--  Please note that repeated payment methods should not appear.
SELECT DISTINCT(codFormaPago)
  FROM PAGOS

-- 16. Return a list with all the products that belong to the ‘Ornamentales’ category and that have more than 100 units in stock.
-- NOTE: The list must be sorted by its sale price, showing first the highest price.
SELECT  codProducto
  FROM PRODUCTOS
 WHERE codCategoria = 'OR'

-- 17. Return a list with all customers who are from the city of Madrid and whose sales representative has the employee code 11 or 30.
SELECT codCliente
  FROM CLIENTES 
 WHERE codEmpl_ventas IN(11, 30)


----------------------------------------------------------------
-- B) Grouping queries and/or aggregated functions (14)       --
----------------------------------------------------------------
-- 18. How many employees are there in the company?
SELECT COUNT(codEmpleado)
  FROM EMPLEADOS
  

-- 19. How many customers does each country have?
SELECT pais NumClientes, COUNT(codCliente) NumClientes   -- Puse el pais para que se note mas facilmente de que pais es cada suma de clientes
  FROM CLIENTES 
 GROUP BY pais

-- 20. What was the average payments for 2022?
SELECT AVG(importe_pago)
  FROM PAGOS
 WHERE DATENAME(year, fechaHora_pago) = 2022


-- 21. How many orders are there in each state? Sorts the result downward by the number of orders.
SELECT codEstado, COUNT(codPedido)
  FROM PEDIDOS
 GROUP BY codEstado
  ORDER BY COUNT(codPedido) DESC

-- 22. Calculate the sale price of the most expensive and cheapest product in the same consultation.
SELECT MAX(precio_venta), MIN(precio_venta)
  FROM PRODUCTOS

-- 23. How many customers does the city of Madrid have?
SELECT COUNT(codCliente)
  FROM CLIENTES
 WHERE ciudad = 'Madrid'

-- 24. How many customers does each of the cities that start with M have?
SELECT ciudad, COUNT(codCliente)
  FROM CLIENTES
 WHERE LEFT(ciudad, 1) = 'M'
 GROUP BY ciudad 

-- 25. Returns the employee code of the sales reps and the number of customers each serves.
SELECT codEmpl_ventas, COUNT(codCliente) NumClientes
  FROM CLIENTES
 GROUP BY codEmpl_ventas

-- 26. Calculate the number of customers you are not assigned a sales representative.
SELECT COUNT(CodCliente)
  FROM CLIENTES
 WHERE codEmpl_ventas is NULL

-- 27. Calculate the number of different products in each of the orders.
SELECT codPedido, COUNT(DISTINCT(codProducto)) NumDifferentProducts
  FROM DETALLE_PEDIDOS 
 GROUP BY codPedido 

-- 28. Calculate the sum of the total quantity of all the products that appear in each of the orders
SELECT SUM(cantidad)
  FROM DETALLE_PEDIDOS
 GROUP BY codPedido

-- 29. Return a list of the 20 best-selling products and the total number of units of each that have been sold.
-- The list must be ordered by the total number of units sold.
SELECT TOP 20 codProducto, SUM(cantidad)
  FROM DETALLE_PEDIDOS
 GROUP BY codProducto
 ORDER BY SUM(cantidad) DESC
  

-- 30. Get the number of employees per office, as long as the number of employees is greater than 4.
SELECT codOficina, COUNT(codEmpleado)
  FROM EMPLEADOS
 GROUP BY codOficina
HAVING COUNT(codEmpleado) > 4

-- 31. Obtain the customers who have made more than two payments of minimum 1000 euros. Also show the number of payments made.


----------------------------------------------------------------
--				C) Multitable queries (10)				  --
----------------------------------------------------------------

-- 32. Get product names, quantity, and price for products included in orders 3 and 5. Order it by order number and product number ascending.
--SELECT ;

-- 33. Get a list of the names of customers who have made a payment. The fields customer name, payment date and total should appear in ascending order by id client and payment date.
--SELECT ;

-- 34. Get a list with each customer's name and the first and last name of their sales representative.
--SELECT ;

-- 35. Show the name of the customers that have made payments along with the name of their sales representatives. They should only appear once.
--SELECT ;

-- 36. Return the name of the customers who have made payments and the name of their representatives along with the city of the office to which the representative belongs.
--SELECT ;

-- 37. List the address of the offices that have clients in Fuenlabrada.
--SELECT ;

-- 38. Return a list with the name of the employees along with the name of their bosses (you must use two aliases for the EMPLEADOS table).
--SELECT ;

-- 39. Return the name of customers who have not been delivered an order on time.
-- If multiple orders have been delayed, the customer should only appear once.
--SELECT ;

-- 40. Display the name of customers and the number of payments they have made.
-- They must appear all of them, regardless of whether they have made a payment or not (aparecerán todos hayan hecho o no algún pago).
--SELECT ;

-- 41. Show the name of clients and the number of orders that have been delivered.
-- They must all appear, regardless of whether they have made an order or not.
--SELECT ;


