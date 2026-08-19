USE FinDataChile;
GO

-- =============================================
-- FinDataChile
-- Etapa 4: Análisis SQL
-- =============================================

-- =============================================
-- 1. Indicadores generales
-- =============================================

SELECT
    COUNT(*) AS total_operaciones,
    COUNT(DISTINCT id_cliente) AS clientes_con_operaciones,
    SUM(monto) AS monto_total,
    AVG(monto) AS monto_promedio,
    MIN(monto) AS monto_minimo,
    MAX(monto) AS monto_maximo
FROM Operaciones;

-- =============================================
-- 2. Operaciones por tipo
-- =============================================

SELECT
    t.nombre AS tipo_operacion,
    COUNT(*) AS cantidad_operaciones,
    SUM(o.monto) AS monto_total,
    AVG(o.monto) AS monto_promedio
FROM Operaciones o
INNER JOIN TiposOperacion t
    ON o.id_tipo_operacion = t.id_tipo_operacion
GROUP BY
    t.nombre
ORDER BY
    monto_total DESC;

-- =============================================
-- 3. Operaciones por estado
-- =============================================

SELECT
    e.descripcion AS estado,
    COUNT(*) AS cantidad_operaciones,
    SUM(o.monto) AS monto_total,
    AVG(o.monto) AS monto_promedio
FROM Operaciones o
INNER JOIN EstadosOperacion e
    ON o.id_estado = e.id_estado
GROUP BY
    e.descripcion
ORDER BY
    cantidad_operaciones DESC;

-- =============================================
-- 4. Evolución anual
-- =============================================

SELECT
    YEAR(fecha_operacion) AS anio,
    COUNT(*) AS cantidad_operaciones,
    SUM(monto) AS monto_total,
    AVG(monto) AS monto_promedio
FROM Operaciones
GROUP BY
    YEAR(fecha_operacion)
ORDER BY
    anio;

-- =============================================
-- 5. Evolución mensual
-- =============================================

SELECT
    YEAR(fecha_operacion) AS anio,
    MONTH(fecha_operacion) AS mes,
    COUNT(*) AS cantidad_operaciones,
    SUM(monto) AS monto_total
FROM Operaciones
GROUP BY
    YEAR(fecha_operacion),
    MONTH(fecha_operacion)
ORDER BY
    anio,
    mes;

-- =============================================
-- 6. Top 10 clientes por monto
-- =============================================

SELECT TOP 10
    c.id_cliente,
    c.nombre,
    c.apellido_paterno,
    c.apellido_materno,
    COUNT(o.id_operacion) AS cantidad_operaciones,
    SUM(o.monto) AS monto_total,
    AVG(o.monto) AS monto_promedio
FROM Clientes c
INNER JOIN Operaciones o
    ON c.id_cliente = o.id_cliente
GROUP BY
    c.id_cliente,
    c.nombre,
    c.apellido_paterno,
    c.apellido_materno
ORDER BY
    monto_total DESC;

-- =============================================
-- 7. Porcentaje de operaciones por tipo
-- =============================================

SELECT
    t.nombre AS tipo_operacion,
    COUNT(*) AS cantidad_operaciones,
    CAST(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER ()
        AS DECIMAL(5,2)
    ) AS porcentaje_operaciones
FROM Operaciones o
INNER JOIN TiposOperacion t
    ON o.id_tipo_operacion = t.id_tipo_operacion
GROUP BY
    t.nombre
ORDER BY
    porcentaje_operaciones DESC;

-- =============================================
-- 8. Ranking de clientes por monto
-- =============================================

SELECT
    c.id_cliente,
    c.nombre,
    c.apellido_paterno,
    c.apellido_materno,
    COUNT(o.id_operacion) AS cantidad_operaciones,
    SUM(o.monto) AS monto_total,
    RANK() OVER (
        ORDER BY SUM(o.monto) DESC
    ) AS ranking
FROM Clientes c
INNER JOIN Operaciones o
    ON c.id_cliente = o.id_cliente
GROUP BY
    c.id_cliente,
    c.nombre,
    c.apellido_paterno,
    c.apellido_materno
ORDER BY
    ranking;

-- =============================================
-- 9. CTE - Clientes de alto movimiento
-- =============================================

WITH ClientesResumen AS (
    SELECT
        c.id_cliente,
        c.nombre,
        c.apellido_paterno,
        c.apellido_materno,
        COUNT(o.id_operacion) AS cantidad_operaciones,
        SUM(o.monto) AS monto_total
    FROM Clientes c
    INNER JOIN Operaciones o
        ON c.id_cliente = o.id_cliente
    GROUP BY
        c.id_cliente,
        c.nombre,
        c.apellido_paterno,
        c.apellido_materno
)
SELECT
    *,
    CASE
        WHEN monto_total >= 10000000 THEN 'Alto'
        WHEN monto_total >= 5000000 THEN 'Medio'
        ELSE 'Bajo'
    END AS segmento_cliente
FROM ClientesResumen
ORDER BY
    monto_total DESC;