// lib/contabilidad/reportes_api.dart
import 'motor_bd_api.dart';

class ReportesAPI {
  static Future<List<Map<String, dynamic>>> ingresosPorPeriodo(
    DateTime inicio,
    DateTime fin,
  ) async {
    final filtro =
        "fecha BETWEEN '${inicio.toIso8601String()}' AND '${fin.toIso8601String()}'";
    return await MotorBDAPI.query('ingresos', filtro: filtro);
  }
}
