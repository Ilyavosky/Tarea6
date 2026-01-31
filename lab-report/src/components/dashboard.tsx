import React from 'react';
import Link from 'next/link';

const Dashboard = () => {
  const reports = [
    {
      id: 1,
      title: 'Productos más Vendidos',
      description: 'Tabla de resultados de los productos más vendidos'
    },
    {
      id: 2,
      title: 'Productos más Vendidos por categoría',
      description: 'Tabla de resultados de los productos más vendidos por categoría'
    },
    {
      id: 3,
      title: 'Segmentación de Clientes',
      description: 'Tabla de resultados de los clientes con respecto a su gasto total'
    },
    {
      id: 4,
      title: 'Análisis de Órdenes',
      description: 'Tabla de resultados de los productos con su porcentaje de participación en las ventas'
    },
    {
      id: 5,
      title: 'Ranking de Productos',
      description: 'Tabla de resultados de los productos rankeados con porcentaje acumulado'
    },
  ];

  return (
    <div className="p-8 bg-gray-50 min-h-screen">
      <div className="mb-8">
        <h2 className="text-3xl font-bold text-gray-800 mb-2">Reportes Disponibles</h2>
        <p className="text-gray-600">Selecciona un reporte para acceder a la View</p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {reports.map((report) => (
          <Link
            key={report.id}
            href={`/reports/${report.id}`}
            className="block bg-white rounded-lg shadow-md hover:shadow-xl transition-shadow duration-300 overflow-hidden"
          >
            <div className="p-6">
              <h3 className="text-xl font-semibold text-gray-800 mb-2">
                {report.title}
              </h3>
              <p className="text-gray-600 text-sm">
                {report.description}
              </p>
            </div>
            <div className="bg-blue-50 px-6 py-3">
              <span className="text-blue-600 text-sm font-medium">
                Acceder a la view
              </span>
            </div>
          </Link>
        ))}
      </div>
    </div>
  );
};

export default Dashboard;