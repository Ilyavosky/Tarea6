'use client';

import { useState, useEffect } from 'react';
import { getProductRanking } from '@/lib/actions/reports';

interface RankedProduct {
  id: number;
  nombre: string;
  categoria: string;
  total_vendido: number;
  ingresos_total: string;
  ranking_ventas: number;
  porcentaje_acumulado: string;
}

interface Pagination {
  page: number;
  limit: number;
  total: number;
  totalPages: number;
}

export default function Report5() {
  const [page, setPage] = useState(1);
  const [products, setProducts] = useState<RankedProduct[]>([]);
  const [pagination, setPagination] = useState<Pagination | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    async function fetchData() {
      setLoading(true);
      const result = await getProductRanking({ page, limit: 10 });
      
      if (result.success) {
        setProducts(result.data as RankedProduct[]);
        setPagination(result.pagination as Pagination);
        setError('');
      } else {
        setError(result.error || 'Error desconocido');
      }
      setLoading(false);
    }
    fetchData();
  }, [page]);

  return (
    <div className="p-8 bg-gray-50 min-h-screen">
      <div className="mb-6">
        <h1 className="text-3xl font-bold text-shadow-navy mb-2">Ranking de Productos</h1>
        <p className="text-armor-grey">Productos rankeados con porcentaje acumulado</p>
      </div>

      {error && (
        <div className="bg-salamence-red text-white p-4 rounded mb-6">
          Error: {error}
        </div>
      )}

      {!loading && !error && (
        <>
          <div className="bg-white rounded-lg shadow overflow-hidden mb-6">
            <table className="w-full">
              <thead className="bg-gray-100">
                <tr>
                  <th className="p-3 text-center text-shadow-navy font-semibold">Ranking</th>
                  <th className="p-3 text-left text-shadow-navy font-semibold">Producto</th>
                  <th className="p-3 text-left text-shadow-navy font-semibold">Categoría</th>
                  <th className="p-3 text-right text-shadow-navy font-semibold">Unidades</th>
                  <th className="p-3 text-right text-shadow-navy font-semibold">Ingresos</th>
                  <th className="p-3 text-right text-shadow-navy font-semibold">% Acumulado</th>
                </tr>
              </thead>
              <tbody>
                {products.map((p) => (
                  <tr key={p.id} className="border-t border-armor-grey hover:bg-gray-50">
                    <td className="p-3 text-center">
                      <span className="inline-flex items-center justify-center w-8 h-8 rounded-full bg-salamence-blue text-white font-bold text-sm">
                        {p.ranking_ventas}
                      </span>
                    </td>
                    <td className="p-3 text-shadow-navy font-medium">{p.nombre}</td>
                    <td className="p-3 text-armor-grey">{p.categoria}</td>
                    <td className="p-3 text-right text-shadow-navy font-medium">{p.total_vendido}</td>
                    <td className="p-3 text-right text-shadow-navy font-medium">${parseFloat(p.ingresos_total).toFixed(2)}</td>
                    <td className="p-3 text-right text-salamence-blue font-medium">{p.porcentaje_acumulado}%</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {pagination && (
            <div className="flex justify-between items-center">
              <p className="text-armor-grey">
                Página {pagination.page} de {pagination.totalPages} ({pagination.total} productos)
              </p>
              <div className="flex gap-2">
                <button
                  onClick={() => setPage(p => Math.max(1, p - 1))}
                  disabled={page === 1}
                  className="px-4 py-2 bg-salamence-blue text-white rounded disabled:bg-gray-300 disabled:cursor-not-allowed hover:bg-deep-crimson transition-colors"
                >
                  Anterior
                </button>
                <button
                  onClick={() => setPage(p => Math.min(pagination.totalPages, p + 1))}
                  disabled={page === pagination.totalPages}
                  className="px-4 py-2 bg-salamence-blue text-white rounded disabled:bg-gray-300 disabled:cursor-not-allowed hover:bg-deep-crimson transition-colors"
                >
                  Siguiente
                </button>
              </div>
            </div>
          )}
        </>
      )}

      {loading && (
        <div className="text-center py-12">
          <p className="text-armor-grey">Cargando...</p>
        </div>
      )}
    </div>
  );
}