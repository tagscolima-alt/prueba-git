

import '../facturacion/emisor_factura.dart';  // ✅ apunta a la carpeta correcta
import 'cliente_sat/cliente_sat.dart';        // ✅ apunta al cliente SAT

void main() async {
  print("============================================");
  print("🚀 PRUEBA LÓGICA LOCAL - ERP SAT");
  print("============================================");

  try {
    // 1️⃣ Prueba local (emisor de facturas)
    await EmisorFactura.emitirDemo();

    // 2️⃣ Prueba con el backend SAT
    print("\n============================================");
    print("🧩 Prueba de conexión con backend SAT");
    print("============================================");

    final cliente = ClienteSAT();
    await cliente.probarFlujoCompleto();

  } catch (e) {
    print("❌ Error en prueba: $e");
  }

  print("============================================");
  print("🎯 PRUEBA FINALIZADA (modo local)");
  print("============================================");
}
