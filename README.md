# Tarea 6: Lab Reportes: Next.js Reports Dashboard (PostgreSQL + Views + Docker Compose)

**Alumno:** Ilya Cortés Ruiz  
**Matrícula:** 243710  
**Fecha:** 31/01/2026

## Descripción del Proyecto

Sistema de reportes analíticos para una tienda en línea, construido con Next.js y PostgreSQL. El dashboard permite visualizar métricas de ventas, segmentación de clientes y ranking de productos mediante 5 vistas SQL optimizadas.

---

## Cómo Usar el Proyecto

### 1. Clonar el Repositorio

```bash
git clone <url-del-repositorio>
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

Este comando:

- Construye la imagen de Next.js
- Levanta PostgreSQL con las vistas, índices y roles
- Inicia la aplicación en puerto 3000

### 4. Acceder al Dashboard

Abre tu navegador en: `http://localhost:3000`

### 5. Detener el Proyecto

```bash
docker-compose down -v
```

---

## Explicación de las Vistas SQL

### Vista 1: Productos Más Vendidos (mas_vendidos)

**Qué devuelve:** Los productos ordenados por cantidad vendida con sus métricas de ventas.

**Grain:** Una fila representa un producto que ha sido vendido al menos una vez.

**Métricas Base:**

- Suma de cantidades vendidas
- Suma de subtotales

**Campos Calculados:**

- Precio promedio de venta por cada unidad

**Filtros/Condiciones:**

- Usa HAVING para excluir a los productos que no han sido vendidos

**Por qué GROUP BY:**
Necesitamos agrupar por producto para calcular las ventas totales de cada producto individual.

**Por qué HAVING:**
Filtra productos sin ninguna venta para mostrar solo productos con movimiento.

---

### Vista 2: Ventas por Categoría (mas_vendidos_por_categoria)

**Qué devuelve:** Las categorías ordenadas por cantidad total vendida con métricas agregadas.

**Grain:** Una fila representa una categoría con al menos una venta.

**Métricas Base:**

- Suma de cantidades (total_vendido)
- Suma de subtotales (ingresos_total)

**Campos Calculados:**

- Precio promedio de venta por unidad (precio_promedio)

**Filtros/Condiciones:**

- Usa HAVING para excluir categorías sin ventas

**Por qué GROUP BY:**
Agrupamos por categoría para consolidar las ventas de todos los productos de cada categoría.

**Por qué HAVING:**
Excluye categorías que no tienen productos vendidos.

---

### Vista 3: Segmentación de Clientes (clientes_segmentacion)

**Qué devuelve:** Clientes clasificados por segmento según su gasto total y comportamiento de compra.

**Grain:** Una fila representa un usuario que ha realizado al menos una orden.

**Métricas Base:**

- COUNT de órdenes
- SUM de totales

**Campos Calculados:**

- Gasto promedio por orden
- Segmentación con CASE

**Filtros/Condiciones:**

- Usa HAVING para usuarios con al menos 1 orden

**Por qué GROUP BY:**
Agrupamos por usuario para calcular métricas de comportamiento y gasto de cada cliente.

**Por qué HAVING:**
Filtra usuarios sin órdenes para mostrar solo clientes activos.

---

### Vista 4: Análisis de Órdenes (ordenes_analisis)

**Qué devuelve:** Órdenes con su participación porcentual respecto al total de ventas del sistema.

**Grain:** Una fila representa una orden individual.

**Métricas Base:**

- COUNT de items
- SUM de subtotales

**Campos Calculados:**

- Porcentaje de participación respecto al total de ventas

**Usa:**

- CTE para calcular totales globales

**Por qué GROUP BY:**
Agrupamos por orden para contar items y mantener integridad con el CTE.

---

### Vista 5: Ranking de Productos (productos_ranking)

**Qué devuelve:** Productos rankeados por ventas con posición y porcentaje acumulado de ingresos.

**Grain:** Una fila representa un producto con información de ranking.

**Métricas Base:**

- SUM de cantidades vendidas

**Campos Calculados:**

- ROW_NUMBER para ranking
- Porcentaje acumulado

**Usa:**

- Window Functions (ROW_NUMBER, SUM OVER)

**Por qué GROUP BY:**
Agrupamos por producto antes de aplicar las window functions para calcular totales.

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

Sin el índice, PostgreSQL hace un Sequential Scan de toda la tabla orden_detalles para cada producto. Con el índice, usa Index Scan que es significativamente más rápido.

---

### Índice 2: idx_orden_detalles_orden_id

**Tabla:** orden_detalles  
**Columna:** orden_id

**Justificación:**
Este índice optimiza el JOIN entre ordenes y orden_detalles. Usado en la vista:

- ordenes_analisis (View 4)

**Qué hace:**
Acelera el conteo de items por orden cuando se hace JOIN entre las tablas ordenes y orden_detalles.

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

---

## Características Técnicas

### Base de Datos

- 5 Vistas SQL con funciones agregadas, GROUP BY, HAVING
- 1 CTE (Vista 4: cálculo de totales globales)
- 1 Window Function (Vista 5: ROW_NUMBER y SUM OVER)
- 3 Índices optimizados para JOINs
- Usuario con permisos mínimos para seguridad

### Frontend (Next.js)

- Dashboard con links a 5 reportes
- 5 páginas de reportes con tablas y KPIs
- Filtros validados con Zod (Reporte 3)
- Paginación server-side (Reportes 4 y 5)
- Server Actions para data fetching seguro
- Tailwind CSS con paleta de colores personalizada

### Docker

- Un solo comando levanta todo: docker-compose up --build
- PostgreSQL + Next.js en contenedores separados
- Healthcheck para asegurar que la base de datos esté lista
- Volúmenes persistentes para los datos

---

## Estructura del Proyecto

```
Tarea6Base/
├── database/
│   ├── 01_schema.sql       # Estructura de tablas
│   ├── 02_seed.sql         # Datos iniciales
│   ├── 03_reports_vw.sql   # 5 vistas SQL
│   ├── 04_indexes.sql      # 3 índices optimizados
│   ├── 05_roles.sql        # Usuario app_user
│   └── 06_migrate.sql      # Placeholder
├── lab-report/
│   ├── src/
│   │   ├── app/
│   │   │   ├── page.tsx           # Dashboard principal
│   │   │   └── reports/
│   │   │       ├── 1/page.tsx     # Productos más vendidos
│   │   │       ├── 2/page.tsx     # Ventas por categoría
│   │   │       ├── 3/page.tsx     # Segmentación clientes (con filtros)
│   │   │       ├── 4/page.tsx     # Análisis órdenes (con paginación)
│   │   │       └── 5/page.tsx     # Ranking productos (con paginación)
│   │   ├── components/
│   │   │   ├── dashboard.tsx
│   │   │   ├── header.tsx
│   │   │   └── sideBar.tsx
│   │   └── lib/
│   │       ├── actions/reports.ts      # Server Actions
│   │       ├── validations/schemas.ts  # Zod schemas
│   │       └── db/db.ts                # Pool de PostgreSQL
│   ├── Dockerfile
│   └── package.json
├── docker-compose.yml
├── .env
└── README.md
```

---

## Tecnologías Utilizadas

- Next.js 16 (App Router)
- PostgreSQL 16 (Alpine)
- Docker & Docker Compose
- Zod (validación)
- Tailwind CSS (estilos)
- TypeScript (tipado estático)

---

## Verificación de Requisitos

### Parte A: Base de Datos

- 5 vistas con funciones agregadas, GROUP BY, campos calculados
- 2 vistas con HAVING (Vistas 1, 2, 3)
- 3 vistas con CASE/COALESCE (Vistas 3, 4)
- 1 vista con CTE (Vista 4)
- 1 vista con Window Function (Vista 5)
- 3 índices justificados con EXPLAIN
- Usuario app_user con permisos mínimos

### Parte B: Next.js

- Dashboard con 5 links
- 5 reportes con título, descripción, tabla y KPI
- App Router (/app)
- Server Actions
- Credenciales protegidas
- Queries parametrizadas con Zod
- 2 reportes con filtros (Reporte 3)
- 2 reportes con paginación (Reportes 4, 5)

### Parte C: Docker Compose

- Un solo comando: docker-compose up --build
- PostgreSQL + Next.js funcionando juntos
- Healthcheck configurado

---

## Notas Adicionales

- Los archivos SQL están numerados (01*, 02*, etc.) para asegurar el orden de ejecución correcto en Docker
- El sistema usa una paleta de colores "Mega Salamence" personalizada
- Todos los reportes muestran estados de carga y mensajes de error amigables
- La base de datos está optimizada con índices que reducen tiempos de consulta significativamente
