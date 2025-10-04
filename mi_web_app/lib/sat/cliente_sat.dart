import 'package:flutter/foundation.dart';
import 'cliente_sat_api.dart';

class ClienteSAT {
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
}
