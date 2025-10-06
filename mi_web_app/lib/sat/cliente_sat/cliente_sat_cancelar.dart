import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cliente_sat_core.dart';

class ClienteSATCancelar {
  final String baseUrl = 'http://192.168.1.99:3000/api/sat/cfdi'; // 🔹 ajusta si cambia tu IP

  /// ❌ Cancelar CFDI existente
  Future<Map<String, dynamic>> cancelarCFDI(String uuid, String motivo) async {
    final url = Uri.parse('$baseUrl/cancelar');
    final body = jsonEncode({'uuid': uuid, 'motivo': motivo});

    final response = await http.post(url, headers: buildHeaders(), body: body);

    return manejarRespuesta<Map<String, dynamic>>(
      response,
      (data) => data as Map<String, dynamic>,
    );
  }
}
