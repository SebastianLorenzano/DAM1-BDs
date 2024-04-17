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

SELECT pe.codPedido, pe.fecha_pedido, 
       de.codProducto, de.cantidad, 
       pr.nombre, 
       ca.nombre
  FROM  PEDIDOS pe,
        DETALLE_PEDIDOS de,
        PRODUCTOS pr,
        CATEGORIA_PRODUCTOS ca
 WHERE pe.codPedido = de.codPedido 
   AND de.codProducto = pr.codProducto
   AND pr.codCategoria = ca.codCategoria

SELECT *
  FROM PEDIDOS

SELECT *
  FROM DETALLE_PEDIDOS

SELECT *
  FROM PRODUCTOS


SELECT e.codEmpleado, e.nombre
  FROM EMPLEADOS e LEFT JOIN EMPLEADOS j
    ON e.codEmplJefe = j.codEmplJefe