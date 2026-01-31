'use client';

import { useState, useEffect } from 'react';
import { getOrdersAnalysis } from '@/lib/actions/reports';

interface Order {
  orden_id: number;
  cliente_nombre: string;
  status: string;
  items_count: number;
  total_orden: string;
  porcentaje_ventas: string;
  estado_legible: string;
}

interface Pagination {
  page: number;
  limit: number;
  total: number;
  totalPages: number;
}

export default function Report4() {
  const [page, setPage] = useState(1);
  const [orders, setOrders] = useState<Order[]>([]);
  const [pagination, setPagination] = useState<Pagination | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    async function fetchData() {
      setLoading(true);
      const result = await getOrdersAnalysis({ page, limit: 10 });
      
      if (result.success) {
        setOrders(result.data as Order[]);
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
        <h1 className="text-3xl font-bold text-shadow-navy mb-2">Análisis de Órdenes</h1>
        <p className="text-armor-grey">Órdenes con participación en ventas totales</p>
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
                  <th className="p-3 text-left text-shadow-navy font-semibold">Orden ID</th>
                  <th className="p-3 text-left text-shadow-navy font-semibold">Cliente</th>
                  <th className="p-3 text-center text-shadow-navy font-semibold">Items</th>
                  <th className="p-3 text-right text-shadow-navy font-semibold">Total</th>
                  <th className="p-3 text-right text-shadow-navy font-semibold">% Ventas</th>
                  <th className="p-3 text-center text-shadow-navy font-semibold">Estado</th>
                </tr>
              </thead>
              <tbody>
                {orders.map((o) => (
                  <tr key={o.orden_id} className="border-t border-armor-grey hover:bg-gray-50">
                    <td className="p-3 text-shadow-navy font-medium">#{o.orden_id}</td>
                    <td className="p-3 text-shadow-navy">{o.cliente_nombre}</td>
                    <td className="p-3 text-center text-armor-grey">{o.items_count}</td>
                    <td className="p-3 text-right text-shadow-navy font-medium">${parseFloat(o.total_orden).toFixed(2)}</td>
                    <td className="p-3 text-right text-salamence-blue font-medium">{o.porcentaje_ventas}%</td>
                    <td className="p-3 text-center">
                      <span className={`px-3 py-1 rounded-full text-xs font-medium ${
                        o.estado_legible === 'Completada' ? 'bg-green-100 text-green-800' :
                        o.estado_legible === 'En proceso' ? 'bg-salamence-blue text-white' :
                        o.estado_legible === 'Pendiente' ? 'bg-yellow-100 text-yellow-800' :
                        'bg-gray-200 text-gray-700'
                      }`}>
                        {o.estado_legible}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {pagination && (
            <div className="flex justify-between items-center">
              <p className="text-armor-grey">
                Página {pagination.page} de {pagination.totalPages} ({pagination.total} órdenes)
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