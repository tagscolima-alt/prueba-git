import 'dart:convert';
import 'package:http/http.dart' as http;

class SatApiService {
static const String baseUrl = 'http://127.0.0.1:3000/api/sat/cfdi';


  static Future<Map<String, dynamic>> probarConexionBD() async {
    final url = Uri.parse('$baseUrl/test-db');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}
