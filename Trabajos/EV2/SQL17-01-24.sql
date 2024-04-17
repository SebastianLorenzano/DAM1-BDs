USE JARDINERIA

SELECT c.codCliente, c.nombre_cliente, COUNT(p.codCliente)
  FROM  PAGOS p,
		CLIENTES c
 WHERE p.codCliente = c.codCliente
 GROUP BY c.codCliente, c.nombre_cliente


 SELECT c.codCliente, c.nombre_cliente, COUNT(p.codCliente)
  FROM  CLIENTES c LEFT JOIN PAGOS p
    ON p.codCliente = c.codCliente
 GROUP BY c.codCliente, c.nombre_cliente

SELECT c.codCliente, c.nombre_cliente,
       COUNT(p.codCliente) Numpagos,
       ISNULL(SUM(p.importe_pago), 0) TotalPagos
  FROM CLIENTES c LEFT JOIN PAGOS p
    ON p.codCliente = c.codCliente