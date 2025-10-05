import 'motor_bd_core.dart';

Future<void> main() async {
  print("============================================");
  print("🚀 PRUEBA LÓGICA LOCAL - ERP SAT");
  print("============================================");
  print("🧾 Iniciando emisión de CFDI demo...");

  try {
    await MotorBDCore.abrirConexion();

    // ✅ Consulta simple sin errores de sintaxis
    final result = await MotorBDCore.ejecutarSQL("SELECT current_database(), current_user, NOW();");

    print("✅ Conectado a base: ${result.first['current_database']}");
    print("👤 Usuario: ${result.first['current_user']}");
    print("🕒 Hora actual: ${result.first['now']}");

    await MotorBDCore.cerrarConexion();
  } catch (e) {
    print("❌ Error en prueba: $e");
  }

  print("============================================");
  print("🎯 PRUEBA FINALIZADA (modo local)");
  print("============================================");
}
