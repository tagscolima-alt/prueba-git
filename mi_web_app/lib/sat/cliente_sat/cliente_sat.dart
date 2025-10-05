
import 'cliente_sat_api.dart';
import 'cliente_sat_models.dart';

class ClienteSAT {
  final ClienteSATApi api = ClienteSATApi();

  Future<void> probarFlujoCompleto() async {
    print('📡 Solicitando token...');
    final token = await api.solicitarToken(SolicitarTokenRequest(
      rfc: 'AAA010101AAA',
      password: '123456',
      certificado: 'MI_CERTIFICADO_PRUEBA',
    ));

    print('✅ Token recibido: ${token.accessToken}');

    print('🧾 Emitiendo CFDI...');
    final cfdi = await api.emitirCFDI(EmitirCfdiRequest(
      rfcEmisor: 'AAA010101AAA',
      rfcReceptor: 'BBB010101BBB',
      total: 1234.56,
      token: token.accessToken,
    ));

    print('✅ CFDI emitido: ${cfdi.uuid}');
  }
}
