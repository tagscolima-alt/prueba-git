import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cliente_sat_models.dart';
import 'cliente_sat_core.dart';

class ClienteSATApi {
  final String baseUrl = 'http://localhost:3000/api/sat/cfdi';

  Future<TokenResponse> solicitarToken(SolicitarTokenRequest request) async {
    final url = Uri.parse('$baseUrl/token');
    final response = await http.post(url,
        headers: buildHeaders(),
        body: jsonEncode(request.toJson()));

    return manejarRespuesta<TokenResponse>(
        response, (data) => TokenResponse.fromJson(data));
  }

  Future<EmitirCfdiResponse> emitirCFDI(EmitirCfdiRequest request) async {
    final url = Uri.parse('$baseUrl/emitir');
    final response = await http.post(url,
        headers: buildHeaders(),
        body: jsonEncode(request.toJson()));

    return manejarRespuesta<EmitirCfdiResponse>(
        response, (data) => EmitirCfdiResponse.fromJson(data));
  }

  Future<List<EmitirCfdiResponse>> listarCFDIs() async {
    final url = Uri.parse('$baseUrl/listar');
    final response = await http.get(url, headers: buildHeaders());

    return manejarRespuesta<List<EmitirCfdiResponse>>(response, (data) {
      return (data as List)
          .map((item) => EmitirCfdiResponse.fromJson(item))
          .toList();
    });
  }
}
