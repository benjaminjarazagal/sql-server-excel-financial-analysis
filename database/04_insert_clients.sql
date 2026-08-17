USE FinDataChile;
GO

DROP TABLE IF EXISTS #Nombres;
DROP TABLE IF EXISTS #ApellidosPaternos;
DROP TABLE IF EXISTS #ApellidosMaternos;
GO


-- =============================================
-- 1. Lista de nombres
-- =============================================

CREATE TABLE #Nombres (
    id INT IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL
);

INSERT INTO #Nombres (nombre)
VALUES
    ('Juan'),
    ('Pedro'),
    ('Diego'),
    ('Carlos'),
    ('Luis'),
    ('Benjamín'),
    ('Matías'),
    ('Felipe'),
    ('Sebastián'),
    ('Andrés'),
    ('Nicolás'),
    ('Javier'),
    ('Cristóbal'),
    ('Tomás'),
    ('Ignacio'),
    ('Francisco'),
    ('María'),
    ('Camila'),
    ('Sofía'),
    ('Valentina'),
    ('Fernanda'),
    ('Daniela'),
    ('Carolina'),
    ('Javiera'),
    ('Catalina'),
    ('Antonia'),
    ('Isidora'),
    ('Martina'),
    ('Constanza'),
    ('Gabriela');


-- =============================================
-- 2. Lista de apellidos paternos
-- =============================================

CREATE TABLE #ApellidosPaternos (
    id INT IDENTITY(1,1),
    apellido VARCHAR(50) NOT NULL
);

INSERT INTO #ApellidosPaternos (apellido)
VALUES
    ('González'),
    ('Muñoz'),
    ('Rojas'),
    ('Díaz'),
    ('Pérez'),
    ('Soto'),
    ('Contreras'),
    ('Silva'),
    ('Martínez'),
    ('Sepúlveda'),
    ('Morales'),
    ('Rodríguez'),
    ('López'),
    ('Fuentes'),
    ('Hernández'),
    ('Torres'),
    ('Araya'),
    ('Flores'),
    ('Espinoza'),
    ('Valdés'),
    ('Ramírez'),
    ('Vega'),
    ('Castillo'),
    ('Cortés'),
    ('Jara'),
    ('Reyes'),
    ('Gutiérrez'),
    ('Núñez'),
    ('Vargas'),
    ('Pino');


-- =============================================
-- 3. Lista de apellidos maternos
-- =============================================

CREATE TABLE #ApellidosMaternos (
    id INT IDENTITY(1,1),
    apellido VARCHAR(50) NOT NULL
);

INSERT INTO #ApellidosMaternos (apellido)
VALUES
    ('González'),
    ('Muñoz'),
    ('Rojas'),
    ('Díaz'),
    ('Pérez'),
    ('Soto'),
    ('Contreras'),
    ('Silva'),
    ('Martínez'),
    ('Sepúlveda'),
    ('Morales'),
    ('Rodríguez'),
    ('López'),
    ('Fuentes'),
    ('Hernández'),
    ('Torres'),
    ('Araya'),
    ('Flores'),
    ('Espinoza'),
    ('Valdés'),
    ('Ramírez'),
    ('Vega'),
    ('Castillo'),
    ('Cortés'),
    ('Jara'),
    ('Reyes'),
    ('Gutiérrez'),
    ('Núñez'),
    ('Vargas'),
    ('Pino');


-- =============================================
-- 4. Generación de 1.000 clientes
-- =============================================

IF NOT EXISTS (SELECT 1 FROM Clientes)
BEGIN

    WITH Numeros AS (
        SELECT TOP 1000
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS numero
        FROM sys.all_objects a
        CROSS JOIN sys.all_objects b
    )

    INSERT INTO Clientes (
        rut,
        dv,
        nombre,
        apellido_paterno,
        apellido_materno,
        fecha_nacimiento,
        id_region,
        id_estado,
        fecha_registro
    )

    SELECT

        -- =========================================
        -- RUT
        -- =========================================

        CAST(10000000 + num.numero AS VARCHAR(8)) AS rut,


        -- =========================================
        -- Dígito verificador
        -- =========================================

        dbo.fn_CalcularDV(
            CAST(10000000 + num.numero AS VARCHAR(8))
        ) AS dv,


        -- =========================================
        -- Nombre
        -- Se utilizan los 30 nombres disponibles
        -- de forma cíclica.
        -- =========================================

        n.nombre,


        -- =========================================
        -- Apellido paterno
        -- =========================================

        ap.apellido,


        -- =========================================
        -- Apellido materno
        -- =========================================

        am.apellido,


        -- =========================================
        -- Fecha de nacimiento
        -- Edad aproximada entre 18 y 80 años
        -- =========================================

        DATEADD(
            DAY,
            -(
                18 * 365
                + ABS(CHECKSUM(NEWID())) % (62 * 365)
            ),
            CAST('2026-08-16' AS DATE)
        ) AS fecha_nacimiento,


        -- =========================================
        -- Región aleatoria entre 1 y 16
        -- =========================================

        1 + ABS(CHECKSUM(NEWID())) % 16 AS id_region,


        -- =========================================
        -- Estado
        -- 90% Activo
        -- 10% Inactivo
        -- =========================================

        CASE
            WHEN ABS(CHECKSUM(NEWID())) % 10 < 9
                THEN 1
            ELSE 2
        END AS id_estado,


        -- =========================================
        -- Fecha de registro
        -- Últimos 3000 días aproximadamente
        -- =========================================

        DATEADD(
            DAY,
            -ABS(CHECKSUM(NEWID())) % 3000,
            CAST('2026-08-16' AS DATE)
        ) AS fecha_registro


    FROM Numeros num


    -- =============================================
    -- Relacionamos cada número con un nombre.
    --
    -- 1 -> nombre 1
    -- 2 -> nombre 2
    -- ...
    -- 30 -> nombre 30
    -- 31 -> nombre 1
    -- =============================================

    INNER JOIN #Nombres n
        ON n.id = ((num.numero - 1) % 30) + 1


    -- =============================================
    -- Apellido paterno
    -- =============================================

    INNER JOIN #ApellidosPaternos ap
        ON ap.id = ((num.numero - 1) % 30) + 1


    -- =============================================
    -- Apellido materno
    -- =============================================

    INNER JOIN #ApellidosMaternos am
        ON am.id = ((num.numero - 1) % 30) + 1;

END

ELSE

BEGIN

    PRINT 'La tabla Clientes ya contiene datos. No se insertaron nuevos registros.';

END;
GO