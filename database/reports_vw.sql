-- View 1
-- Vista de los productos mas vendidos.
-- Grain: Una fila representa un producto que ha sido vendido al menos una vez.
-- Métricas Base: Suma de cantidades, suma de subtotales y precio promedio.
-- Campos Calculados: Precio promedio de venta por cada unidad.
-- Filtros/Condiciones: Having par excluir a los productos que no han sido vendidos.

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
ORDER BY total_vendido DESC

--View 2
-- Vista de los productos más vendidos por categoría.
-- Grain: Una fila representa una categoría con al menos una venta
-- Métricas Base: Suma de cantidades (total_vendido), suma de subtotales (ingresos_total)
-- Campos Calculados: Precio promedio de venta por unidad (precio_promedio)
-- Filtros/Condiciones: HAVING para excluir categorías sin ventas
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
-- Grain: Una fila representa un usuario que ha realizado al menos una orden
-- Métricas Base: COUNT de órdenes, SUM de totales
-- Campos Calculados: Gasto promedio por orden, segmentación con CASE
-- Filtros/Condiciones: HAVING para usuarios con al menos 1 orden

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