-- ============================================
-- SEED.SQL - Datos Iniciales (Versión Expandida)
-- ============================================
-- Alumno: Ilya Cortés Ruiz
-- Matricula: 243710
-- Fecha: 11/02/2026
-- ============================================
-- ORDEN DE INSERCIÓN:
-- 1. Catálogos (sin dependencias)
-- 2. Entidades principales
-- 3. Relaciones/transacciones
-- ============================================

-- ============================================
-- 1. CATÁLOGOS
-- ============================================

INSERT INTO categorias (nombre, descripcion) VALUES
    ('Electrónica', 'Dispositivos electrónicos y accesorios'),
    ('Ropa', 'Vestimenta y accesorios de moda'),
    ('Hogar', 'Artículos para el hogar y decoración'),
    ('Deportes', 'Equipamiento y ropa deportiva'),
    ('Libros', 'Libros físicos y digitales'),
    ('Alimentos', 'Productos alimenticios'),
    ('Juguetes', 'Juguetes y entretenimiento'),
    ('Belleza', 'Productos de cuidado personal');

-- ============================================
-- 2. ENTIDADES PRINCIPALES
-- ============================================

-- Usuarios (20 usuarios para tener variedad en segmentación)
INSERT INTO usuarios (email, nombre, password_hash) VALUES
    ('ada@example.com', 'Ada Lovelace', 'hash_placeholder_1'),
    ('alan@example.com', 'Alan Turing', 'hash_placeholder_2'),
    ('grace@example.com', 'Grace Hopper', 'hash_placeholder_3'),
    ('linus@example.com', 'Linus Torvalds', 'hash_placeholder_4'),
    ('margaret@example.com', 'Margaret Hamilton', 'hash_placeholder_5'),
    ('donald@example.com', 'Donald Knuth', 'hash_placeholder_6'),
    ('barbara@example.com', 'Barbara Liskov', 'hash_placeholder_7'),
    ('frances@example.com', 'Frances Allen', 'hash_placeholder_8'),
    ('john@example.com', 'John McCarthy', 'hash_placeholder_9'),
    ('edsger@example.com', 'Edsger Dijkstra', 'hash_placeholder_10'),
    ('dennis@example.com', 'Dennis Ritchie', 'hash_placeholder_11'),
    ('ken@example.com', 'Ken Thompson', 'hash_placeholder_12'),
    ('bjarne@example.com', 'Bjarne Stroustrup', 'hash_placeholder_13'),
    ('guido@example.com', 'Guido van Rossum', 'hash_placeholder_14'),
    ('james@example.com', 'James Gosling', 'hash_placeholder_15'),
    ('tim@example.com', 'Tim Berners-Lee', 'hash_placeholder_16'),
    ('larry@example.com', 'Larry Page', 'hash_placeholder_17'),
    ('sergey@example.com', 'Sergey Brin', 'hash_placeholder_18'),
    ('mark@example.com', 'Mark Zuckerberg', 'hash_placeholder_19'),
    ('jeff@example.com', 'Jeff Bezos', 'hash_placeholder_20');

-- Productos (40+ productos distribuidos en categorías)
INSERT INTO productos (codigo, nombre, descripcion, precio, stock, categoria_id) VALUES
    -- Electrónica (categoria_id = 1) - 8 productos
    ('ELEC-001', 'Laptop Pro 15"', 'Laptop de alto rendimiento', 1299.99, 50, 1),
    ('ELEC-002', 'Mouse Inalámbrico', 'Mouse ergonómico Bluetooth', 29.99, 200, 1),
    ('ELEC-003', 'Teclado Mecánico', 'Teclado RGB switches azules', 89.99, 75, 1),
    ('ELEC-004', 'Monitor 27"', 'Monitor 4K IPS', 399.99, 30, 1),
    ('ELEC-005', 'Webcam HD', 'Cámara 1080p con micrófono', 59.99, 100, 1),
    ('ELEC-006', 'Auriculares Gaming', 'Auriculares con cancelación de ruido', 149.99, 80, 1),
    ('ELEC-007', 'Tablet 10"', 'Tablet con stylus incluido', 349.99, 45, 1),
    ('ELEC-008', 'Disco Duro Externo 2TB', 'Almacenamiento portátil', 79.99, 120, 1),
    
    -- Ropa (categoria_id = 2) - 8 productos
    ('ROPA-001', 'Camiseta Básica', 'Camiseta 100% algodón', 19.99, 500, 2),
    ('ROPA-002', 'Jeans Clásico', 'Pantalón de mezclilla', 49.99, 200, 2),
    ('ROPA-003', 'Sudadera Tech', 'Sudadera con capucha', 39.99, 150, 2),
    ('ROPA-004', 'Zapatos Casual', 'Calzado cómodo diario', 69.99, 100, 2),
    ('ROPA-005', 'Gorra Deportiva', 'Gorra ajustable', 14.99, 300, 2),
    ('ROPA-006', 'Chaqueta Impermeable', 'Protección contra lluvia', 89.99, 75, 2),
    ('ROPA-007', 'Vestido Casual', 'Vestido de verano', 44.99, 90, 2),
    ('ROPA-008', 'Bufanda de Lana', 'Accesorio para invierno', 24.99, 150, 2),
    
    -- Hogar (categoria_id = 3) - 8 productos
    ('HOME-001', 'Lámpara LED', 'Lámpara de escritorio regulable', 34.99, 80, 3),
    ('HOME-002', 'Silla Ergonómica', 'Silla de oficina ajustable', 249.99, 25, 3),
    ('HOME-003', 'Organizador', 'Set de organizadores', 24.99, 120, 3),
    ('HOME-004', 'Planta Artificial', 'Decoración verde', 19.99, 200, 3),
    ('HOME-005', 'Cuadro Decorativo', 'Arte moderno 50x70cm', 44.99, 60, 3),
    ('HOME-006', 'Espejo de Pared', 'Espejo redondo 60cm', 54.99, 40, 3),
    ('HOME-007', 'Set de Toallas', 'Juego de 6 toallas', 39.99, 100, 3),
    ('HOME-008', 'Alfombra Moderna', 'Alfombra 120x180cm', 79.99, 35, 3),
    
    -- Deportes (categoria_id = 4) - 6 productos
    ('DEP-001', 'Balón de Fútbol', 'Balón profesional', 34.99, 150, 4),
    ('DEP-002', 'Raqueta de Tenis', 'Raqueta de fibra de carbono', 119.99, 40, 4),
    ('DEP-003', 'Pesas Ajustables', 'Set de 2-20kg', 149.99, 60, 4),
    ('DEP-004', 'Yoga Mat', 'Tapete antideslizante', 29.99, 200, 4),
    ('DEP-005', 'Bicicleta Estática', 'Bicicleta para ejercicio', 299.99, 20, 4),
    ('DEP-006', 'Botella de Agua', 'Botella térmica 1L', 19.99, 300, 4),
    
    -- Libros (categoria_id = 5) - 5 productos
    ('LIB-001', 'Clean Code', 'Libro de programación', 39.99, 100, 5),
    ('LIB-002', 'The Pragmatic Programmer', 'Guía de desarrollo', 44.99, 80, 5),
    ('LIB-003', 'Design Patterns', 'Patrones de diseño', 49.99, 70, 5),
    ('LIB-004', 'Introduction to Algorithms', 'Libro de algoritmos', 89.99, 50, 5),
    ('LIB-005', 'The Mythical Man-Month', 'Gestión de proyectos', 34.99, 90, 5),
    
    -- Alimentos (categoria_id = 6) - 3 productos
    ('ALI-001', 'Café Premium', 'Café en grano 500g', 24.99, 150, 6),
    ('ALI-002', 'Chocolate Oscuro', 'Barra de chocolate 70%', 4.99, 400, 6),
    ('ALI-003', 'Té Verde Orgánico', 'Caja de 50 sobres', 14.99, 200, 6),
    
    -- Juguetes (categoria_id = 7) - 3 productos
    ('JUG-001', 'Cubo Rubik', 'Cubo mágico clásico', 12.99, 250, 7),
    ('JUG-002', 'Set LEGO Arquitectura', 'Set de construcción', 79.99, 60, 7),
    ('JUG-003', 'Drone Básico', 'Drone con cámara', 149.99, 35, 7),
    
    -- Belleza (categoria_id = 8) - 3 productos
    ('BEL-001', 'Crema Facial', 'Hidratante con SPF 30', 29.99, 180, 8),
    ('BEL-002', 'Shampoo Orgánico', 'Shampoo sin sulfatos 400ml', 19.99, 220, 8),
    ('BEL-003', 'Set de Maquillaje', 'Kit completo básico', 59.99, 90, 8);

-- ============================================
-- 3. TRANSACCIONES/RELACIONES
-- ============================================

-- Órdenes (30 órdenes distribuidas entre usuarios con variedad de montos y estados)
INSERT INTO ordenes (usuario_id, total, status) VALUES
    -- Usuarios Premium (>= 1000)
    (1, 1419.97, 'entregado'),    -- Ada
    (5, 1649.97, 'entregado'),    -- Margaret
    (10, 1249.95, 'pagado'),      -- Edsger
    (17, 2499.93, 'entregado'),   -- Larry (cliente premium)
    (18, 1899.94, 'pagado'),      -- Sergey
    
    -- Usuarios Regular (>= 500 && < 1000)
    (2, 649.95, 'enviado'),       -- Alan
    (3, 554.97, 'pagado'),        -- Grace
    (4, 599.97, 'entregado'),     -- Linus
    (6, 789.94, 'pagado'),        -- Donald
    (11, 529.96, 'entregado'),    -- Dennis
    (16, 649.93, 'pagado'),       -- Tim
    
    -- Usuarios Básico (< 500)
    (7, 199.97, 'entregado'),     -- Barbara
    (8, 299.96, 'enviado'),       -- Frances
    (9, 169.98, 'pagado'),        -- John
    (12, 89.97, 'pendiente'),     -- Ken
    (13, 249.98, 'entregado'),    -- Bjarne
    (14, 124.97, 'cancelado'),    -- Guido
    (15, 349.98, 'entregado'),    -- James
    (19, 199.95, 'pendiente'),    -- Mark
    (20, 449.96, 'pagado'),       -- Jeff
    
    -- Órdenes adicionales para usuarios que ya compraron (para aumentar su total)
    (1, 299.99, 'entregado'),     -- Ada (segunda compra)
    (2, 149.97, 'entregado'),     -- Alan (segunda compra)
    (3, 299.99, 'enviado'),       -- Grace (segunda compra)
    (5, 449.97, 'pagado'),        -- Margaret (segunda compra)
    (10, 399.98, 'entregado'),    -- Edsger (segunda compra)
    (17, 899.94, 'pagado'),       -- Larry (segunda compra)
    
    -- Más órdenes pequeñas
    (7, 79.99, 'entregado'),      -- Barbara (segunda compra)
    (9, 59.98, 'pagado'),         -- John (segunda compra)
    (15, 199.97, 'enviado');      -- James (segunda compra)

-- Detalle de órdenes (distribución para crear patrones interesantes en las vistas)
INSERT INTO orden_detalles (orden_id, producto_id, cantidad, precio_unitario) VALUES
    -- Orden 1 de Ada (Premium): Electrónica
    (1, 1, 1, 1299.99),   -- Laptop
    (1, 6, 1, 149.99),    -- Auriculares
    
    -- Orden 2 de Margaret (Premium): Múltiples categorías
    (2, 1, 1, 1299.99),   -- Laptop
    (2, 4, 1, 399.99),    -- Monitor
    (2, 3, 1, 89.99),     -- Teclado
    
    -- Orden 3 de Edsger (Premium): Deportes + Hogar
    (3, 21, 1, 249.99),   -- Silla
    (3, 29, 1, 299.99),   -- Bicicleta
    (3, 20, 10, 44.99),   -- Cuadros
    (3, 28, 5, 29.99),    -- Yoga Mats
    
    -- Orden 4 de Larry (Premium TOP): Setup completo
    (4, 1, 2, 1299.99),   -- 2 Laptops
    (4, 4, 2, 399.99),    -- 2 Monitores
    
    -- Orden 5 de Sergey (Premium): Electrónica variada
    (5, 7, 2, 349.99),    -- 2 Tablets
    (5, 6, 2, 149.99),    -- 2 Auriculares
    (5, 1, 1, 1299.99),   -- Laptop
    
    -- Orden 6 de Alan (Regular): Mix
    (6, 3, 2, 89.99),     -- 2 Teclados
    (6, 5, 3, 59.99),     -- 3 Webcams
    (6, 2, 5, 29.99),     -- 5 Mouse
    (6, 9, 5, 19.99),     -- 5 Camisetas
    
    -- Orden 7 de Grace (Regular): Hogar
    (7, 21, 1, 249.99),   -- Silla
    (7, 20, 3, 44.99),    -- Cuadros
    (7, 19, 5, 34.99),    -- Lámparas
    
    -- Orden 8 de Linus (Regular): Libros + Electrónica
    (8, 33, 5, 39.99),    -- Clean Code x5
    (8, 34, 3, 44.99),    -- Pragmatic Programmer x3
    (8, 8, 2, 79.99),     -- Discos duros x2
    
    -- Orden 9 de Donald (Regular): Mix variado
    (9, 35, 5, 49.99),    -- Design Patterns x5
    (9, 27, 2, 39.99),    -- Set toallas x2
    (9, 6, 1, 149.99),    -- Auriculares
    
    -- Orden 10 de Dennis (Regular): Deportes
    (10, 29, 1, 299.99),  -- Bicicleta
    (10, 28, 3, 29.99),   -- Yoga Mats x3
    (10, 30, 10, 19.99),  -- Botellas x10
    
    -- Orden 11 de Tim (Regular): Electrónica
    (11, 7, 1, 349.99),   -- Tablet
    (11, 5, 5, 59.99),    -- Webcams x5
    
    -- Orden 12 de Barbara (Básico): Ropa
    (12, 9, 10, 19.99),   -- Camisetas x10
    
    -- Orden 13 de Frances (Básico): Hogar + Belleza
    (13, 22, 5, 24.99),   -- Organizadores x5
    (13, 41, 5, 29.99),   -- Crema facial x5
    
    -- Orden 14 de John (Básico): Alimentos
    (14, 38, 10, 4.99),   -- Chocolate x10
    (14, 37, 5, 24.99),   -- Café x5
    
    -- Orden 15 de Ken (Básico): Ropa básica
    (15, 13, 3, 14.99),   -- Gorras x3
    (15, 16, 2, 24.99),   -- Bufandas x2
    
    -- Orden 16 de Bjarne (Básico): Libros
    (16, 33, 2, 39.99),   -- Clean Code x2
    (16, 34, 2, 44.99),   -- Pragmatic x2
    (16, 37, 2, 24.99),   -- Café x2
    
    -- Orden 17 de Guido (Básico - CANCELADA): Mix
    (17, 9, 5, 19.99),    -- Camisetas
    (17, 13, 2, 14.99),   -- Gorras
    
    -- Orden 18 de James (Básico): Electrónica pequeña
    (18, 2, 5, 29.99),    -- Mouse x5
    (18, 5, 2, 59.99),    -- Webcams x2
    (18, 8, 2, 79.99),    -- Discos x2
    
    -- Orden 19 de Mark (Básico): Deportes
    (19, 28, 5, 29.99),   -- Yoga Mats x5
    (19, 30, 5, 19.99),   -- Botellas x5
    
    -- Orden 20 de Jeff (Básico): Hogar
    (20, 20, 10, 44.99),  -- Cuadros x10
    
    -- Orden 21 de Ada (segunda compra): Deportes
    (21, 29, 1, 299.99),  -- Bicicleta
    
    -- Orden 22 de Alan (segunda compra): Ropa
    (22, 10, 3, 49.99),   -- Jeans x3
    
    -- Orden 23 de Grace (segunda compra): Deportes
    (23, 29, 1, 299.99),  -- Bicicleta
    
    -- Orden 24 de Margaret (segunda compra): Hogar
    (24, 21, 1, 249.99),  -- Silla
    (24, 19, 2, 34.99),   -- Lámparas x2
    (24, 26, 2, 54.99),   -- Espejos x2
    
    -- Orden 25 de Edsger (segunda compra): Libros
    (25, 36, 2, 89.99),   -- Algorithms x2
    (25, 35, 2, 49.99),   -- Design Patterns x2
    (25, 33, 2, 39.99),   -- Clean Code x2
    
    -- Orden 26 de Larry (segunda compra): Electrónica high-end
    (26, 4, 2, 399.99),   -- Monitores x2
    (26, 6, 1, 149.99),   -- Auriculares
    
    -- Orden 27 de Barbara (segunda compra): Alimentos
    (27, 37, 1, 24.99),   -- Café
    (27, 39, 2, 14.99),   -- Té x2
    (27, 38, 3, 4.99),    -- Chocolate x3
    
    -- Orden 28 de John (segunda compra): Juguetes
    (28, 40, 1, 12.99),   -- Cubo Rubik
    (28, 41, 1, 29.99),   -- Crema
    (28, 42, 1, 19.99),   -- Shampoo
    
    -- Orden 29 de James (segunda compra): Belleza + Alimentos
    (29, 43, 2, 59.99),   -- Maquillaje x2
    (29, 37, 2, 24.99),   -- Café x2
    (29, 38, 10, 4.99);   -- Chocolate x10

-- ============================================
-- 4. EDGE CASES
-- ============================================

-- Usuario con nombre largo
INSERT INTO usuarios (email, nombre, password_hash) VALUES
    ('usuario.con.email.muy.largo.pero.valido@subdominio.empresa.ejemplo.com', 
     'Usuario Con Nombre Extremadamente Largo Para Probar Límites', 
     'hash_muy_largo_12345678901234567890');

-- Producto con valores mínimos
INSERT INTO productos (codigo, nombre, precio, stock, categoria_id) VALUES
    ('EDGE-001', 'Producto Gratuito', 0.00, 0, 1);

-- ============================================
-- VERIFICACIÓN RÁPIDA
-- ============================================
-- SELECT COUNT(*) FROM usuarios;      -- Debe ser 21
-- SELECT COUNT(*) FROM productos;     -- Debe ser 44
-- SELECT COUNT(*) FROM ordenes;       -- Debe ser 29
-- SELECT COUNT(*) FROM orden_detalles; -- Debe ser 84

-- ============================================
-- FIN DEL SEED
-- ============================================