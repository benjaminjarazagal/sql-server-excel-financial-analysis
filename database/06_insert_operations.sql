USE FinDataChile;
GO

-- =============================================
-- Generación de operaciones ficticias
-- Lote de 1.000 registros
-- =============================================

INSERT INTO Operaciones (
    id_cliente,
    id_tipo_operacion,
    id_estado,
    fecha_operacion,
    monto
)
SELECT TOP 1000

    -- =========================================
    -- Cliente existente aleatorio
    -- =========================================

    c.id_cliente,

    -- =========================================
    -- Tipo de operación
    -- =========================================

    CASE
        WHEN ABS(CHECKSUM(NEWID())) % 100 < 70 THEN 1
        WHEN ABS(CHECKSUM(NEWID())) % 100 < 80 THEN 2
        WHEN ABS(CHECKSUM(NEWID())) % 100 < 90 THEN 3
        WHEN ABS(CHECKSUM(NEWID())) % 100 < 95 THEN 4
        ELSE 5
    END AS id_tipo_operacion,

    -- =========================================
    -- Estado
    -- =========================================

    CASE
        WHEN ABS(CHECKSUM(NEWID())) % 100 < 85 THEN 2
        WHEN ABS(CHECKSUM(NEWID())) % 100 < 95 THEN 1
        ELSE 3
    END AS id_estado,

    -- =========================================
    -- Fecha aleatoria
    -- =========================================

    DATEADD(
        DAY,
        ABS(CHECKSUM(NEWID())) % DATEDIFF(
            DAY,
            '2022-01-01',
            '2026-08-16'
        ),
        '2022-01-01'
    ) AS fecha_operacion,

    -- =========================================
    -- Monto aleatorio
    -- =========================================

    CAST(
        50000
        + ABS(CHECKSUM(NEWID())) % 2950001
        AS DECIMAL(15,2)
    ) AS monto

FROM Clientes c
CROSS JOIN (
    SELECT TOP 1000
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS numero
    FROM sys.columns
) n

ORDER BY NEWID();
GO