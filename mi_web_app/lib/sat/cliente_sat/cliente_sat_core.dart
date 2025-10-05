import 'dart:convert';
import 'package:http/http.dart' as http;

Map<String, String> buildHeaders() => {
      'Content-Type': 'application/json',
    };

T manejarRespuesta<T>(
    http.Response response, T Function(dynamic data) parseFn) {
  // ✅ Aceptar tanto 200 (OK) como 201 (Created)
  if (response.statusCode == 200 || response.statusCode == 201) {
    return parseFn(jsonDecode(response.body));
  } else {
    throw Exception('Error ${response.statusCode}: ${response.body}');
  }
}
