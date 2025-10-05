// ===============================================================
// 🧾 EMISOR FACTURA API - Integración con SAT y MotorBD
// ---------------------------------------------------------------
// Este módulo construye y envía CFDIs al SAT (mock API) usando
// ClienteSATApi, y guarda los resultados en PostgreSQL mediante
// MotorBDAPI.
// ===============================================================

import '../sat/cliente_sat/cliente_sat_api.dart';
import '../sat/cliente_sat/cliente_sat_models.dart';
import '../contabilidad/motor_bd_api.dart';
import 'emisor_factura_core.dart';

class EmisorFacturaAPI {
  /// 🟢 Generar y emitir un CFDI
  static Future<Map<String, dynamic>> generarYEmitirCFDI({
    required Map<String, dynamic> datosFactura,
    required String tokenSAT,
  }) async {
    try {
      // 1️⃣ Construir XML firmado
      final xmlFirmado = EmisorFacturaCore.construirXML(datosFactura);

      // 2️⃣ Enviar al SAT (mock)
      final satApi = ClienteSATApi();
      final respuestaSAT = await satApi.emitirCFDI(
        EmitirCfdiRequest(
          rfcEmisor: datosFactura["rfc_emisor"],
          rfcReceptor: datosFactura["rfc_receptor"],
          total: datosFactura["total"],
          token: tokenSAT,
        ),
      );

      // 3️⃣ Registrar en la base de datos
      await MotorBDAPI.insert("cfdi", {
        "rfc_emisor": datosFactura["rfc_emisor"],
        "rfc_receptor": datosFactura["rfc_receptor"],
        "total": datosFactura["total"],
        "estatus": respuestaSAT.estatus,
        "codigo_estatus": "SAT-200",
        "es_cancelable": true,
        "estatus_cancelacion": "No Cancelado",
        "fecha_timbrado": respuestaSAT.fechaTimbrado,
        "token_id": 1, // opcional: referencia a tokens_sat
        "cliente_id": datosFactura["cliente_id"],
      });

      print("✅ CFDI registrado correctamente en la base de datos.");

      // 4️⃣ Retornar el resultado como Map para compatibilidad
      return {
        "uuid": respuestaSAT.uuid,
        "estatus": respuestaSAT.estatus,
        "fechaTimbrado": respuestaSAT.fechaTimbrado,
      };
    } catch (e) {
      print("❌ Error al emitir CFDI: $e");
      rethrow;
    }
  }
}
