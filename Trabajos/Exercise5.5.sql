		--------------------------------------------------
		-- Exercise 5.5. Write the following queries
		--					using the database JARDINERIA
		--------------------------------------------------

				--------------------------
				--		QUERIES		    --
				--------------------------

-----------------------------------
--		A) Set queries (4)		 --
-----------------------------------
USE JARDINERIA
SELECT * FROM FORMA_PAGO
-- 1. Return the codes of customers who placed orders in 2022 and customers who made transfer payments. Use the UNION.
SELECT DISTINCT codCliente
  FROM PEDIDOS
 WHERE YEAR(fecha_pedido) = '2022'
 UNION
 SELECT DISTINCT codCliente
   FROM PAGOS
  WHERE codFormaPago = 'T'

-- 2. Return the codes of customers who placed orders in 2022 and who also made some payment by transfer. Use the INTERSECTION.
SELECT DISTINCT codCliente
  FROM PEDIDOS
 WHERE YEAR(fecha_pedido) = 2022
INTERSECT
 SELECT DISTINCT codCliente
   FROM PAGOS
  WHERE codFormaPago = 'T'

-- 3. Return the codes of customers who placed orders in 2022 BUT NOT customers who made transfer payments. Use the DIFFERENCE.
SELECT DISTINCT codCliente
  FROM PEDIDOS
 WHERE YEAR(fecha_pedido) = 2022
EXCEPT
 SELECT DISTINCT codCliente
   FROM PAGOS
  WHERE codFormaPago = 'T'
-- 4. Propose a statement of a set query and write the SQL query.

-- This query selects those employees who have a salary equal or greater than 2000 and are assigned as a sales employee to a client.
SELECT codEmpleado
  FROM EMPLEADOS
 WHERE salario >= 2000
 INTERSECT
 SELECT DISTINCT codEmpl_ventas
  FROM CLIENTES



-----------------------------------
--		B) Subqueries (22)		 --
-----------------------------------
-- With basic comparison operators (6)

-- 1. Return the name of the customer with the highest credit limit.
SELECT nombre_cliente														
  FROM CLIENTES
 WHERE limite_credito = (SELECT MAX(limite_credito) FROM CLIENTES)

-- 2. Return the name of the product with the most expensive selling price.
SELECT nombre
  FROM PRODUCTOS
 WHERE precio_venta = (SELECT MAX(precio_venta) FROM PRODUCTOS)

-- 3. Return the product that has the most units in stock. If several come out, stay with only one.
SELECT TOP 1 *
  FROM PRODUCTOS
 WHERE cantidad_en_stock = (SELECT MAX(cantidad_en_stock) FROM PRODUCTOS)

-- 4. Return the product with the fewer units in stock.
SELECT ;

-- 5. Return the name, surname and email of the employees who are in charge of Alberto Soria.
SELECT ;

-- 6. Propose the statement of a query that uses a subquery and write the SQL query (it can be of any type, with IN, NOT IN, ALL, ANY, etc).
SELECT ;


--------------------------------------------------------------------
--  Subconsultas con ALL y ANY  --
--  IMPORTANTE: NO UTILIZAR MAX o MIN en las subconsultas
--------------------------------------------------------------------
-- 1. Return the name of the customer with the highest credit limit.
SELECT ;

-- 2. Return the name of the product with the most expensive sales price
SELECT ;

-- 3. Return the product with fewer units in stock
SELECT ;



-----------------------------------
-- Subqueries with IN and NOT IN --
-----------------------------------

-- 1. Return a list that shows only customers who have not made any payments.
SELECT ;

-- 2. Return a list that shows only customers who have made any payments.
SELECT ;

-- 3. Return a list of products that have never appeared in any order.
SELECT ;

-- 4. Return the name, last name, position and office telephone number of those employees who are not sales representatives of any client.
SELECT ;

-- 5. Return the offices where any of the employee�s work (donde trabaje alg�n empleado).
SELECT ;

-- 6. Return a list of customers who have placed an order but have not made any payments.
SELECT ;


-----------------------------------------------
-- Subqueries with EXISTS and NOT EXISTS (4) --
-----------------------------------------------

-- 1. Return a listing that shows only customers who have not made a payment.
SELECT ;

-- 2. Return a listing that shows only customers who have made a payment.
SELECT ;

-- 3. Return a list of products that have never appeared in any order.
SELECT ;

-- 4. Return a list of products that have ever appeared in any order.
SELECT ;

-----------------------
--		Views (3)	 --
-----------------------
-- 1. Create a view that returns the codes of customers who placed orders in 2009 and customers who made transfer payments. Use the UNION.

-- 2. Write the SQL code to query the view.

-- 3. Write the SQL code to delete that view.

