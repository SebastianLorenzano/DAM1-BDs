SELECT codPedido, SUM(cantidad*precio_unidad) ImpTotal
  FROM DETALLE_PEDIDOS
 GROUP BY codPedido

SELECT codCategoria, Count(codProducto) NumArticulos
  FROM PRODUCTOS
 GROUP BY codCategoria