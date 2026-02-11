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
