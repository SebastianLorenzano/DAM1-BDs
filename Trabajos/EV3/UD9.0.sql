USE TECHNICIAN_SERVICE       







CREATE DATABASE BIBLIOTECA
GO
USE BIBLIOTECA
GO
CREATE TABLE LIBROS (
    ISBN        CHAR(13),
    titulo      VARCHAR(100) NOT NULL,
    precio      DECIMAL (7,2) NOT NULL

    CONSTRAINT PK_LIBROS PRIMARY KEY (ISBN)
)

CREATE TABLE SOCIOS (
    DNI         CHAR(10),
    nombre      VARCHAR(100) NOT NULL,
    ciudad      VARCHAR(100) NOT NULL

    CONSTRAINT PK_SOCIOS PRIMARY KEY (DNI)
)

CREATE TABLE PRESTAMOS (
    idPrestamo      INT IDENTITY,
    fechaPrestamo   DATE NOT NULL,
    fechaDevol      DATE,
    ISBN            CHAR(13) NOT NULL,
    DNI             CHAR(10) NOT NULL
    

    CONSTRAINT PK_PRESTAMOS PRIMARY KEY (idPrestamo),
    CONSTRAINT FK_PRESTAMOS_LIBROS FOREIGN KEY (ISBN) REFERENCES LIBROS(ISBN),
    CONSTRAINT FK_PRESTAMOS_SOCIOS FOREIGN KEY (DNI) REFERENCES SOCIOS(DNI)
)

GO

CREATE TABLE LIBROS_PERDIDOS (
    ISBN        CHAR(13),
    DNI         CHAR(10),
    nombre      VARCHAR(100),
    fechaBaja   DATE

    CONSTRAINT PK_LIBROS_PERDIDOS PRIMARY KEY (ISBN, DNI)
)

GO

CREATE OR ALTER TRIGGER TX_SOCIOS_DELETE ON SOCIOS      
AFTER DELETE                                      
AS  
BEGIN
    SET XACT_ABORT ON                -- It ensures that transactional integrity is mantained,
    INSERT INTO LIBROS_PERDIDOS         --  even if an explicit transaction was started outside of the trigger or not.
    SELECT p.ISBN, d.DNI, d.nombre, GETDATE()
      FROM deleted d,
           PRESTAMOS p
        WHERE d.DNI = p.DNI 
            AND p.fechaDevol IS NULL
        DELETE FROM PRESTAMOS
        WHERE DNI IN (SELECT DNI FROM deleted)
        DELETE FROM SOCIOS
        WHERE DNI IN (SELECT DNI FROM deleted)
END
GO
USE master
DROP DATABASE TECHNICIAN_SERVICE
CREATE DATABASE TECHNICIAN_SERVICE
GO
USE TECHNICIAN_SERVICE
GO

CREATE TABLE TECHNICIANS (
    DNI         CHAR(10),
    name        VARCHAR(100) NOT NULL,
    city        VARCHAR(100) NOT NULL,
    salary      DECIMAL(9,2) NOT NULL

    CONSTRAINT PK_TECHNICIAN PRIMARY KEY (DNI)
)

CREATE TABLE HIST_TECHNICIANS (
    DNI         CHAR(10),
    name        VARCHAR(100) NOT NULL,
    city        VARCHAR(100) NOT NULL,
    salary      DECIMAL(9,2) NOT NULL,
    fechaBaja   DATE NOT NULL,

    CONSTRAINT PK_HIST_TECHNICIAN PRIMARY KEY (DNI)
)

CREATE TABLE REPAIRS (
    idRepair        INT IDENTITY,
    dateRepair      DATE NOT NULL,
    concept         VARCHAR(200),
    amount          DECIMAL(9,2) NOT NULL,
    DNI_technician  CHAR(10) NOT NULL

    CONSTRAINT PK_REPAIRS PRIMARY KEY (idRepair),
    CONSTRAINT FK_REPAIRS_TECHNICIAN FOREIGN KEY (DNI_technician) REFERENCES TECHNICIANS (DNI)            
)

GO
CREATE OR ALTER TRIGGER TX_TECHNICIAN_DELETE ON TECHNICIANS      
INSTEAD OF DELETE                                      
AS  
BEGIN
DECLARE @amount INT = 2500
    SET XACT_ABORT ON      
        INSERT INTO HIST_TECHNICIANS
        SELECT DELETED.*,
               GETDATE()
          FROM DELETED
         WHERE DNI IN (SELECT DNI_technician
                         FROM REPAIRS
                        GROUP BY DNI_technician
                       HAVING SUM(amount) > @amount)
        UPDATE REPAIRS
        SET DNI_technician = NULL
        WHERE DNI_technician IN (SELECT DNI from deleted)
        DELETE FROM TECHNICIANS
        WHERE DNI IN (SELECT DNI FROM deleted)
END
GO
-- CHECK TRIGGER 

-- EXERCISE3

GO
CREATE DATABASE SUPPLIERS
GO
USE SUPPLIERS
GO

CREATE TABLE WAREHOUSE (
    codWarehouse        INT IDENTITY,
    description         VARCHAR(200),
    adress              VARCHAR(200),
    city                VARCHAR(100)

    CONSTRAINT PK_WAREHOUSE PRIMARY KEY (codWarehouse)
)

CREATE TABLE SUPPLIERS
 (
    codSupplier        INT IDENTITY,
    name                VARCHAR(200),
    adress              VARCHAR(200),
    city                VARCHAR(100)

    CONSTRAINT PK_SUPPLIER PRIMARY KEY (codSupplier)
)

CREATE TABLE PRODUCT (
    codProduct          INT IDENTITY,
    name                VARCHAR(200),
    stock               INT,
    price               DECIMAL(9,2),
    codWarehouse        INT,
    codSupplier         INT
    
    CONSTRAINT PK_PRODUCT PRIMARY KEY (codProduct),
    CONSTRAINT FK_PRODUCT_WAREHOUSE FOREIGN KEY (codWarehouse) REFERENCES WAREHOUSE(codWarehouse),
    CONSTRAINT FK_PRODUCT_SUPPLIERS FOREIGN KEY (codSupplier) REFERENCES SUPPLIERS(codSupplier)

)

GO

-- TODO: TRIGGER

