import { getTopProducts } from '@/lib/actions/reports';

interface Product {
  id: number;
  nombre: string;
  categoria: string;
  total_vendido: number;
  ingresos_total: string;
  precio_promedio: string;
}

export default async function Report1() {
  const result = await getTopProducts();

  if (!result.success) {
    return (
      <div className="p-8">
        <div className="bg-salamence-red text-white p-4 rounded">
          Error: {result.error}
        </div>
      </div>
    );
  }

  const products = result.data as Product[];
  const totalVentas = products.reduce((sum, p) => sum + parseFloat(p.ingresos_total), 0);

  return (
    <div className="p-8 bg-gray-50 min-h-screen">
      <div className="mb-6">
        <h1 className="text-3xl font-bold text-shadow-navy mb-2">Productos Más Vendidos</h1>
        <p className="text-armor-grey">Análisis de productos ordenados por cantidad vendida</p>
      </div>

      <div className="bg-salamence-blue p-6 rounded-lg mb-6">
        <p className="text-sm text-white opacity-80">Ventas Totales</p>
        <p className="text-4xl font-bold text-white">${totalVentas.toFixed(2)}</p>
      </div>

      <div className="bg-white rounded-lg shadow overflow-hidden">
        <table className="w-full">
          <thead className="bg-gray-100">
            <tr>
              <th className="p-3 text-left text-shadow-navy font-semibold">Producto</th>
              <th className="p-3 text-left text-shadow-navy font-semibold">Categoría</th>
              <th className="p-3 text-right text-shadow-navy font-semibold">Unidades</th>
              <th className="p-3 text-right text-shadow-navy font-semibold">Ingresos</th>
              <th className="p-3 text-right text-shadow-navy font-semibold">Precio Promedio</th>
            </tr>
          </thead>
          <tbody>
            {products.map((p) => (
              <tr key={p.id} className="border-t border-armor-grey hover:bg-gray-50">
                <td className="p-3 text-shadow-navy">{p.nombre}</td>
                <td className="p-3 text-armor-grey">{p.categoria}</td>
                <td className="p-3 text-right text-shadow-navy font-medium">{p.total_vendido}</td>
                <td className="p-3 text-right text-shadow-navy font-medium">${parseFloat(p.ingresos_total).toFixed(2)}</td>
                <td className="p-3 text-right text-armor-grey">${parseFloat(p.precio_promedio).toFixed(2)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}