// lib/sat/cliente_sat.dart
import 'package:flutter/foundation.dart';
import 'cliente_sat_api.dart';

/// Clase principal que agrupa las operaciones del cliente SAT.
/// Cada método usa las funciones del módulo API y muestra resultados en consola.
class ClienteSAT {
  // 🔴 Solicitar Token (demo)
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

  // 🟠 Renovar Token (demo)
  static Future<void> renovarTokenDemo(String tokenAnterior) async {
    try {
      final tokenResponse =
          await ClienteSATAPI.renovarToken(refreshToken: tokenAnterior);

      debugPrint("🔁 Token renovado correctamente:");
      debugPrint("Access Token: ${tokenResponse['access_token']}");
      debugPrint("Tipo: ${tokenResponse['token_type']}");
      debugPrint("Expira en: ${tokenResponse['expires_in']} segundos");
    } catch (e) {
      debugPrint("❌ Error al renovar token: $e");
    }
  }

  // 🧾 Validar CFDI (demo)
  static Future<void> validarCFDIDemo({required String token}) async {
    try {
      final response = await ClienteSATAPI.validarCFDI(
        rfcEmisor: "AAA010101AAA",
        rfcReceptor: "BBB010101BBB",
        uuid: "123e4567-e89b-12d3-a456-426614174000",
        total: 1234.56,
        token: token,
      );

      debugPrint("🧾 Resultado de validación CFDI:");
      debugPrint("Estatus: ${response['estatus']}");
      debugPrint("Código Estatus: ${response['codigoEstatus']}");
      debugPrint("Cancelable: ${response['esCancelable']}");
      debugPrint("Estatus Cancelación: ${response['estatusCancelacion']}");
    } catch (e) {
      debugPrint("❌ Error al validar CFDI: $e");
    }
  }
}
