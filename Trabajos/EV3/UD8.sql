

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

DECLARE @nombre VARCHAR(100)
DECLARE @codFabricante INT
DECLARE @result INT

EXEC @result = crearFabricante @nombre, @codFabricante OUTPUT

IF @result <> 0 
BEGIN
    PRINT 'La función "crearFabricante" no ha podido ser completada'
    RETURN
END