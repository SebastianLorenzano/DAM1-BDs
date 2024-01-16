SELECT *
  FROM PAGOS p,
       CLIENTES c
  WHERE p.codCliente = c.codCliente

SELECT p.*, c.nombre_cliente
  FROM PAGOS p,
       CLIENTES c
 WHERE p. codCliente = c.codCliente 


 SELECT p.*, c.nombre_cliente
  FROM PEDIDOS p,
       CLIENTES c
 WHERE p. codCliente = c.codCliente 


 SELECT e.*, j.nombre nombre_jefe
   FROM EMPLEADOS e,
        EMPLEADOS j
  WHERE e.codEmplJefe = j.codEmpleado

  