CREATE DATABASE EVALUACION
USE EVALUACION

CREATE TABLE CUSTOMERS (
    DNI             CHAR(10),
    name            VARCHAR(100) NOT NULL,
    surname1        VARCHAR(100) NOT NULL,
    surname2        VARCHAR(100),
    address         VARCHAR(200) NOT NULL,
    city            VARCHAR(100) NOT NULL,
    postalCode      CHAR(5)      NOT NULL,
    mobilePhone     CHAR(9)
    
CONSTRAINT PK_CUSTOMERS PRIMARY KEY (DNI),
CONSTRAINT CK_CUSTOMERS_MOBILEPHONE CHECK(LEFT(mobilePhone, 1) IN (6, 7))
)

CREATE TABLE VIDEOGAMES (
    idVideogame     INT IDENTITY(1,1),
    type            CHAR(1) NOT NULL,
    company         VARCHAR(200) NOT NULL,
    description     VARCHAR(300) DEFAULT '-',
    price           DECIMAL(5, 2) NOT NULL,
    releaseDate     DATE
    
CONSTRAINT PK_VIDEOGAMES PRIMARY KEY (idVideogame),
CONSTRAINT CK_VIDEOGAMES_PRICE CHECK(price <= 200.00)
)

CREATE TABLE RESERVATIONS (
    codReservation      INT IDENTITY(1, 1),
    reservationDate     DATE NOT NULL,
    commentary          VARCHAR(70),
    price               DECIMAL(4, 2),
    DNI_customer        CHAR(10) NOT NULL,
    idVideogame         INT NOT NULL

CONSTRAINT PK_RESERVATIONS PRIMARY KEY (codReservation),
CONSTRAINT FK_RESERVATIONS_CUSTOMERS FOREIGN KEY (DNI_customer) REFERENCES CUSTOMERS(DNI),
CONSTRAINT FK_RESERVATIONS_VIDEOGAMES FOREIGN KEY (idVideogame) REFERENCES VIDEOGAMES(idVideogame)
)




CREATE INDEX IX_CUSTOMERS
    ON CUSTOMERS(name)

DROP INDEX IX_CUSTOMERS
    ON CUSTOMERS


INSERT INTO VIDEOGAMES(type, company, description, price, releaseDate)
VALUES ('N', 'Epic Games', 'Epic Game 2024', 79.99, GETDATE())



UPDATE VIDEOGAMES
   SET price = 59.99
 WHERE company IN ('Konami', 'Nintendo')
   AND type NOT IN ('R', 'N')


DELETE FROM VIDEOGAMES
 WHERE releaseDate IS NULL


INSERT INTO CUSTOMERS (DNI, name, surname1, surname2, address, city, postalCode, mobilePhone)
VALUES ('Z0914835Z', 'Pepe', 'Martinez', 'Martinez', '9 de Julio 153 2A', 'Buenos Aires', '1876', '631078461')

UPDATE CUSTOMERS
   SET city = 'Alicante'
 WHERE DNI = ANY  (SELECT r.DNI_customer
                     FROM RESERVATIONS r
                    GROUP BY r.DNI_customer
                   HAVING COUNT(codReservation) = 2 
    )


DELETE FROM CUSTOMERS
 WHERE DNI LIKE '%_5%C'

USE JARDINERIA


SELECT c.nombre_cliente, 
       CONCAT(e.nombre, ' ',e.apellido1, ' ', apellido2)
  FROM CLIENTES c,
       EMPLEADOS e
 WHERE c.codEmpl_ventas = e.codEmpleado



SELECT TOP(1) nombre, p.cantidad_en_stock
  FROM PRODUCTOS p
 WHERE codCategoria = 'OR'
 ORDER BY p.cantidad_en_stock ASC


SELECT DISTINCT c.*
  FROM CLIENTES c, PAGOS p 
 WHERE c.codCliente = p.codCliente
   AND p.importe_pago >= 100
   AND c.codCliente IN (SELECT codCliente
                          FROM PEDIDOS
                         WHERE MONTH(fecha_pedido) = 8
                         GROUP BY codCliente
                        HAVING COUNT(codPedido) >= 2)


SELECT c.nombre, COUNT(p.codProducto) cantProds
  FROM CATEGORIA_PRODUCTOS c LEFT JOIN PRODUCTOS p
    ON c.codCategoria = p.codCategoria
 GROUP BY c.codCategoria, c.nombre 




SELECT c.nombre, COUNT(p.codProducto) cantProds
  FROM CATEGORIA_PRODUCTOS c,
       PRODUCTOS p
 WHERE c.codCategoria = p.codCategoria 
   AND c.nombre <> 'Herramientas'
 GROUP BY c.codCategoria, c.nombre
HAVING COUNT(p.codProducto) >= (SELECT COUNT(p.codProducto)
                                  FROM CATEGORIA_PRODUCTOS c,
                                       PRODUCTOS p
                                 WHERE c.codCategoria = p.codCategoria 
                                   AND c.nombre = 'Herramientas')




