import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.1.99:3000/api/auth'; // tu IP local

  /// 🔹 Iniciar sesión
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);

      // ✅ Guardar sesión localmente
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('usuario', jsonEncode(data['usuario']));

      return data;
    } else {
      throw Exception('Error en login (${response.statusCode}): ${response.body}');
    }
  }

  /// 🔹 Registro de usuario
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

  /// 🔹 Cerrar sesión
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// 🔹 Obtener sesión guardada
  static Future<Map<String, dynamic>?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final user = prefs.getString('usuario');

    if (token != null && user != null) {
      return {
        'token': token,
        'usuario': jsonDecode(user),
      };
    }
    return null;
  }
}
