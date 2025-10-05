// lib/contabilidad/registro_ingresos_core.dart
import 'registro_ingresos_api.dart';

class RegistroIngresosCore {
  static Future<void> guardarIngreso({
    required String concepto,
    required double monto,
    String? categoria,
  }) async {
    if (monto <= 0) throw Exception("El monto debe ser mayor que 0");

    final ingreso = {
      "concepto": concepto,
      "monto": monto,
      "categoria": categoria ?? "General",
      "fecha": DateTime.now().toIso8601String(),
    };

    await RegistroIngresosAPI.registrarIngreso(ingreso);
  }

  static Future<List<Map<String, dynamic>>> listarIngresos() async {
    return await RegistroIngresosAPI.obtenerIngresos();
  }
}
