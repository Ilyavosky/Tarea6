CREATE VIEW mas_vendidos AS
SELECT p.nombre, SUM(od.cantidad) AS total_vendido
FROM productos, orden_detalles
HAVING p.id, od.producto_id
GROUP BY p.cantidad
ORDER BY total_vendido DESC;