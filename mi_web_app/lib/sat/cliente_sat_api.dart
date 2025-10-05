// ===============================================================
// 🧾 CLIENTE SAT API - Integración con MotorBD y PostgreSQL
// ---------------------------------------------------------------
// Este módulo maneja la comunicación con el SAT (mock API) y
// registra automáticamente cada operación en la base de datos
// PostgreSQL mediante el MotorBDAPI.
// ===============================================================

import 'cliente_sat_core.dart';
import '../contabilidad/motor_bd_api.dart';
// ⚙️ Verifica que la ruta sea correcta

class ClienteSATAPI {
  // ===============================================================
  // 🌐 CONFIGURACIÓN GENERAL
  // ===============================================================
  static const String _baseUrl =
      "https://31a285aa-ccaf-4365-8f48-b09457f9600a.mock.pstmn.io";

  // ===============================================================
  // 🧱 SECCIÓN 1: INTEGRACIÓN CON MOTORBD (registro en log_sat)
  // ---------------------------------------------------------------
  // Cada método del SAT llama a esta función para registrar logs.
  // ===============================================================
  static Future<void> _registrarLog({
    required String endpoint,
    required String mensaje,
    String? respuesta,
  }) async {
    try {
      await MotorBDAPI.insert("log_sat", {
        "endpoint": endpoint,
        "mensaje": mensaje,
        "respuesta": respuesta ?? "",
        "fecha": DateTime.now().toIso8601String(),
      });
      print("🗄 Log registrado correctamente en log_sat → $mensaje");
    } catch (e) {
      print("⚠️ Error al registrar log en log_sat: $e");
    }
  }

  // ===============================================================
  // 🧩 SECCIÓN 2: CLIENTE SAT (llamadas a servicios externos)
  // ---------------------------------------------------------------
  // Cada método ejecuta:
  //   1. Llamada al endpoint del SAT (mock API)
  //   2. Registro automático del resultado en PostgreSQL
  // ===============================================================

  // 🔴 Solicitar token al SAT
  static Future<Map<String, dynamic>> solicitarToken({
    required String rfc,
    required String password,
    required String certificado,
  }) async {
    final endpoint = "$_baseUrl/POST/solicitarToken";
    final body = {
      "rfc": rfc,
      "password": password,
      "certificado": certificado,
    };

    await _registrarLog(endpoint: endpoint, mensaje: "Solicitando token...");

    final response = await ClienteSATCore.sendRequest(
      endpoint: endpoint,
      body: body,
    );

    ClienteSATCore.manejarErrores(response.statusCode, response.body);
    final data = ClienteSATCore.parsearRespuesta(response.body);

    await _registrarLog(
      endpoint: endpoint,
      mensaje: "Token recibido correctamente.",
      respuesta: response.body,
    );

    return {
      "access_token": data["access_token"],
      "token_type": data["token_type"],
      "expires_in": data["expires_in"],
    };
  }

  // 🟠 Renovar token
  static Future<Map<String, dynamic>> renovarToken({
    required String refreshToken,
  }) async {
    final endpoint = "$_baseUrl/POST/renovarToken";
    final body = {"refresh_token": refreshToken};

    await _registrarLog(endpoint: endpoint, mensaje: "Renovando token...");

    final response = await ClienteSATCore.sendRequest(
      endpoint: endpoint,
      body: body,
    );

    ClienteSATCore.manejarErrores(response.statusCode, response.body);
    final data = ClienteSATCore.parsearRespuesta(response.body);

    await _registrarLog(
      endpoint: endpoint,
      mensaje: "Token renovado correctamente.",
      respuesta: response.body,
    );

    return {
      "access_token": data["access_token"],
      "token_type": data["token_type"],
      "expires_in": data["expires_in"],
    };
  }

  // 🧾 Validar CFDI en el SAT
  static Future<Map<String, dynamic>> validarCFDI({
    required String rfcEmisor,
    required String rfcReceptor,
    required String uuid,
    required double total,
    required String token,
  }) async {
    final endpoint = "$_baseUrl/POST/validarCFDI";
    final body = {
      "rfcEmisor": rfcEmisor,
      "rfcReceptor": rfcReceptor,
      "uuid": uuid,
      "total": total.toString(),
      "token": token,
    };

    await _registrarLog(endpoint: endpoint, mensaje: "Validando CFDI...");

    final response = await ClienteSATCore.sendRequest(
      endpoint: endpoint,
      body: body,
    );

    ClienteSATCore.manejarErrores(response.statusCode, response.body);
    final data = ClienteSATCore.parsearRespuesta(response.body);

    await _registrarLog(
      endpoint: endpoint,
      mensaje: "CFDI validado correctamente.",
      respuesta: response.body,
    );

    return {
      "estatus": data["estatus"],
      "codigoEstatus": data["codigoEstatus"],
      "esCancelable": data["esCancelable"],
      "estatusCancelacion": data["estatusCancelacion"],
    };
  }

  // 🟢 Emitir CFDI (Timbrado)
  static Future<Map<String, dynamic>> emitirCFDI({
    required String xmlFirmado,
    required String token,
  }) async {
    final endpoint = "$_baseUrl/POST/emitirCFDI";
    final body = {"xmlFirmado": xmlFirmado, "token": token};

    await _registrarLog(endpoint: endpoint, mensaje: "Emitiendo CFDI...");

    final response = await ClienteSATCore.sendRequest(
      endpoint: endpoint,
      body: body,
    );

    ClienteSATCore.manejarErrores(response.statusCode, response.body);
    final data = ClienteSATCore.parsearRespuesta(response.body);

    await _registrarLog(
      endpoint: endpoint,
      mensaje: "CFDI emitido correctamente.",
      respuesta: response.body,
    );

    return {
      "uuid": data["uuid"],
      "fechaTimbrado": data["fechaTimbrado"],
      "rfcProvCertif": data["rfcProvCertif"],
      "selloSAT": data["selloSAT"],
      "estatus": data["estatus"],
    };
  }

  // ❌ Cancelar CFDI
  static Future<Map<String, dynamic>> cancelarCFDI({
    required String uuid,
    required String token,
  }) async {
    final endpoint = "$_baseUrl/POST/cancelarCFDI";
    final body = {"uuid": uuid, "token": token};

    await _registrarLog(endpoint: endpoint, mensaje: "Cancelando CFDI...");

    final response = await ClienteSATCore.sendRequest(
      endpoint: endpoint,
      body: body,
    );

    ClienteSATCore.manejarErrores(response.statusCode, response.body);
    final data = ClienteSATCore.parsearRespuesta(response.body);

    await _registrarLog(
      endpoint: endpoint,
      mensaje: "CFDI cancelado correctamente.",
      respuesta: response.body,
    );

    return {
      "uuid": data["uuid"],
      "estatusCancelacion": data["estatusCancelacion"],
      "fechaCancelacion": data["fechaCancelacion"],
      "codigoSAT": data["codigoSAT"],
      "mensaje": data["mensaje"],
    };
  }
}
