-- ÍNDICE 1: idx_orden_detalles_producto_id
-- Tabla: orden_detalles
-- Columna: producto_id

-- JUSTIFICACIÓN:
-- Este índice optimiza los JOINs entre orden_detalles y productos, se usa en las vistas:
-- mas_vendidos (View 1)
-- mas_vendidos_por_categoria (View 2)
-- productos_ranking (View 5)

-- Qué hace:
-- Reduce tiempo de ejecución en vistas con JOIN productos-orden_detalles
-- Especialmente importante cuando la tabla orden_detalles crece

CREATE INDEX idx_orden_detalles_producto_id ON orden_detalles(producto_id);

-- Verify:
-- EXPLAIN ANALYZE
-- SELECT p.nombre, SUM(od.cantidad) AS total
-- FROM productos p
-- JOIN orden_detalles od ON od.producto_id = p.id
-- GROUP BY p.nombre;


-- ÍNDICE 2: idx_orden_detalles_orden_id
-- Tabla: orden_detalles
-- Columna: orden_id

-- JUSTIFICACIÓN:
-- Este índice optimiza el JOIN entre ordenes y orden_detalles,
-- usado en la vista:
-- ordenes_analisis (View 4)


CREATE INDEX idx_orden_detalles_orden_id ON orden_detalles(orden_id);

-- Verify:
-- EXPLAIN ANALYZE
-- SELECT o.id, COUNT(od.id) AS items_count
-- FROM ordenes o
-- LEFT JOIN orden_detalles od ON od.orden_id = o.id
-- GROUP BY o.id;


-- ÍNDICE 3: idx_ordenes_created_at
-- Tabla: ordenes
-- Columna: created_at

-- JUSTIFICACIÓN:
-- Este índice optimiza filtros y ordenamientos por fecha de las ordenes.



CREATE INDEX idx_ordenes_created_at ON ordenes(created_at);

-- Verify:
-- EXPLAIN ANALYZE
-- SELECT *
-- FROM ordenes
-- WHERE created_at >= '2024-01-01'
-- ORDER BY created_at DESC;
