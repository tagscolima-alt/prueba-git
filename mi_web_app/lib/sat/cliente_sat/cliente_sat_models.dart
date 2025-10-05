class SolicitarTokenRequest {
  final String rfc;
  final String password;
  final String certificado;

  SolicitarTokenRequest(
      {required this.rfc, required this.password, required this.certificado});

  Map<String, dynamic> toJson() =>
      {'rfc': rfc, 'password': password, 'certificado': certificado};
}

class TokenResponse {
  final String accessToken;
  final String tokenType;
  final int expiresIn;

  TokenResponse(
      {required this.accessToken,
      required this.tokenType,
      required this.expiresIn});

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      TokenResponse(
          accessToken: json['access_token'],
          tokenType: json['token_type'],
          expiresIn: json['expires_in']);
}

class EmitirCfdiRequest {
  final String rfcEmisor;
  final String rfcReceptor;
  final double total;
  final String token;

  EmitirCfdiRequest(
      {required this.rfcEmisor,
      required this.rfcReceptor,
      required this.total,
      required this.token});

  Map<String, dynamic> toJson() =>
      {'rfcEmisor': rfcEmisor, 'rfcReceptor': rfcReceptor, 'total': total, 'token': token};
}

class EmitirCfdiResponse {
  final String uuid;
  final String estatus;
  final String fechaTimbrado;

  EmitirCfdiResponse(
      {required this.uuid,
      required this.estatus,
      required this.fechaTimbrado});

  factory EmitirCfdiResponse.fromJson(Map<String, dynamic> json) =>
      EmitirCfdiResponse(
          uuid: json['uuid'],
          estatus: json['estatus'],
          fechaTimbrado: json['fechaTimbrado']);
}
