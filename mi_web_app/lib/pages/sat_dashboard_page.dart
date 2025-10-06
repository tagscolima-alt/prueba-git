import 'package:flutter/material.dart';
import '../sat/cliente_sat/cliente_sat_api.dart';
import '../sat/cliente_sat/cliente_sat_models.dart';

class SatDashboardPage extends StatefulWidget {
  const SatDashboardPage({super.key});

  @override
  State<SatDashboardPage> createState() => _SatDashboardPageState();
}

class _SatDashboardPageState extends State<SatDashboardPage> {
  final api = ClienteSATApi();

  String resultado = "Selecciona una acción para interactuar con el SAT";
  String? tokenActual;

  Future<void> solicitarToken() async {
    setState(() => resultado = '🔑 Solicitando token...');
    try {
      final request = SolicitarTokenRequest(
        rfc: "XAXX010101000", // 🔸 Ejemplo, luego lo harás dinámico desde login
        password: "123456",
        certificado: "CERT123",
      );
      final token = await api.solicitarToken(request);
      setState(() {
        tokenActual = token.accessToken;
        resultado = '''
✅ Token obtenido:
🔹 Token: ${token.accessToken}
⏳ Expira en: ${token.expiresIn}s
''';
      });
    } catch (e) {
      setState(() => resultado = '❌ Error al solicitar token: $e');
    }
  }

  Future<void> emitirCfdi() async {
    if (tokenActual == null) {
      setState(() => resultado = '⚠️ Primero solicita un token válido');
      return;
    }

    setState(() => resultado = '🧾 Emitiendo CFDI...');
    try {
      final request = EmitirCfdiRequest(
        rfcEmisor: "AAA010101AAA",
        rfcReceptor: "BBB010101BBB",
        total: 1200.50,
        token: tokenActual!,
      );
      final cfdi = await api.emitirCFDI(request);
      setState(() {
        resultado = '''
✅ CFDI emitido:
🆔 UUID: ${cfdi.uuid}
📅 Fecha: ${cfdi.fechaTimbrado}
📦 Estatus: ${cfdi.estatus}
''';
      });
    } catch (e) {
      setState(() => resultado = '❌ Error al emitir CFDI: $e');
    }
  }

  Future<void> listarCfdis() async {
    setState(() => resultado = '📋 Consultando CFDIs...');
    try {
      final lista = await api.listarCFDIs();
      setState(() {
        resultado = '✅ CFDIs encontrados: ${lista.length}\n\n';
        for (var cfdi in lista.take(5)) {
          resultado +=
              '🧾 ${cfdi.uuid} — ${cfdi.estatus} — ${cfdi.fechaTimbrado}\n';
        }
      });
    } catch (e) {
      setState(() => resultado = '❌ Error al listar CFDIs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ERP-SAT - ClienteSAT')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(resultado, textAlign: TextAlign.left),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: solicitarToken,
              icon: const Icon(Icons.vpn_key),
              label: const Text('Solicitar Token SAT'),
            ),
            ElevatedButton.icon(
              onPressed: emitirCfdi,
              icon: const Icon(Icons.receipt_long),
              label: const Text('Emitir CFDI'),
            ),
            ElevatedButton.icon(
              onPressed: listarCfdis,
              icon: const Icon(Icons.list_alt),
              label: const Text('Listar CFDIs'),
            ),
          ],
        ),
      ),
    );
  }
}
