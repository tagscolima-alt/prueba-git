// lib/contabilidad/reportes_core.dart
import 'reportes_api.dart';

class ReportesCore {
  static Future<Map<String, dynamic>> generarReporteMensual() async {
    final ahora = DateTime.now();
    final inicio = DateTime(ahora.year, ahora.month, 1);
    final fin = DateTime(ahora.year, ahora.month + 1, 0);

    final ingresos = await ReportesAPI.ingresosPorPeriodo(inicio, fin);
    final total = ingresos.fold<double>(
      0.0,
      (suma, item) => suma + (item['monto'] ?? 0.0),
    );

    return {
      "mes": "${inicio.month}-${inicio.year}",
      "totalIngresos": total,
      "cantidadOperaciones": ingresos.length,
    };
  }
}
