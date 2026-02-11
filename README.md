# Tarea 6: Lab Reportes: Next.js Reports Dashboard (PostgreSQL + Views + Docker Compose)

**Alumno:** Ilya Cortés Ruiz  
**Matrícula:** 243710  
**Fecha:** 31/01/2026

## Cómo Usar el Proyecto

### 1. Clonar el Repositorio

```bash
git clone https://github.com/Ilyavosky/Tarea6.git
cd Tarea6Base
```

### 2. Configurar Variables de Entorno

Crea un archivo `.env` en la raíz del proyecto:

```bash
POSTGRES_USER=lab
POSTGRES_PASSWORD=dev_password
POSTGRES_DB=lab_db
POSTGRES_PORT=5437
```

### 3. Levantar el Proyecto

```bash
docker-compose up --build
```

### 4. Acceder al Dashboard

Abrir el navegador e ir a la dirección: `http://localhost:3000`

### 5. Detener el Proyecto

```bash
docker-compose down -v
```

---

## Justificación de los Índices

### Índice 1: idx_orden_detalles_producto_id

**Tabla:** orden_detalles  
**Columna:** producto_id

**Justificación:**
Este índice optimiza los JOINs entre orden_detalles y productos. Se usa en las vistas:

- mas_vendidos (View 1)
- mas_vendidos_por_categoria (View 2)
- productos_ranking (View 5)

**Qué hace:**
Reduce tiempo de ejecución en vistas con JOIN productos-orden_detalles. Especialmente importante cuando la tabla orden_detalles crece.

**Verificación:**

```sql
EXPLAIN ANALYZE
SELECT p.nombre, SUM(od.cantidad) AS total
FROM productos p
JOIN orden_detalles od ON od.producto_id = p.id
GROUP BY p.nombre;
```

Sin el índice, PostgreSQL hace un Sequential Scan de toda la tabla orden_detalles para cada producto. Con el índice, usa Index Scan que es más rápido.

---

### Índice 2: idx_orden_detalles_orden_id

**Tabla:** orden_detalles  
**Columna:** orden_id

**Justificación:**
Este índice optimiza el JOIN entre ordenes y orden_detalles. Usado en la vista:

- ordenes_analisis (View 4)

**Qué hace:**
Acelera el conteo de items por orden cundo se hace JOIN entre las tablas ordenes y orden_detalles.

**Verificación:**

```sql
EXPLAIN ANALYZE
SELECT o.id, COUNT(od.id) AS items_count
FROM ordenes o
LEFT JOIN orden_detalles od ON od.orden_id = o.id
GROUP BY o.id;
```

Sin el índice, cada orden requiere un escaneo completo de orden_detalles. Con el índice, PostgreSQL puede localizar rápidamente todos los detalles de una orden específica.

---

### Índice 3: idx_ordenes_created_at

**Tabla:** ordenes  
**Columna:** created_at

**Justificación:**
Este índice optimiza filtros y ordenamientos por fecha de las ordenes.

**Qué hace:**
Permite agregar filtros de rango de fechas sin degradar el rendimiento. Aunque no se usa en las vistas actuales, prepara el sistema para consultas futuras como "ventas del último mes" o "tendencias trimestrales".

**Verificación:**

```sql
EXPLAIN ANALYZE
SELECT *
FROM ordenes
WHERE created_at >= '2024-01-01'
ORDER BY created_at DESC;
```

Sin el índice, PostgreSQL debe escanear toda la tabla ordenes y ordenar los resultados en memoria. Con el índice, puede localizar rápidamente las filas que cumplen el criterio de fecha y devolverlas ya ordenadas.

---

## Seguridad Implementada

### Usuario de Aplicación (app_user)

La aplicación NO se conecta como el usuario postgres (superusuario). En su lugar:

**Permisos configurados:**

- Solo puede hacer SELECT en las 5 vistas
- No puede leer directamente tablas (usuarios, productos, ordenes, etc.)
- No puede INSERT, UPDATE o DELETE
- No puede crear objetos en el schema

**Por qué es importante:**
Si la aplicación es comprometida, el atacante solo puede leer datos de las vistas, no modificar la base de datos ni acceder a información sensible de las tablas base.

### Validación con Zod

**Reporte 3 (Segmentación de Clientes):**

- Valida que el segmento sea uno de: Premium, Regular, Básico, Todos
- Valida que el límite esté entre 1 y 100

**Reportes 4 y 5 (Paginación):**

- Valida que la página sea mínimo 1
- Valida que el límite esté entre 1 y 50

**Queries parametrizadas:**
Todas las consultas usan placeholders ($1, $2) en lugar de concatenar strings, previniendo SQL injection.

## Trade-offs: SQL vs Next.js

- **Agregaciones en SQL**: Todas las sumas, conteos y promedios se calculan en las VIEWS porque PostgreSQL es más rápido para grandes volúmenes de datos.

- **Paginación en BD**: La paginación se implementa con LIMIT/OFFSET en SQL pues especifican cuántas filas mostrar (LIMIT) y cuantas deben omitir con (OFFSET).

- **Filtros validados en servidor**: La validación con Zod ocurre en Server Actions antes de construir las queries. Esto evita queries inválidas y previene inyección SQL.

- **Formateo de moneda en cliente**: Los valores monetarios se almacenan como DECIMAL en la BD pero el formato de presentación ($X.XX) se hace en React para aprovechar el renderizado.

- **Estados de carga en cliente**: Los mensajes "Cargando..." se manejan con useState en React.

## Performance Evidence:

- Evidencia número 1

```sql
DROP INDEX IF EXISTS idx_orden_detalles_producto_id;

EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT p.nombre, SUM(od.cantidad) AS total
FROM productos p
JOIN orden_detalles od ON od.producto_id = p.id
GROUP BY p.nombre;

CREATE INDEX idx_orden_detalles_producto_id ON orden_detalles(producto_id);

EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT p.nombre, SUM(od.cantidad) AS total
FROM productos p
JOIN orden_detalles od ON od.producto_id = p.id
GROUP BY p.nombre;
```

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/21598fae-86eb-4d9b-86a3-2ba4dc82e50b" />

- ¿Qué realiza la query?
- Este EXPLAIN ANALYZE elimina el indice idx_orden_detalles_producto_id temporalmente y ejecuta el EXPLAIN sin el mismo, esto con el objetivo de ver el tiempo de busqueda puro haciendo un seq scan revisando todas la tabla fila por fila para ver los matches del JOIN.
- Posteriormente recrea el indice y lo prueba nuevamente, saltando así a las filas que coinciden usando el índice para mejorar la rápidez de la query.

- Evidencia número 2

```sql
DROP INDEX IF EXISTS idx_orden_detalles_orden_id;

EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT o.id, COUNT(od.id) AS items_count
FROM ordenes o
LEFT JOIN orden_detalles od ON od.orden_id = o.id
GROUP BY o.id;

CREATE INDEX idx_orden_detalles_orden_id ON orden_detalles(orden_id);

EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT o.id, COUNT(od.id) AS items_count
FROM ordenes o
LEFT JOIN orden_detalles od ON od.orden_id = o.id
GROUP BY o.id;
```

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/0761c762-d246-472d-994c-d8d2ff881b82" />

- ¿Qué realiza la query?
- Este EXPLAIN ANALYZE elimina el indice idx_orden_detalles_orden_id temporalmente y ejecuta el EXPLAIN sin el mismo, esto con el objetivo de ver el tiempo de busqueda puro de la tabla orden_detalles buscando, valga la redundancia, sus detalles.
- Posteriormente recrea el indice y lo prueba nuevamente, saltando así a las filas y encontrando instantáneamente todos los detalles de cada orden usando el índice.

## Threat Model: Seguridad Implementada

### 1. Prevención de SQL Injection

- Todas las queries usan **parámetros de posición** (`$1`, `$2`) en lugar de concatenación de strings.
- Ejemplo en `reports.ts`: `pool.query(query, [validated.limit, offset])`

### 2. Validación de Input con Zod

- Parámetros fuera de rango o valores inesperados podrían causar errores o comportamiento no deseado.

- Filtros: `segmento` solo acepta `['Premium', 'Regular', 'Básico', 'Todos']` 
- Limites de paginación: `page` mínimo 1, `limit` entre 1-50 para paginación, 1-100 para filtros.
- La validación ocurre en Server Actions antes de construir las queries.
- Código en `schemas.ts`: `z.enum(['Premium', 'Regular', 'Básico', 'Todos'])` garantiza que no se puede pasar texto.

### 3. Permisos Mínimos (Principio de Least Privilege)

- Si la aplicación es comprometida, el atacante podría leer/modificar/eliminar datos sensibles.

- La app se conecta con usuario `app_user`, NO con el superusuario `postgres`
- `app_user` tiene solo permiso de `SELECT` en las 5 views (`mas_vendidos`, `mas_vendidos_por_categoria`, `clientes_segmentacion`, `ordenes_analisis`, `productos_ranking`)
- No puede: leer tablas base (`usuarios`, `productos`, `ordenes`), hacer INSERT/UPDATE/DELETE, crear objetos en la BD
- Código en `05_roles.sql`: `GRANT SELECT ON [view_name] TO app_user` + `REVOKE CREATE ON SCHEMA public FROM app_user`

### 4. Credenciales Protegidas

- Exposición de credenciales de base de datos en el código o en el navegador del cliente.

- `DATABASE_URL` solo existe en **variables de entorno del servidor** (`.env` excluido en `.gitignore`)
- El cliente (navegador) **nunca** recibe credenciales - todas las queries se ejecutan en Server Actions
- `.env.example` incluido en el repo contiene solo placeholders, no valores reales
- Docker Compose usa `${POSTGRES_PASSWORD}` desde variables de entorno, no hardcodeado en el YAML

### 5. Server-Side Execution

- El cliente podría modificar queries o acceder directamente a la base de datos.

- Todas las operaciones de BD ocurren en **Server Actions** (`'use server'` en `reports.ts`)
- El usuario solo envía parámetros simples (números, strings validados) a través de funciones como `getClientSegmentation()`
- El navegador recibe **solo datos procesados**, nunca construye ni ejecuta queries SQL
- No hay API routes expuestos que permitan queries arbitrarias

### 6. Read-Only Views

- Modificación accidental o maliciosa de datos transaccionales.

- La app solo lee de **VIEWS**, que son capas de solo lectura sobre las tablas base
- Incluso si hubiera una vulnerabilidad de SQL injection, el atacante no podría modificar datos porque las views no permiten INSERT/UPDATE/DELETE
- Las tablas reales (`usuarios`, `productos`, `ordenes`) están completamente inaccesibles para `app_user`


## Tecnologías Utilizadas

- Next.js 16 (App Router)
- PostgreSQL 16 (Alpine)
- Docker & Docker Compose
- Zod (validación)
- Tailwind CSS (estilos)
- TypeScript (tipado estático)

## Notas Adicionales

- Los archivos SQL están numerados (01*, 02*, etc.) para asegurar el orden de ejecución correcto en Docker
- El sistema usa la paleta de colores del pokemon Mega Salamence
- Todos los reportes muestran estados de carga y mensajes de error amigables
- La base de datos está optimizada con índices que reducen tiempos de consulta significativamente

## Referencias para la realización del trabajo

https://www.w3schools.com/sql/sql_view.asp
https://www.datacamp.com/tutorial/difference-between-where-and-having-clause-in-sql
https://www.postgresql.org/docs/current/tutorial-views.html
https://www.saffrontech.net/blog/how-to-connect-nextjs-with-postgres-sql
https://node-postgres.com/apis/pool
https://dev.to/hitesh_developer/step-by-step-guide-to-building-an-admin-dashboard-with-nextjs-26e4
https://nextjs.org/docs/app/getting-started/project-structure
