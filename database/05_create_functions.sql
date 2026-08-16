USE FinDataChile;
GO

CREATE FUNCTION fn_CalcularDV
(
    @rut VARCHAR(8)
)
RETURNS CHAR(1)
AS
BEGIN

    DECLARE @suma INT = 0;
    DECLARE @multiplicador INT = 2;
    DECLARE @i INT = LEN(@rut);
    DECLARE @digito INT;
    DECLARE @resto INT;
    DECLARE @resultado CHAR(1);

    WHILE @i > 0
    BEGIN

        SET @digito = CAST(SUBSTRING(@rut, @i, 1) AS INT);

        SET @suma = @suma + (@digito * @multiplicador);

        SET @multiplicador = @multiplicador + 1;

        IF @multiplicador > 7
            SET @multiplicador = 2;

        SET @i = @i - 1;

    END;

    SET @resto = @suma % 11;

    SET @resto = 11 - @resto;

    SET @resultado =
        CASE
            WHEN @resto = 11 THEN '0'
            WHEN @resto = 10 THEN 'K'
            ELSE CAST(@resto AS CHAR(1))
        END;

    RETURN @resultado;

END;
GO