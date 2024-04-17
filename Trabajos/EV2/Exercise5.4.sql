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
 WHERE pais = 'España'

-- 3. Return a list with the first name, last name, and email of employees whose boss has a boss code equal to 7.
SELECT nombre, apellido1, apellido2, email
  FROM EMPLEADOS
 WHERE codEmplJefe = 7

-- 4. Return the name of the position, name, surname and email of the head of the company (jefe). Tip: You will recognise the boss because it does not have a boss.
SELECT puesto_cargo, nombre, apellido1, apellido2, email 
  FROM EMPLEADOS
 WHERE codEmplJefe is NULL

-- 5. Return a list with the name, surname and post of those employees who are not sales representatives (remember that the != operator is not SQL standard and should not be used).
SELECT nombre, apellido1, apellido2, puesto_cargo
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
SELECT codPedido, fecha_pedido, fecha_esperada, fecha_entrega, codEstado, comentarios, codCliente
  FROM PEDIDOS
 WHERE codEstado = 'R'
   AND YEAR(fecha_pedido) = '2022'
                                         
-- 13. Return a list of all orders that have been delivered in the month of January of any year
SELECT *
  FROM PEDIDOS                                         
 WHERE DATENAME(month, fecha_entrega) = 'January'  
   AND codEstado = 'E'
-- 14. Return a list of all payments made in 2022 using ‘PayPal’. Sort the result from highest to lowest price (de mayor a menor)
SELECT *
  FROM PAGOS
 WHERE codFormaPago = 'P'
   AND YEAR(fechaHora_pago) = '2022'    --En la pagina hay que poner ASC para que funcione
 ORDER BY importe_pago DESC

-- 15. Return a list of all the payment methods that appear in the payment table. 
--  Please note that repeated payment methods should not appear.
SELECT DISTINCT(codFormaPago)
  FROM PAGOS

-- 16. Return a list with all the products that belong to the ‘Ornamentales’ category and that have more than 100 units in stock.
-- NOTE: The list must be sorted by its sale price, showing first the highest price.
SELECT *
  FROM PRODUCTOS
 WHERE codCategoria = 'OR'
   AND cantidad_en_stock > 100
 ORDER BY precio_venta DESC

-- 17. Return a list with all customers who are from the city of Madrid and whose sales representative has the employee code 11 or 30.
SELECT *
  FROM CLIENTES 
 WHERE codEmpl_ventas IN(11, 30)
   AND ciudad = 'Madrid'

----------------------------------------------------------------
-- B) Grouping queries and/or aggregated functions (14)       --
----------------------------------------------------------------
-- 18. How many employees are there in the company?
SELECT COUNT(codEmpleado)
  FROM EMPLEADOS
  

-- 19. How many customers does each country have?
SELECT pais, COUNT(codCliente) NumClientes   
  FROM CLIENTES 
 GROUP BY pais
 

-- 20. What was the average payments for 2022?
SELECT AVG(importe_pago)
  FROM PAGOS  
 WHERE YEAR(fechaHora_pago) = 2022


-- 21. How many orders are there in each state? Sorts the result downward by the number of orders.
SELECT codEstado, COUNT(codPedido)
  FROM PEDIDOS
 GROUP BY codEstado
  ORDER BY COUNT(codPedido) DESC

-- 22. Calculate the sale price of the most expensive and cheapest product in the same consultation.
SELECT MIN(precio_venta) MasBarato, MAX(precio_venta) MasCaro
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
SELECT codPedido, SUM(cantidad)
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

SELECT codCliente, COUNT(id_transaccion) numTransacciones
  FROM PAGOS
 WHERE importe_pago >= 1000
 GROUP BY codCliente
HAVING COUNT(importe_pago) > 2


----------------------------------------------------------------
--				C) Multitable queries (10)				  --
----------------------------------------------------------------

-- 32. Get product names, quantity, and price for products included in orders 3 and 5. 
  --Order it by order number and product number ascending.


SELECT p.nombre, d.cantidad, p.precio_venta
  FROM DETALLE_PEDIDOS d,
       PRODUCTOS p
 WHERE d.codPedido IN (3, 5)
   AND d.codProducto = p.codProducto
 ORDER BY d.codPedido, d.codProducto ASC


-- 33. Get a list of the names of customers who have made a payment. The fields customer name, 
  -- payment date and total should appear in ascending order by id client and payment date.
SELECT c.nombre_cliente, p.fechaHora_pago, p.importe_pago
  FROM CLIENTES c, PAGOS p
 WHERE c.codCliente = p.codCliente
 ORDER BY c.codCliente, p.fechaHora_pago ASC
 
-- 34. Get a list with each customer's name and the first and last name of their sales representative.
SELECT c.nombre_cliente, CONCAT(e.nombre,' ', e.apellido1, ' ',apellido2) nombre_empleado
  FROM CLIENTES c, EMPLEADOS e 
 WHERE c.codEmpl_ventas = e.codEmpleado

-- 35. Show the name of the customers that have made payments along with the name of their 
  -- sales representatives. They should only appear once.
SELECT c.nombre_cliente, CONCAT(e.nombre,' ',e.apellido1,' ',e.apellido2) NombreRepresentante
  FROM CLIENTES c, PAGOS p, EMPLEADOS e
 WHERE c.codCliente = p.codCliente
   AND c.codEmpl_ventas = e.codEmpleado
 GROUP BY c.nombre_cliente, e.nombre, e.apellido1, e.apellido2
HAVING COUNT(p.importe_pago) > 0 
 ORDER BY e.nombre ASC            --Lo ordene porque te pide que lo ordenes la pagina



-- 36. Return the name of the customers who have made payments and the name of their representatives 
  -- along with the city of the office to which the representative belongs.
SELECT c.nombre_cliente, CONCAT(e.nombre,' ',e.apellido1,' ',e.apellido2) NombreRepresentante, o.ciudad 
  FROM CLIENTES c, EMPLEADOS e, OFICINAS o, PAGOS p
 WHERE p.codCliente = c.codCliente
   AND c.codEmpl_ventas = e.codEmpleado 
   AND e.codOficina = o.codOficina
 GROUP BY c.nombre_cliente, e.nombre, e.apellido1, e.apellido2, o.ciudad
HAVING COUNT(id_transaccion) > 0

-- 37. List the address of the offices that have clients in Fuenlabrada.
SELECT DISTINCT(o.linea_direccion1), o.linea_direccion2
  FROM OFICINAS o, CLIENTES c, EMPLEADOS e
 WHERE c.codEmpl_ventas = e.codEmpleado
   AND e.codOficina = o.codOficina
   AND c.ciudad = 'Fuenlabrada'

-- 38. Return a list with the name of the employees along with the name of their bosses 
  --(you must use two aliases for the EMPLEADOS table).
SELECT CONCAT(e.nombre,' ',e.apellido1,' ',e.apellido2) NombreEmpleado, CONCAT(j.nombre,' ',j.apellido1,' ',j.apellido2) JefeEmpleado
  FROM EMPLEADOS e, EMPLEADOS j 
 WHERE e.codEmplJefe = j.codEmpleado
 ORDER BY j.nombre ASC                          -- Aca tambien pide ordenar

-- 39. Return the name of customers who have not been delivered an order on time.
-- If multiple orders have been delayed, the customer should only appear once.
SELECT DISTINCT(c.nombre_cliente)
  FROM CLIENTES c, PEDIDOS p
 WHERE c.codCliente = p.codCliente
   AND fecha_entrega > fecha_esperada

-- 40. Display the name of customers and the number of payments they have made.
-- They must appear all of them, regardless of whether they have made a payment or not 
  -- (aparecerán todos hayan hecho o no algún pago).
SELECT c.codCliente, c.nombre_cliente, COUNT(id_transaccion) NumPagos
  FROM CLIENTES c LEFT JOIN PAGOS p
    ON c.codCliente = p.codCliente
 GROUP BY c.codCliente, c.nombre_cliente

-- 41. Show the name of clients and the number of orders that have been delivered.
-- They must all appear, regardless of whether they have made an order or not.
SELECT c.codCliente, nombre_cliente, COUNT(codPedido) numEntregas
  FROM CLIENTES c LEFT JOIN PEDIDOS p
    ON c.codCliente = p.codCliente
   AND p.codEstado = 'E'
 GROUP BY c.codCliente, c.nombre_cliente







