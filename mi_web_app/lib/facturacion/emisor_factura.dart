// ===============================================================
// 🚀 EMISOR FACTURA - Punto de entrada del módulo de facturación
// ---------------------------------------------------------------
// Este archivo sirve como fachada para usar el módulo completo.
// ===============================================================

import 'emisor_factura_api.dart';

class EmisorFactura {
  static Future<void> emitirDemo() async {
    print("🧾 Iniciando emisión de CFDI demo...");

    final token = "TOKEN_DEMO_SAT_123"; // normalmente viene del SAT

    final datosFactura = {
      "rfc_emisor": "AAA010101AAA",
      "rfc_receptor": "BBB010101BBB",
      "concepto": "Venta de servicio ERP",
      "total": 1999.99,
      "cliente_id": 1,
    };

    final resultado = await EmisorFacturaAPI.generarYEmitirCFDI(
      datosFactura: datosFactura,
      tokenSAT: token,
    );

    print("✅ CFDI emitido correctamente:");
    print(resultado);
  }
}
