// lib/sat/cliente_sat_core.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ClienteSATCore {
  // 🔹 Construye encabezados básicos
  static Map<String, String> buildHeaders({String? token}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // 🔹 Envía una petición genérica POST
  static Future<http.Response> sendRequest({
    required String endpoint,
    required Map<String, dynamic> body,
    String? token,
  }) async {
    final uri = Uri.parse(endpoint);
    final response = await http.post(
      uri,
      headers: buildHeaders(token: token),
      body: jsonEncode(body),
    );
    return response;
  }

  // 🔹 Maneja códigos de error
  static void manejarErrores(int statusCode, String responseBody) {
    switch (statusCode) {
      case 200:
        return;
      case 400:
        throw Exception("Solicitud incorrecta (400): $responseBody");
      case 401:
        throw Exception("No autorizado (401): token inválido o expirado");
      case 500:
        throw Exception("Error interno del servidor SAT");
      default:
        throw Exception("Error desconocido: $statusCode\n$responseBody");
    }
  }

  // 🔹 Convierte la respuesta JSON en objeto Map
  static Map<String, dynamic> parsearRespuesta(String rawResponse) {
    return jsonDecode(rawResponse) as Map<String, dynamic>;
  }
}

