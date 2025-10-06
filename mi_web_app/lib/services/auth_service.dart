import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://192.168.1.99:3000/api/auth'; // 👈 Usa tu IP local

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    // ✅ Aceptamos 200 y 201 como respuestas válidas
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final data = jsonDecode(response.body);
        return data;
      } catch (e) {
        throw Exception('Error al parsear respuesta: ${response.body}');
      }
    } else {
      // ❌ Si el backend devuelve error (400, 401, etc.)
      throw Exception('Error en login (${response.statusCode}): ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> register(String nombre, String email, String password) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nombre': nombre, 'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error en registro: ${response.body}');
    }
  }
}
