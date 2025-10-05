// ===============================================================
// 🧾 EMISOR FACTURA API - Integración con SAT y MotorBD
// ---------------------------------------------------------------
// Este módulo construye y envía CFDIs al SAT (mock API) usando
// ClienteSATAPI, y guarda los resultados en PostgreSQL mediante
// MotorBDAPI.
// ===============================================================

import '../sat/cliente_sat_api.dart';
import '../contabilidad/motor_bd_api.dart';
import 'emisor_factura_core.dart';

class EmisorFacturaAPI {
  /// 🟢 Generar y emitir un CFDI
  static Future<Map<String, dynamic>> generarYEmitirCFDI({
    required Map<String, dynamic> datosFactura,
    required String tokenSAT,
  }) async {
    try {
      // 1️⃣ Construir XML
      final xmlFirmado = EmisorFacturaCore.construirXML(datosFactura);

      // 2️⃣ Enviar al SAT
      final respuestaSAT = await ClienteSATAPI.emitirCFDI(
        xmlFirmado: xmlFirmado,
        token: tokenSAT,
      );

      // 3️⃣ Registrar en BD
      await MotorBDAPI.insert("cfdi", {
        "rfc_emisor": datosFactura["rfc_emisor"],
        "rfc_receptor": datosFactura["rfc_receptor"],
        "total": datosFactura["total"],
        "estatus": respuestaSAT["estatus"],
        "codigo_estatus": "SAT-200",
        "es_cancelable": true,
        "estatus_cancelacion": "No Cancelado",
        "fecha_timbrado": respuestaSAT["fechaTimbrado"],
        "token_id": 1, // opcional: referencia a tokens_sat
        "cliente_id": datosFactura["cliente_id"],
      });

      print("✅ CFDI registrado correctamente en la base de datos.");

      return respuestaSAT;
    } catch (e) {
      print("❌ Error al emitir CFDI: $e");
      rethrow;
    }
  }
}
