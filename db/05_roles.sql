-- Crea un usuario 'app_user' con permisos de solo lectura en las vistas
-- La app se conecta con este usuario, no con postgres

-- Eliminar usuario si ya existe
DROP ROLE IF EXISTS app_user;

-- Crear usuario con login
CREATE ROLE app_user WITH LOGIN PASSWORD 'app_secure_password_2026';

-- Permitir conexión a la base de datos
GRANT CONNECT ON DATABASE lab_db TO app_user;

-- Permitir uso del schema
GRANT USAGE ON SCHEMA public TO app_user;

-- Dar SELECT solo en las 5 vistas (NO en tablas)
GRANT SELECT ON mas_vendidos TO app_user;
GRANT SELECT ON mas_vendidos_por_categoria TO app_user;
GRANT SELECT ON clientes_segmentacion TO app_user;
GRANT SELECT ON ordenes_analisis TO app_user;
GRANT SELECT ON productos_ranking TO app_user;

-- Revocar permiso de crear objetos
REVOKE CREATE ON SCHEMA public FROM app_user;