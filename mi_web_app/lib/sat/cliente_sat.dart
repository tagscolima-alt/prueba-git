import 'package:flutter/foundation.dart';
import 'cliente_sat_api.dart';

class ClienteSAT {
  /// 🔴 Solicitar token de ejemplo
  static Future<void> obtenerTokenDemo() async {
    try {
      final tokenResponse = await ClienteSATAPI.solicitarToken(
        rfc: "AAA010101AAA",
        password: "123456",
        certificado: "BASE64_CERT",
      );

      debugPrint("✅ Token obtenido correctamente:");
      debugPrint("Access Token: ${tokenResponse['access_token']}");
      debugPrint("Tipo: ${tokenResponse['token_type']}");
      debugPrint("Expira en: ${tokenResponse['expires_in']} segundos");
    } catch (e) {
      debugPrint("❌ Error al obtener token: $e");
    }
  }

  /// 🟠 Renovar token de ejemplo
  static Future<void> renovarTokenDemo(String refreshToken) async {
    try {
      final tokenResponse = await ClienteSATAPI.renovarToken(
        refreshToken: refreshToken,
      );

      debugPrint("🔁 Token renovado correctamente:");
      debugPrint("Access Token: ${tokenResponse['access_token']}");
      debugPrint("Tipo: ${tokenResponse['token_type']}");
      debugPrint("Expira en: ${tokenResponse['expires_in']} segundos");
    } catch (e) {
      debugPrint("❌ Error al renovar token: $e");
    }
  }

  /// 🟢 Validar CFDI de ejemplo
  static Future<void> validarCFDIDemo({
    required String token,
  }) async {
    try {
      final response = await ClienteSATAPI.validarCFDI(
        rfcEmisor: "AAA010101AAA",
        rfcReceptor: "BBB010101BBB",
        uuid: "123e4567-e89b-12d3-a456-426614174000",
        total: 1000.50,
        token: token,
      );

      debugPrint("🧾 Resultado de validación CFDI:");
      debugPrint("Estatus: ${response['estatus']}");
      debugPrint("Código: ${response['codigoEstatus']}");
      debugPrint("Cancelable: ${response['esCancelable']}");
      debugPrint("Estatus Cancelación: ${response['estatusCancelacion']}");
    } catch (e) {
      debugPrint("❌ Error al validar CFDI: $e");
    }
  }

  /// 🔴 emitirCFDI(xmlFirmado, token)
  /// 📌 Envía un CFDI firmado al SAT para timbrado y recibe el timbre digital.
  static Future<Map<String, dynamic>> emitirCFDI({
    required String xmlFirmado,
    required String token,
  }) async {
    final endpoint = "$_baseUrl/POST/emitirCFDI";
    final body = {
      "xmlFirmado": xmlFirmado,
      "token": token,
    };

    final response = await ClienteSATCore._sendRequest(
      endpoint: endpoint,
      body: body,
    );

    ClienteSATCore._manejarErrores(response.statusCode, response.body);
    final data = ClienteSATCore._parsearRespuesta(response.body);

    return {
      "uuid": data["uuid"],
      "fechaTimbrado": data["fechaTimbrado"],
      "rfcProvCertif": data["rfcProvCertif"],
      "selloSAT": data["selloSAT"],
      "estatus": data["estatus"],
    };
  }


}
