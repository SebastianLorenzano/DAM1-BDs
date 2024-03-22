USE JARDINERIA

						---------------------------
						-- EJERCICIOS UD7 - TSQL -- 
						---------------------------
					
-------------------------------------------------------------------------------------------
-- NOTA: Recuerda cuidar la limpieza del código (tabulaciones, nombres de tablas en mayúscula,
--		nombres de variables en minúscula, poner comentarios sin excederse, código organizado y fácil de seguir, etc.)
-------------------------------------------------------------------------------------------
-- 1. Crea un script que use un bucle para calcular la potencia de un número.
--		Tendremos dos variables: el número y la potencia
--
--		Ejemplo.
--		Número = 3		Potencia = 4		result = 3*3*3*3 = 81
--
--		Si el número o la potencia son 0 o <0 devolverá el mensaje: “La operación no se puede realizar.
-------------------------------------------------------------------------------------------
GO
DECLARE @number1 INT = 3, @number2 INT = 4
DECLARE @numericResult INT = @number1
DECLARE @result VARCHAR(600) 
	PRINT 'Hola1'
IF (@number1 <= 0 OR @number2 <= 0)
BEGIN
	PRINT 'La operación no se puede realizar.'
END
ELSE
BEGIN
	PRINT 'Hola3'
	SET @result = CONCAT('Número = ', @number1, '    Potencia = ', @number2, '    Resultado = ')
	SET @number2 -= 1
	SET @result += CAST(@number1 AS VARCHAR)
	WHILE (@number2 > 0)
	BEGIN
		SET @numericResult *= @number1
		SET @number2 -= 1
		SET @result += CONCAT('*', @number1)
	END
	SET @result += CONCAT(' = ', @numericResult)
END
PRINT @result

------------------------------------------------------------------------------------------
-- 2. Crea un script que calcule las soluciones de una ecuación de segundo grado ax^2 + bx + c = 0
--
--	Debes crear variables para los valores a, b y c.
--  Al principio debe comprobarse que los tres valores son positivos, en otro caso, 
--		se devolverá el mensaje 'Cálculo no implementado'
--	
--	Consulta esta página para obtener la fórmula a implementar (recuerda que habrá DOS soluciones): 
--		http://recursostic.educacion.es/descartes/web/Descartes1/4a_eso/Ecuacion_de_segundo_grado/Ecua_seg.htm#solgen

--	Salida esperada para los valores: a=3, b=-4, c=1 --> sol1= 1 y sol2= 0.33
--	
--	NOTA: Si no sale lo mismo, te recomiendo revisar bien el orden de prioridad de los operadores... ()
-------------------------------------------------------------------------------------------

GO
DECLARE @a INT = 3, @b INT = -4, @c INT = 1
DECLARE @sol1 DECIMAL(9,2), @sol2 DECIMAL(9,2)

IF (@a < 0 OR @c < 0)
BEGIN
	PRINT 'Cálculo no implementado'
END
ELSE
BEGIN
	SET @sol1 = (-@b + SQRT(@b*@b - 4 * @a *@c))/ (2 * @a)
	SET @sol2 = (-@b - SQRT(@b*@b - 4 * @a *@c))/ (2 * @a)
	PRINT CONCAT('a=', @a, ', b=', @b, ', c=', @c, ', --> sol1= ' ,@sol1 , ' y sol2= ' ,@sol2)
END




-------------------------------------------------------------------------------------------
-- 3. Crea un script que calcule la serie de Fibonacci para un número dado.

-- La sucesión es: 1,1,2,3,5,8,13,21,34,55,89,144,233,377,610,987,1597...
-- Si te fijas, se calcula sumando el número anterior al siguiente:
--	Ejemplo. Si se introduce el numero 3 significa que tendremos que hacer 3 iteraciones:
--			ini = 1
--			0+1 = 1
--			1+1 = 2
--			2+1 = 3
--			3+2 = 5
--			5+3 = 8
--			...
-- 
--	Ayuda: Quizás necesites guardar en algún sitio el valor actual de la serie antes de sumarlo...
-------------------------------------------------------------------------------------------

GO
DECLARE @n INT = 14
DECLARE @number1 INT = 1, @number2 INT = 0, @number3 INT
DECLARE @result VARCHAR(600)
WHILE @n > 0
BEGIN
	SET @number3 = @number1 + @number2
	IF @result IS NULL
	BEGIN
		SET @result = @number3
	END
	ELSE
	BEGIN
		SET @result += CONCAT(',', @number3)
	END
	SET @number2 = @number1
	SET @number1 = @number3
	SET @n -= 1
END
PRINT @result



-------------------------------------------------------------------------------------------
-- 4. Utilizando la BD JARDINERIA, crea un script que realice lo siguiente:
--		Obtén el nombre del cliente con código 3 y guárdalo en una variable
--		Obtén el número de pedidos realizados por dicho cliente y guárdalo en una variable
--		Muestra por pantalla el mensaje: 'El cliente XXXX ha realizado YYYY pedidos.'
--		
--		result esperado: El cliente Gardening Associates ha realizado 9 pedidos.
--
--	    Reto opcional: Implementa el script utilizando una única consulta.
-------------------------------------------------------------------------------------------

GO
DECLARE @codCliente INT = 3, @numPedidos INT
DECLARE @nombreCliente VARCHAR(50)

SELECT @nombreCliente = c.nombre_cliente,
	   @numPedidos = COUNT(codPedido)
  FROM CLIENTES c,
       PEDIDOS p
 WHERE c.codCliente = p.codCliente
   AND c.codCliente = @codCliente
 GROUP BY c.codCliente, c.nombre_cliente

IF @nombreCliente IS NOT NULL
BEGIN
	PRINT CONCAT('El cliente ', @nombreCliente, ' ha realizado ', @numPedidos,' pedido/s.')
END


-------------------------------------------------------------------------------------------
-- 5. Utilizando la BD JARDINERIA, crea un script que realice lo siguiente:
--		Obtén el nombre y los apellidos de todos los empleados de la empresa
--		Deberás mostrar cada uno de ellos línea a línea utilizando PRINT
--		
--		Salida esperada:
--			Magaña Perez, Marcos
--			López Martinez, Ruben
--			Soria Carrasco, Alberto
--			Solís Jerez, Maria
--			...
--
--		Reto opcional: Modifica el script anterior para que muestre sólo los que trabajen en la oficina de Londres
--		Salida esperada:
--			Johnson , Amy
--			Westfalls , Larry
--			Walton , John
-------------------------------------------------------------------------------------------

GO
DECLARE @min INT, @max INT
DECLARE @nombreEmpleado VARCHAR(153)

SELECT @min = MIN(codEmpleado),
	   @max = MAX(codEmpleado)
  FROM EMPLEADOS

WHILE @min != @max
BEGIN

	SELECT @nombreEmpleado = CONCAT(apellido1, ' ',apellido2, ', ', nombre)
	  FROM EMPLEADOS
	 WHERE codEmpleado = @min

	PRINT @nombreEmpleado
	SET @min += 1
END

-------------------------------------------------------------------------------------------
-- 6. Utilizando la BD JARDINERIA, crea un script que realice lo siguiente:
--		Reutilizando el script del ejercicio 4, agrega la siguiente información a la salida:
--			Número de pedidos realizados por cada cliente
--			NOTA: Realízalo utilizando una consulta específica para obtener el número de pedidos de cada cliente.

--		Salida esperada:
--			El cliente GoldFish Garden ha realizado 11 pedidos.
--			El cliente Gardening Associates ha realizado 9 pedidos.
--			El cliente Gerudo Valley ha realizado 5 pedidos.
--			El cliente Tendo Garden ha realizado 5 pedidos.
--			El cliente Lasas S.A. ha realizado 0 pedidos.
--			...
--
--		Reto opcional:
--		Muestra también el coste total de todos los pedidos para cada cliente.
--
--		Salida esperada:
--			El cliente GoldFish Garden ha realizado 11 pedidos por un coste total de 10365.00.
--			El cliente Gardening Associates ha realizado 9 pedidos por un coste total de 13726.00.
--			El cliente Gerudo Valley ha realizado 5 pedidos por un coste total de 81849.00.
--			El cliente Tendo Garden ha realizado 5 pedidos por un coste total de 23794.00.
--			El cliente Lasas S.A. ha realizado 0 pedidos por un coste total de 0.00.
--			...
-------------------------------------------------------------------------------------------


GO
DECLARE @min INT, @max INT
DECLARE @nombreCliente VARCHAR(153)
DECLARE @cantPedidos INT, @total DECIMAL(9,2) = 0

SELECT @min = MIN(codCliente),
	   @max = MAX(codCliente)
  FROM CLIENTES

WHILE @min != @max
BEGIN
	SET @nombreCliente = null
	SELECT @nombreCliente = nombre_cliente
	  FROM CLIENTES
	 WHERE codCliente = @min

	SELECT @cantPedidos = COUNT(codPedido)
	  FROM PEDIDOS 
	 WHERE codCliente = @min
	 GROUP BY codCliente
	
	SELECT @total += (cantidad * precio_unidad)
	  FROM DETALLE_PEDIDOS
	 WHERE codPedido IN (SELECT codPedido
	 					   FROM PEDIDOS
						  WHERE codCliente = @min 
						   )


	IF @nombreCliente IS NOT NULL
	BEGIN
	PRINT CONCAT('El cliente ', @nombreCliente, ' ha realizado ', @cantPedidos, ' pedidos por un coste total de ', @total, '.')
	END
	SET @min += 1
END


-------------------------------------------------------------------------------------------
-- 7. Utilizando la BD JARDINERIA, crea un script que realice las siguientes operaciones:
--	Importante: debes utilizar TRY/CATCH y Transacciones si fueran necesarias.

--		Crea una nueva oficina (datos inventados)
--		Crea un nuevo empleado con datos inventados (el codEmpleado a insertar debes obtenerlo automáticamente)
--		Crea un nuevo cliente (datos inventados) (el codCliente a insertar debes obtenerlo automáticamente)
--		Asigna como representante de ventas el cliente anterior
-------------------------------------------------------------------------------------------
GO
SET IMPLICIT_TRANSACTIONS OFF
DECLARE @codEmpleado INT, @codCliente INT


BEGIN TRY
	SELECT @codEmpleado = MAX(codEmpleado) + 1
	FROM EMPLEADOS
	SELECT @codCliente = MAX(codCliente) + 1
	FROM CLIENTES

	BEGIN TRAN
	
	INSERT INTO OFICINAS (codOficina, ciudad, pais, codPostal, telefono, linea_direccion1, linea_direccion2)
	VALUES ('BSA-AR', 'CABA', 'Argentina', '1876', '39472318', 'Yapeyu 746', 'Esquina 25 de Mayo')

	INSERT INTO EMPLEADOS(codEmpleado, nombre, apellido1, apellido2, tlf_extension_ofi, email, puesto_cargo, salario, codOficina, codEmplJefe)
	VALUES (@codEmpleado, 'Sebastian', 'Lorenzano', null, '00001', 'selorenzano1@gmail.com', 'Jefe de oficina', 50000, 'BSA-AR', null)

	INSERT INTO CLIENTES (codCliente, nombre_cliente, nombre_contacto, apellido_contacto, telefono, email, linea_direccion1, linea_direccion2, ciudad, pais, codPostal, codEmpl_Ventas, limite_credito)
	VALUES (@codcliente, 'Jardinero S.A.', 'Juan', 'Perez', '81327493', 'pepelord@gmail.com', 'Av. Rivadavia 1234', 'Esquina Av. Corrientes', 'Buenos Aires', 'Argentina', '1876',  null, 10000)

-- Si despues tuviese que conseguir ese codEmpleado y ese codCliente sin tenerlo, pero si sabiendo los datos.

	SELECT @codEmpleado = codEmpleado
	  FROM EMPLEADOS
	 WHERE nombre = 'Sebastian'
	   AND apellido1 = 'Lorenzano'
	   AND tlf_extension_ofi = '00001'
	   AND email = 'selorenzano1@gmail.com'
	   AND puesto_cargo = 'Jefe de oficina'
	   AND codOficina = 'BSA-AR'

	SELECT @codCliente = codCliente
	  FROM CLIENTES
	 WHERE nombre_cliente = 'Jardinero S.A.'
	   AND nombre_contacto = 'Juan'
	   AND apellido_contacto = 'Perez'
	   AND email = 'pepelord@gmail.com'
	   AND linea_direccion1 = 'Av. Rivadavia 1234'
	   AND linea_direccion2 = 'Esquina Av. Corrientes'
	   AND ciudad = 'Buenos Aires'

	UPDATE CLIENTES
	SET codEmpl_Ventas = @codEmpleado
	WHERE codCliente = @codCliente

	COMMIT
END TRY

BEGIN CATCH
	ROLLBACK
	PRINT CONCAT ('CODERROR: ', ERROR_NUMBER(),
 				  ', DESCRIPCION: ', ERROR_MESSAGE(),
 				  ', LINEA: ', ERROR_LINE())
	RETURN
END CATCH

SET IMPLICIT_TRANSACTIONS ON


--SELECT * FROM OFICINAS
-------------------------------------------------------------------------------------------
-- 8. Utilizando la BD JARDINERIA, crea un script que realice las siguientes operaciones:
--	Importante: debes utilizar TRY/CATCH y Transacciones si fueran necesarias.
--
--		Debes eliminar la oficina, el empleado y el cliente creados en el apartado anterior.
--		Debes crear variables con los identificadores de clave primaria para eliminar
--			todos los datos de cada una de las tablas en una sola ejecución
-------------------------------------------------------------------------------------------
GO
SET IMPLICIT_TRANSACTIONS OFF
DECLARE @codEmpleado INT, @codCliente INT, @codOficina CHAR(6) = 'BSA-AR'

BEGIN TRY
	BEGIN TRAN
	
	SELECT @codEmpleado = codEmpleado
	  FROM EMPLEADOS
	 WHERE nombre = 'Sebastian'
	   AND apellido1 = 'Lorenzano'
	   AND email = 'selorenzano1@gmail.com'

	SELECT @codCliente = codCliente
	  FROM CLIENTES
	 WHERE nombre_cliente = 'Jardinero S.A.'
	   AND email = 'pepelord@gmail.com'


	DELETE FROM CLIENTES
	 WHERE codCliente = @codCliente

	DELETE FROM EMPLEADOS
	 WHERE codEmpleado = @codEmpleado

	DELETE FROM OFICINAS
	 WHERE codOficina = @codOficina
	COMMIT
END TRY

BEGIN CATCH
	ROLLBACK
	PRINT CONCAT ('CODERROR: ', ERROR_NUMBER(),
 				  ', DESCRIPCION: ', ERROR_MESSAGE(),
 				  ', LINEA: ', ERROR_LINE())
	RETURN
END CATCH

SET IMPLICIT_TRANSACTIONS ON



-------------------------------------------------------------------------------------------
-- 9. Utilizando la BD JARDINERIA, crea un script que realice lo siguiente:
--		Crea un nuevo cliente (invéntate los datos). No debes indicar directamente el código, 
--			sino buscar cuál le tocaría con una SELECT y guardarlo en una variable.

--		Crea un nuevo pedido para dicho cliente (fechaPedido será la fecha actual, fecha esperada 10 días 
--				después de la fecha de pedido, fecha entrega y comentarios a NULL y estado PENDIENTE)
--			Dicho pedido debe constar de dos productos (los códigos de producto se declaran como variables y se utilizan después)
--			El precio de cada producto debes obtenerlo utilizando SELECT antes de insertarlo en DETALLE_PEDIDOS,
--			de tal manera que, si modificamos los códigos de producto, el script seguirá funcionando.
--			La cantidad de los productos comprados puede ser la que tú quieras.

--		Recuerda que debes utilizar TRANSACCIONES (si fueran necesarias) y TRY/CATCH

--		Reto opcional:
--			Crea también un nuevo pago para dicho cliente cuyo importe coincida con lo que cuesta el pedido completo
--				Puedes indicar directamente el idtransaccion como 'ak-std-000026', aunque es mejor que lo obtengas dinámicante
--				utilizando funciones de SQL Server (piensa que los 6 últimos caracteres son números...)
--				Forma de pago debe ser: 'PayPal' y Fechapago la del día
-------------------------------------------------------------------------------------------
GO
SET IMPLICIT_TRANSACTIONS OFF
DECLARE @codCliente INT, @codPedido INT,
@codProducto1 INT = 1, @precioProducto1 DECIMAL(9,2), @cantidadProducto1 INT = 3,
@codProducto2 INT = 2, @precioProducto2 DECIMAL(9,2), @cantidadProducto2 INT = 2,
@totalPago DECIMAL(9,2),
@idTransaccion CHAR(15)
	
BEGIN TRY

	SELECT @codCliente = MAX(codCliente) + 1
	FROM CLIENTES

	SELECT @codPedido = MAX(codPedido) + 1
	FROM PEDIDOS
	
	SELECT @precioProducto1 = precio_venta
	FROM PRODUCTOS
	WHERE codProducto = @codProducto1

	SELECT @precioProducto2 = precio_venta
	FROM PRODUCTOS
	WHERE codProducto = @codProducto2

	SET @totalPago = @precioProducto1 * @cantidadProducto1 + @precioProducto2 * @cantidadProducto2

	SELECT @idTransaccion = CONCAT(LEFT(MAX(id_transaccion), 7),
							       REPLICATE('0', LEN(RIGHT(MAX(id_transaccion), 8) + 1)),
								   RIGHT(MAX(id_transaccion), 8) + 1)
	  FROM PAGOS

	BEGIN TRAN
	
	INSERT INTO CLIENTES (codCliente, nombre_cliente, nombre_contacto, apellido_contacto, telefono, email, linea_direccion1, linea_direccion2, ciudad, pais, codPostal, codEmpl_Ventas, limite_credito)
	VALUES (@codCliente, 'Jardinero S.A.', 'Juan', 'Perez', '81327493', 'pepelord@gmail.com', 'Av. Rivadavia 1234', 'Esquina Av. Corrientes', 'Buenos Aires', 'Argentina', '1876',  null, 10000)


	INSERT INTO PEDIDOS(codPedido, fecha_pedido, fecha_esperada, fecha_entrega, codEstado, comentarios, codCliente)
	VALUES (@codPedido, GETDATE(), DATEADD(DAY, 10, GETDATE()), NULL, 'P', 'PENDIENTE', @codCliente)

	INSERT INTO DETALLE_PEDIDOS(codPedido, codProducto, cantidad, precio_unidad, numeroLinea)
	VALUES (@codPedido, @codProducto1, @cantidadProducto1, @precioProducto1, 1),
		   (@codPedido, @codProducto2, @cantidadProducto2, @precioProducto2, 2)

	INSERT INTO PAGOS (codCliente, id_transaccion, fechaHora_pago, importe_pago, codFormaPago, codPedido)
	VALUES (@codCliente, @idTransaccion, GETDATE(), @totalPago, 'P', @codPedido)
	
	COMMIT
END TRY

BEGIN CATCH
	ROLLBACK
	PRINT CONCAT ('CODERROR: ', ERROR_NUMBER(),
 				  ', DESCRIPCION: ', ERROR_MESSAGE(),
 				  ', LINEA: ', ERROR_LINE())
	RETURN
END CATCH

SET IMPLICIT_TRANSACTIONS ON



SELECT * FROM PAGOS





-- EXEC sp_help PRODUCTOS