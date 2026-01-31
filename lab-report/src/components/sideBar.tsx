import React from 'react';
import Link from 'next/link';

const Sidebar = () => {
  return (
    <div className="w-60 h-screen bg-gray-800 text-white">
      <div className="p-6">
        <h1 className="text-xl font-bold mb-8">Lab Reports</h1>
        
        <ul className="flex flex-col gap-2">
          <li>
            <Link 
              href="/" 
              className="block px-4 py-2 rounded hover:bg-gray-700 transition-colors"
            >
              Dashboard
            </Link>
          </li>
          
          <li className="mt-4">
            <ul className="flex flex-col gap-1 mt-2">
              <li>
                <Link 
                  href="/reports/1" 
                  className="block px-4 py-2 rounded hover:bg-gray-700 transition-colors"
                >
                  Productos Más Vendidos
                </Link>
              </li>
              <li>
                <Link 
                  href="/reports/2" 
                  className="block px-4 py-2 rounded hover:bg-gray-700 transition-colors"
                >
                  Ventas por Categoría
                </Link>
              </li>
              <li>
                <Link 
                  href="/reports/3" 
                  className="block px-4 py-2 rounded hover:bg-gray-700 transition-colors"
                >
                  Segmentación Clientes
                </Link>
              </li>
              <li>
                <Link 
                  href="/reports/4" 
                  className="block px-4 py-2 rounded hover:bg-gray-700 transition-colors"
                >
                  Análisis de Órdenes
                </Link>
              </li>
              <li>
                <Link 
                  href="/reports/5" 
                  className="block px-4 py-2 rounded hover:bg-gray-700 transition-colors"
                >
                  Ranking de Productos
                </Link>
              </li>
            </ul>
          </li>
        </ul>
      </div>
    </div>
  );
};

export default Sidebar;