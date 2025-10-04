import 'cliente_sat_core.dart';

class ClienteSATAPI {
  static const String _baseUrl =
      "https://31a285aa-ccaf-4365-8f48-b09457f9600a.mock.pstmn.io";

  // 🔴 Solicitar token
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

    final response = await ClienteSATCore.sendRequest(
      endpoint: endpoint,
      body: body,
    );

    ClienteSATCore.manejarErrores(response.statusCode, response.body);
    final data = ClienteSATCore.parsearRespuesta(response.body);

    return {
      "access_token": data["access_token"],
      "token_type": data["token_type"],
      "expires_in": data["expires_in"],
    };
  }

  /// 🟠 Renovar Token
  static Future<Map<String, dynamic>> renovarToken({
    required String refreshToken,
  }) async {
    final endpoint = "$_baseUrl/POST/renovarToken";
    final body = {
      "refresh_token": refreshToken,
    };

    final response = await ClienteSATCore.sendRequest(
      endpoint: endpoint,
      body: body,
    );

    ClienteSATCore.manejarErrores(response.statusCode, response.body);
    final data = ClienteSATCore.parsearRespuesta(response.body);

    return {
      "access_token": data["access_token"],
      "token_type": data["token_type"],
      "expires_in": data["expires_in"],
    };
  }

  // 🧾 Validar CFDI
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
      "total": total.toString(), // 🔹 convertido a string
      "token": token,
    };

    final response = await ClienteSATCore.sendRequest(
      endpoint: endpoint,
      body: body,
    );

    ClienteSATCore.manejarErrores(response.statusCode, response.body);
    final data = ClienteSATCore.parsearRespuesta(response.body);

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
    final body = {
      "xmlFirmado": xmlFirmado,
      "token": token,
    };

    final response = await ClienteSATCore.sendRequest(
      endpoint: endpoint,
      body: body,
    );

    ClienteSATCore.manejarErrores(response.statusCode, response.body);
    final data = ClienteSATCore.parsearRespuesta(response.body);

    return {
      "uuid": data["uuid"],
      "fechaTimbrado": data["fechaTimbrado"],
      "rfcProvCertif": data["rfcProvCertif"],
      "selloSAT": data["selloSAT"],
      "estatus": data["estatus"],
    };
  }

}
