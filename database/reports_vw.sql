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