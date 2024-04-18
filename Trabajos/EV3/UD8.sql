CREATE OR ALTER PROCEDURE crearFabricante(@nombre VARCHAR(100),
                                          @codFab INT OUTPUT)
AS
BEGIN
    BEGIN TRY
    IF @nombre IS NULL
    BEGIN
        PRINT 'El nombre no puede ser nulo'
        RETURN -1
    END

    INSERT INTO FABRICANTE
    VALUES (@nombre)
    SET @codFab = SCOPE_IDENTITY()

    END TRY
    BEGIN CATCH
        PRINT CONCAT ('CODERROR: ', ERROR_NUMBER(),
 				', DESCRIPCION: ', ERROR_MESSAGE(),
 				', LINEA: ', ERROR_LINE())
    END CATCH

END

GO

DECLARE @nombre VARCHAR(100) = 'Pepe'
DECLARE @codFabricante INT
DECLARE @result INT

EXEC @result = crearFabricante @nombre, @codFabricante OUTPUT

IF @result <> 0 
BEGIN
    PRINT 'La función "crearFabricante" no ha podido ser completada'
    RETURN
END


GO

CREATE OR ALTER PROCEDURE devolverFabricante (@codFab INT,
                                              @nombre VARCHAR(100) OUTPUT)
AS
BEGIN
    BEGIN TRY
    IF @codFab IS NULL OR @codFab <= 0
    BEGIN
        PRINT 'El codFabricante no puede ser nulo'
        RETURN -1
    END

    SELECT @nombre = nombre
      FROM FABRICANTE
     WHERE codigo = @codFab

    IF @nombre IS NULL
    BEGIN
        PRINT 'El fabricante indicado no existe'
        RETURN -2
    END
    END TRY

    BEGIN CATCH
        PRINT CONCAT ('CODERROR: ', ERROR_NUMBER(),
 				', DESCRIPCION: ', ERROR_MESSAGE(),
 				', LINEA: ', ERROR_LINE())
    END CATCH
END


-----------------------
GO

DECLARE @nombre VARCHAR(100)
DECLARE @codFab INT = 3
DECLARE @result INT

EXEC @result = devolverFabricante @codFab, @nombre OUTPUT

IF @result <> 0 
BEGIN
    PRINT 'La función "crearFabricante" no ha podido ser completada'
    RETURN
END
ELSE BEGIN
    PRINT CONCAT('El nombre es ', @nombre)
END
