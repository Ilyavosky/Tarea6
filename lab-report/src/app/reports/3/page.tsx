'use client';

import { useState, useEffect } from 'react';
import { getClientSegmentation } from '@/lib/actions/reports';

interface Client {
  id: number;
  nombre: string;
  email: string;
  ordenes_totales: number;
  gasto_total: string;
  gasto_promedio: string;
  segmento_cliente: string;
}

export default function Report3() {
  const [segmento, setSegmento] = useState('Todos');
  const [clients, setClients] = useState<Client[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    async function fetchData() {
      setLoading(true);
      const result = await getClientSegmentation({ segmento, limit: 20 });
      
      if (result.success) {
        setClients(result.data as Client[]);
        setError('');
      } else {
        setError(result.error || 'Error desconocido');
      }
      setLoading(false);
    }
    fetchData();
  }, [segmento]);

  const totalGasto = clients.reduce((sum, c) => sum + parseFloat(c.gasto_total), 0);

  return (
    <div className="p-8 bg-gray-50 min-h-screen">
      <div className="mb-6">
        <h1 className="text-3xl font-bold text-shadow-navy mb-2">Segmentación de Clientes</h1>
        <p className="text-armor-grey">Clientes clasificados por nivel de gasto</p>
      </div>

      <div className="mb-6 flex gap-4 items-center">
        <label className="text-shadow-navy font-medium">Filtrar por segmento:</label>
        <select
          value={segmento}
          onChange={(e) => setSegmento(e.target.value)}
          className="border border-armor-grey rounded px-4 py-2 text-shadow-navy"
        >
          <option value="Todos">Todos</option>
          <option value="Premium">Premium</option>
          <option value="Regular">Regular</option>
          <option value="Básico">Básico</option>
        </select>
      </div>

      {error && (
        <div className="bg-salamence-red text-white p-4 rounded mb-6">
          Error: {error}
        </div>
      )}

      {!loading && !error && (
        <>
          <div className="bg-salamence-blue p-6 rounded-lg mb-6">
            <p className="text-sm text-white opacity-80">Gasto Total</p>
            <p className="text-4xl font-bold text-white">${totalGasto.toFixed(2)}</p>
          </div>

          <div className="bg-white rounded-lg shadow overflow-hidden">
            <table className="w-full">
              <thead className="bg-gray-100">
                <tr>
                  <th className="p-3 text-left text-shadow-navy font-semibold">Cliente</th>
                  <th className="p-3 text-left text-shadow-navy font-semibold">Email</th>
                  <th className="p-3 text-center text-shadow-navy font-semibold">Órdenes</th>
                  <th className="p-3 text-right text-shadow-navy font-semibold">Gasto Total</th>
                  <th className="p-3 text-right text-shadow-navy font-semibold">Gasto Promedio</th>
                  <th className="p-3 text-center text-shadow-navy font-semibold">Segmento</th>
                </tr>
              </thead>
              <tbody>
                {clients.map((c) => (
                  <tr key={c.id} className="border-t border-armor-grey hover:bg-gray-50">
                    <td className="p-3 text-shadow-navy font-medium">{c.nombre}</td>
                    <td className="p-3 text-armor-grey">{c.email}</td>
                    <td className="p-3 text-center text-shadow-navy">{c.ordenes_totales}</td>
                    <td className="p-3 text-right text-shadow-navy font-medium">${parseFloat(c.gasto_total).toFixed(2)}</td>
                    <td className="p-3 text-right text-armor-grey">${parseFloat(c.gasto_promedio).toFixed(2)}</td>
                    <td className="p-3 text-center">
                      <span className={`px-3 py-1 rounded-full text-xs font-medium ${
                        c.segmento_cliente === 'Premium' ? 'bg-salamence-blue text-white' :
                        c.segmento_cliente === 'Regular' ? 'bg-armor-grey text-white' :
                        'bg-gray-300 text-shadow-navy'
                      }`}>
                        {c.segmento_cliente}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
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