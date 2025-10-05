// lib/contabilidad/registro_ingresos.dart
import 'registro_ingresos_core.dart';

class RegistroIngresos {
  static Future<void> registrarDemo() async {
    try {
      await RegistroIngresosCore.guardarIngreso(
        concepto: "Venta producto A",
        monto: 1500.50,
        categoria: "Ventas",
      );
      print("✅ Ingreso registrado correctamente.");
    } catch (e) {
      print("❌ Error al registrar ingreso: $e");
    }
  }

  static Future<void> listarDemo() async {
    final lista = await RegistroIngresosCore.listarIngresos();
    print("📋 Lista de ingresos:");
    for (var i in lista) {
      print(i);
    }
  }
}
