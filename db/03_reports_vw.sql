-- View 1
-- Vista de los productos mas vendidos.
-- Qué devuelve: Los productos ordenados por cantidad vendida con sus métricas de ventas
-- Grain: Una fila representa un producto que ha sido vendido al menos una vez.
-- Métricas Base: Suma de cantidades, suma de subtotales
-- Campos Calculados: Precio promedio de venta por cada unidad.
-- Filtros/Condiciones: HAVING para excluir a los productos que no han sido vendidos.
-- Por qué GROUP BY: Necesitamos agrupar por producto para calcular las ventas totales de cada producto individual
-- Por qué HAVING: Filtra productos sin ninguna venta para mostrar solo productos con movimiento
-- VERIFY:
--   SELECT COUNT(*) FROM mas_vendidos;
--   SELECT * FROM mas_vendidos ORDER BY total_vendido DESC LIMIT 5;

CREATE VIEW mas_vendidos AS
SELECT
    p.id,
    p.nombre,
    c.nombre AS categoria,
    SUM(od.cantidad) AS total_vendido,
    SUM(od.subtotal) AS ingresos_total,
    SUM(od.subtotal) / NULLIF(SUM(od.cantidad), 0) AS precio_promedio
FROM productos p
JOIN orden_detalles od ON od.producto_id = p.id
JOIN categorias c ON c.id = p.categoria_id
GROUP BY p.id, p.nombre, c.nombre
HAVING SUM(od.cantidad) >= 1
ORDER BY total_vendido DESC;

--View 2
-- Vista de los productos más vendidos por categoría.
-- Qué devuelve: Las categorías ordenadas por cantidad total vendida con métricas agregadas
-- Grain: Una fila representa una categoría con al menos una venta
-- Métricas Base: Suma de cantidades (total_vendido), suma de subtotales (ingresos_total)
-- Campos Calculados: Precio promedio de venta por unidad (precio_promedio)
-- Filtros/Condiciones: HAVING para excluir categorías sin ventas
-- Por qué GROUP BY: Agrupamos por categoría para consolidar las ventas de todos los productos de cada categoría
-- Por qué HAVING: Excluye categorías que no tienen productos vendidos
-- VERIFY:
--   SELECT COUNT(*) FROM mas_vendidos_por_categoria;
--   SELECT * FROM mas_vendidos_por_categoria ORDER BY ingresos_total DESC;

CREATE VIEW mas_vendidos_por_categoria AS
SELECT
    c.id, 
    c.nombre, 
    c.descripcion, 
    SUM(od.cantidad) AS total_vendido, 
    SUM(od.subtotal) AS ingresos_total, 
    SUM(od.subtotal) / NULLIF(SUM(od.cantidad), 0) AS precio_promedio
FROM categorias c
JOIN productos p ON p.categoria_id = c.id
JOIN orden_detalles od ON od.producto_id = p.id
GROUP BY c.id, c.nombre, c.descripcion
HAVING SUM(od.cantidad) >= 1
ORDER BY total_vendido DESC;

-- VIEW 3: Segmentación de clientes por gasto
-- Qué devuelve: Clientes clasificados por segmento según su gasto total y comportamiento de compra
-- Grain: Una fila representa un usuario que ha realizado al menos una orden
-- Métricas Base: COUNT de órdenes, SUM de totales
-- Campos Calculados: Gasto promedio por orden, segmentación con CASE
-- Filtros/Condiciones: HAVING para usuarios con al menos 1 orden
-- Por qué GROUP BY: Agrupamos por usuario para calcular métricas de comportamiento y gasto de cada cliente
-- Por qué HAVING: Filtra usuarios sin órdenes para mostrar solo clientes activos
-- VERIFY:
--   SELECT COUNT(*) FROM clientes_segmentacion;
--   SELECT segmento_cliente, COUNT(*) FROM clientes_segmentacion GROUP BY segmento_cliente;

CREATE VIEW clientes_segmentacion AS
SELECT
    u.id,
    u.nombre,
    u.email,
    COUNT(DISTINCT o.id) AS ordenes_totales,
    SUM(o.total) AS gasto_total,
    SUM(o.total) / NULLIF(COUNT(DISTINCT o.id), 0) AS gasto_promedio,
    CASE 
        WHEN SUM(o.total) >= 1000 THEN 'Premium'
        WHEN SUM(o.total) >= 500 THEN 'Regular'
        ELSE 'Básico'
    END AS segmento_cliente
FROM usuarios u
JOIN ordenes o ON o.usuario_id = u.id
GROUP BY u.id, u.nombre, u.email
HAVING COUNT(DISTINCT o.id) >= 1
ORDER BY gasto_total DESC;

-- VIEW 4: Análisis de órdenes con totales globales
-- Qué devuelve: Órdenes con su participación porcentual respecto al total de ventas del sistema
-- Grain: Una fila representa una orden individual
-- Métricas Base: COUNT de items, SUM de subtotales
-- Campos Calculados: Porcentaje de participación respecto al total de ventas
-- Usa: CTE para calcular totales globales
-- Por qué GROUP BY: Agrupamos por orden para contar items y mantener integridad con el CTE
-- VERIFY:
--   SELECT COUNT(*) FROM ordenes_analisis;
--   SELECT estado_legible, COUNT(*) FROM ordenes_analisis GROUP BY estado_legible;

CREATE VIEW ordenes_analisis AS
WITH totales_sistema AS (
    SELECT 
        SUM(total) AS ventas_totales
    FROM ordenes
)
SELECT
    o.id AS orden_id,
    u.nombre AS cliente_nombre,
    o.status,
    COUNT(od.id) AS items_count,
    o.total AS total_orden,
    ROUND((o.total / NULLIF(ts.ventas_totales, 0)) * 100, 2) AS porcentaje_ventas,
    CASE 
        WHEN o.status = 'entregado' THEN 'Completada'
        WHEN o.status IN ('pagado', 'enviado') THEN 'En proceso'
        WHEN o.status = 'pendiente' THEN 'Pendiente'
        ELSE 'Cancelada'
    END AS estado_legible
FROM ordenes o
JOIN usuarios u ON u.id = o.usuario_id
LEFT JOIN orden_detalles od ON od.orden_id = o.id
CROSS JOIN totales_sistema ts
GROUP BY o.id, u.nombre, o.status, o.total, ts.ventas_totales
ORDER BY o.total DESC;

-- VIEW 5: Ranking de productos por ventas usando Window Functions
-- Qué devuelve: Productos rankeados por ventas con posición y porcentaje acumulado de ingresos
-- Grain: Una fila representa un producto con información de ranking
-- Métricas Base: SUM de cantidades vendidas
-- Campos Calculados: ROW_NUMBER para ranking, porcentaje acumulado
-- Usa: Window Functions (ROW_NUMBER, SUM OVER)
-- Por qué GROUP BY: Agrupamos por producto antes de aplicar las window functions para calcular totales
-- VERIFY:
--   SELECT COUNT(*) FROM productos_ranking;
--   SELECT * FROM productos_ranking WHERE ranking_ventas <= 10;

CREATE VIEW productos_ranking AS
SELECT
    p.id,
    p.nombre,
    c.nombre AS categoria,
    SUM(od.cantidad) AS total_vendido,
    SUM(od.subtotal) AS ingresos_total,
    ROW_NUMBER() OVER (ORDER BY SUM(od.cantidad) DESC) AS ranking_ventas,
    ROUND(
        SUM(SUM(od.subtotal)) OVER (ORDER BY SUM(od.cantidad) DESC) / 
        NULLIF(SUM(SUM(od.subtotal)) OVER (), 0) * 100, 
        2
    ) AS porcentaje_acumulado
FROM productos p
JOIN orden_detalles od ON od.producto_id = p.id
JOIN categorias c ON c.id = p.categoria_id
GROUP BY p.id, p.nombre, c.nombre
ORDER BY ranking_ventas;