USE JARDINERIA

---------------------------
--   Task. Jardiner�a    --
---------------------------
SELECT * FROM OFICINAS
SELECT * FROM EMPLEADOS
SELECT * FROM CLIENTES
-- 1. Insert a new office in Alicante.

INSERT INTO OFICINAS (codOficina, ciudad, pais, codPostal, telefono, linea_direccion1)
VALUES ('ALI-ES','Alicante', 'España', '1876', '12312312', 'casaDePepe')


-- 2. Insert a new employee for the Alicante office who is a sales representative.
INSERT INTO EMPLEADOS(codEmpleado, nombre, apellido1, email, puesto_cargo, salario, codOficina, tlf_extension_ofi)
VALUES ((SELECT MAX(codEmpleado) FROM EMPLEADOS) + 1, 'Pepe', 'Gonzalez', 'pepeGonzalez@gmail.com', 
        'Representante Ventas', 1200, 'ALI-ES', '3') 



--3. Insert a client who has the employee we created in the previous step as a sales representative.
INSERT INTO CLIENTES(codCliente, nombre_cliente, nombre_contacto, telefono, linea_direccion1, ciudad, codEmpl_ventas)
VALUES ((SELECT MAX(codCliente) FROM CLIENTES) + 1, 'Amazon', 'Juan', 1313113, 'Yapeyu 493', 'Buenos Aires', 
    (SELECT codEmpleado FROM EMPLEADOS WHERE email = 'pepeGonzalez@gmail.com'))

SELECT * FROM PEDIDOS

-- 4. Insert an order that contains at least three products for the customer we just created.
INSERT INTO PEDIDOS(codPedido, fecha_pedido, fecha_esperada, codEstado, codCliente)
VALUES ((SELECT MAX(codPedido) FROM PEDIDOS) + 1, '2024-02-15', '2024-02-20', 'P', 
(SELECT codCliente FROM CLIENTES WHERE nombre_cliente = 'Amazon'))

INSERT INTO DETALLE_PEDIDOS(codPedido, codProducto, cantidad, precio_unidad, numeroLinea)
VALUES ((SELECT MAX(codPedido) FROM PEDIDOS), 1, 2, 10, 1),
       ((SELECT MAX(codPedido) FROM PEDIDOS), 2, 3, 20, 2),
       ((SELECT MAX(codPedido) FROM PEDIDOS), 3, 1, 30, 3)


SELECT * FROM PEDIDOS

--5. Update and/or delete the client code we created in the previous step. 
    --Has it been possible to update or delete it? Why? Find out if there were any changes 
        --to the related tables.
UPDATE CLIENTES
   SET codCliente = 100
 WHERE codCliente = 39
SELECT * FROM CLIENTES

-- An error with the message 547 says that the UPDATE statement conflicted with the reference
    -- constraint "FK_PEDIDOS_CLIENTES",  and that the conflict ocurred in dbo.PEDIDOS, column "codCliente"




--6.  Update the number of units ordered in the order you created before as follows:
-- For the 1st product it will be 3 units, for product 2 it will be 2 units and for the third just 1 unit.
UPDATE DETALLE_PEDIDOS
   SET cantidad = 3
 WHERE codPedido = 129 AND codProducto = 1
 UPDATE DETALLE_PEDIDOS
   SET cantidad = 2
 WHERE codPedido = 129 AND codProducto = 2
 UPDATE DETALLE_PEDIDOS
   SET cantidad = 1
 WHERE codPedido = 129 AND codProducto = 3

--7.  Modify the date of the order we created to the current date and time.
UPDATE PEDIDOS 
   SET fecha_pedido = GETDATE()
 WHERE codPedido = 129

--8. Increase by 5% the price of the products that are included in the order you created before.
-- Remember that you may need to round and/or use the CAST function (XXX as FLOAT)
-- SELECT * FROM PRODUCTOS WHERE codProducto IN (SELECT codProducto FROM DETALLE_PEDIDOS WHERE codPedido = 129)
UPDATE PRODUCTOS
   SET precio_venta = precio_venta * 1.05
 WHERE codProducto IN (SELECT codProducto FROM DETALLE_PEDIDOS WHERE codPedido = 129)

--9. Leave the price of such products back as it was previously.
UPDATE PRODUCTOS
   SET precio_venta = 14.00
 WHERE codProducto IN (1, 2)


UPDATE PRODUCTOS
   SET precio_venta = precio_venta / 1.05
 WHERE codProducto IN (SELECT codProducto FROM DETALLE_PEDIDOS WHERE codPedido = 129)

--10.  What would be the sequence of deleting table records until finally the Alicante office we created in 
  --    exercise 1 can be deleted? Once you have the script, check that it can be deleted.
DECLARE @codOfi AS CHAR(6)
SET @codOfi = (SELECT codOficina FROM OFICINAS WHERE ciudad = 'Alicante');
UPDATE CLIENTES
SET codEmpl_ventas = NULL
WHERE codEmpl_ventas = (SELECT codEmpl_ventas
                        FROM CLIENTES
                        WHERE codEmpl_ventas IN(SELECT codEmpleado 
                                                FROM EMPLEADOS WHERE codOficina = @codOfi))
DELETE FROM EMPLEADOS
WHERE codOficina = @codOfi
DELETE FROM OFICINAS
WHERE codOficina = @codOfi

--11. Increase by 20% the price of products that are NOT included in any order.
-- Remember that you may need to round and/or use the CAST function (XXX as FLOAT)
UPDATE PRODUCTOS
SET precio_venta = precio_venta * 1.2
WHERE codProducto NOT IN (SELECT codProducto FROM DETALLE_PEDIDOS)



--12.  Leave the price of the products back as it was previously.
UPDATE PRODUCTOS
SET precio_venta = precio_venta / 1.2
WHERE codProducto NOT IN (SELECT codProducto FROM DETALLE_PEDIDOS)

--13.  Remove the customers who haven't made any payments.
DELETE FROM CLIENTES
WHERE codCliente NOT IN (SELECT DISTINCT codCliente FROM PAGOS)

--14.  Remove customers who have not placed a minimum of 2 orders 
  --  (NOTE: when executing the statement it will fail because of the referential integrity, 
  --  that is, because there are tables that have related the Client id as FK).
DELETE FROM CLIENTES
WHERE codCliente NOT IN (SELECT codCliente, COUNT(codCliente) 
                         FROM PAGOS 
                         GROUP BY codCliente 
                         HAVING COUNT(codCliente) >= 2)

--15. Remove the payments from the customer with the lowest credit limit.
DELETE FROM PAGOS
WHERE codCliente = (SELECT codCliente FROM CLIENTES WHERE limite_credito = (SELECT MIN(limite_credito) FROM CLIENTES))

--16. Update the city to Alicante for those customers who have a credit limit lower than ALL prices of products 
  --in the Ornamental category (there may be none).
UPDATE CLIENTES
SET ciudad = 'Alicante'
WHERE limite_credito < ALL (SELECT limite_credito FROM PEDIDOS)


--17. Update the city to Madrid for those customers who have a monthly credit limit lower than ANY of the 
    --prices of the products in the Ornamental category.
UPDATE CLIENTES
SET ciudad = 'Madrid'
WHERE limite_credito / 12 < ANY (SELECT precio_venta FROM PRODUCTOS)


--18. Set to 0 the customer's credit limit that fewer units ordered of the OR-179 product.
SELECT codProducto FROM PRODUCTOS WHERE refInterna = 'OR-179'
UPDATE CLIENTES
SET limite_credito = 0
WHERE codCliente = (SELECT TOP 1 pe.codCliente
                      FROM PEDIDOS pe, PRODUCTOS pr, DETALLE_PEDIDOS dp
                     WHERE pe.codPedido = dp.codPedido
                       AND dp.codProducto = pr.codProducto
                       AND pr.refInterna = 'OR-179'
                     ORDER BY cantidad DESC)


--19. Modify the detalle_pedido table to insert a numeric field called IVA. Set the value of that field to 18 for those records 
  --whose order is dated from January 2009. Then update the rest of the orders by setting IVA to 21.
ALTER TABLE DETALLE_PEDIDOS
ADD iva TINYINT;

UPDATE DETALLE_PEDIDOS
SET iva = 21

UPDATE DETALLE_PEDIDOS
SET iva = 18
WHERE codPedido IN(SELECT codPedido FROM PEDIDOS WHERE fecha_pedido BETWEEN '2009-01-01' AND '2009-01-31')


--20. Modify the detalle_pedido table to incorporate a numeric field called total_linea and update all your records to 
    --calculate their value with the following formula:
-- total_linea = precio_unidad*cantidad * (1 + (iva/100));
ALTER TABLE DETALLE_PEDIDOS
ADD total_linea AS CAST(precio_unidad * cantidad * (1 + (iva/100)) AS DECIMAL(9, 2))

--21.  Create a table called HISTORICO_CLIENTES that has the same structure as CUSTOMERS and also a field called registrationDate of type DATE.
-- You must insert in a single statement the customers whose name contains the letter 's' and inform the registrationDate as the current date/time.
SELECT * 
  INTO HISTORICO_CLIENTES
  FROM CLIENTES
 WHERE nombre_cliente LIKE '%s%'

 ALTER TABLE HISTORICO_CLIENTES
 ADD registrationDate AS GETDATE()


--22.  Update the region, pais and codigo_postal fields in the CLIENT�s table to NULL for all records. 
  --Use just one update statement that updates these 3 fields from the existing data in table HISTORICO_CLIENTES.
    --Verify that the data has been moved correctly.

UPDATE CLIENTES
SET pais = null, codPostal = null     
SELECT * FROM CLIENTES	

UPDATE cli
SET cli.codPostal = his.codPostal, cli.pais = his.pais
FROM CLIENTES cli INNER JOIN HISTORICO_CLIENTES his ON cli.codCliente = his.codCliente;





