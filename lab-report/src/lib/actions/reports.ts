'use server'

import { pool } from '@/lib/db/db';
import { filterClientesSchema, paginationSchema } from '@/lib/validations/schemas';

export async function getTopProducts() {
  try {
    const result = await pool.query('SELECT * FROM mas_vendidos');
    return { success: true, data: result.rows };
  } catch (error) {
    console.error('Error fetching top products:', error);
    return { success: false, error: 'Error al obtener productos más vendidos' };
  }
}

export async function getTopCategories() {
  try {
    const result = await pool.query('SELECT * FROM mas_vendidos_por_categoria');
    return { success: true, data: result.rows };
  } catch (error) {
    console.error('Error fetching categories:', error);
    return { success: false, error: 'Error al obtener categorías' };
  }
}

export async function getClientSegmentation(input: unknown) {
  try {
    const validated = filterClientesSchema.parse(input);
    
    let query = 'SELECT * FROM clientes_segmentacion';
    const params: (string | number)[] = [];
    
    if (validated.segmento !== 'Todos') {
      query += ' WHERE segmento_cliente = $1';
      params.push(validated.segmento);
    }
    
    query += ` LIMIT $${params.length + 1}`;
    params.push(validated.limit);
    
    const result = await pool.query(query, params);
    return { success: true, data: result.rows, filters: validated };
  } catch (error) {
    console.error('Error fetching client segmentation:', error);
    return { success: false, error: 'Error al obtener segmentación de clientes' };
  }
}

export async function getOrdersAnalysis(input: unknown) {
  try {
    const validated = paginationSchema.parse(input);
    
    const offset = (validated.page - 1) * validated.limit;
    
    const query = `
      SELECT * FROM ordenes_analisis
      ORDER BY total_orden DESC
      LIMIT $1 OFFSET $2
    `;
    
    const result = await pool.query(query, [validated.limit, offset]);
    
    const countResult = await pool.query('SELECT COUNT(*) FROM ordenes_analisis');
    const total = parseInt(countResult.rows[0].count);
    
    return {
      success: true,
      data: result.rows,
      pagination: {
        page: validated.page,
        limit: validated.limit,
        total,
        totalPages: Math.ceil(total / validated.limit),
      },
    };
  } catch (error) {
    console.error('Error fetching orders analysis:', error);
    return { success: false, error: 'Error al obtener análisis de órdenes' };
  }
}

export async function getProductRanking(input: unknown) {
  try {
    const validated = paginationSchema.parse(input);
    
    const offset = (validated.page - 1) * validated.limit;
    
    const query = `
      SELECT * FROM productos_ranking
      ORDER BY ranking_ventas
      LIMIT $1 OFFSET $2
    `;
    
    const result = await pool.query(query, [validated.limit, offset]);
    
    const countResult = await pool.query('SELECT COUNT(*) FROM productos_ranking');
    const total = parseInt(countResult.rows[0].count);
    
    return {
      success: true,
      data: result.rows,
      pagination: {
        page: validated.page,
        limit: validated.limit,
        total,
        totalPages: Math.ceil(total / validated.limit),
      },
    };
  } catch (error) {
    console.error('Error fetching product ranking:', error);
    return { success: false, error: 'Error al obtener ranking de productos' };
  }
}