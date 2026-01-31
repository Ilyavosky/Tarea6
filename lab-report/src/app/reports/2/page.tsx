import { getTopCategories } from '@/lib/actions/reports';

interface Category {
  id: number;
  nombre: string;
  descripcion: string;
  total_vendido: number;
  ingresos_total: string;
  precio_promedio: string;
}

export default async function Report2() {
  const result = await getTopCategories();

  if (!result.success) {
    return (
      <div className="p-8">
        <div className="bg-salamence-red text-white p-4 rounded">
          Error: {result.error}
        </div>
      </div>
    );
  }

  const categories = result.data as Category[];
  const totalVentas = categories.reduce((sum, c) => sum + parseFloat(c.ingresos_total), 0);

  return (
    <div className="p-8 bg-gray-50 min-h-screen">
      <div className="mb-6">
        <h1 className="text-3xl font-bold text-shadow-navy mb-2">Ventas por Categoría</h1>
        <p className="text-armor-grey">Resumen de ventas agrupadas por categoría de producto</p>
      </div>

      <div className="bg-salamence-blue p-6 rounded-lg mb-6">
        <p className="text-sm text-white opacity-80">Ventas Totales</p>
        <p className="text-4xl font-bold text-white">${totalVentas.toFixed(2)}</p>
      </div>

      <div className="bg-white rounded-lg shadow overflow-hidden">
        <table className="w-full">
          <thead className="bg-gray-100">
            <tr>
              <th className="p-3 text-left text-shadow-navy font-semibold">Categoría</th>
              <th className="p-3 text-left text-shadow-navy font-semibold">Descripción</th>
              <th className="p-3 text-right text-shadow-navy font-semibold">Unidades</th>
              <th className="p-3 text-right text-shadow-navy font-semibold">Ingresos</th>
              <th className="p-3 text-right text-shadow-navy font-semibold">Precio Promedio</th>
            </tr>
          </thead>
          <tbody>
            {categories.map((c) => (
              <tr key={c.id} className="border-t border-armor-grey hover:bg-gray-50">
                <td className="p-3 text-shadow-navy font-medium">{c.nombre}</td>
                <td className="p-3 text-armor-grey">{c.descripcion}</td>
                <td className="p-3 text-right text-shadow-navy font-medium">{c.total_vendido}</td>
                <td className="p-3 text-right text-shadow-navy font-medium">${parseFloat(c.ingresos_total).toFixed(2)}</td>
                <td className="p-3 text-right text-armor-grey">${parseFloat(c.precio_promedio).toFixed(2)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}