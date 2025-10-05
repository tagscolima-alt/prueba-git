// lib/contabilidad/reportes.dart
import 'reportes_core.dart';

class Reportes {
  static Future<void> generarDemo() async {
    final reporte = await ReportesCore.generarReporteMensual();
    print("📊 Reporte mensual generado:");
    print("Mes: ${reporte['mes']}");
    print("Total ingresos: \$${reporte['totalIngresos']}");
    print("Operaciones: ${reporte['cantidadOperaciones']}");
  }
}
