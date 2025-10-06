import 'package:flutter/material.dart';
import '../sat/cliente_sat/cliente_sat_api.dart';
import '../sat/cliente_sat/cliente_sat_models.dart';
import '../sat/cliente_sat/cliente_sat_cancelar.dart'; // 👈 Import añadido

class SatDashboardPage extends StatefulWidget {
  const SatDashboardPage({super.key});

  @override
  State<SatDashboardPage> createState() => _SatDashboardPageState();
}

class _SatDashboardPageState extends State<SatDashboardPage> {
  final api = ClienteSATApi();

  String resultado = "Selecciona una acción para interactuar con el SAT";
  String? tokenActual;

  // 🔑 Solicitar Token SAT
  Future<void> solicitarToken() async {
    setState(() => resultado = '🔑 Solicitando token...');
    try {
      final request = SolicitarTokenRequest(
        rfc: "XAXX010101000",
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

  // 🧾 Emitir CFDI
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

  // 📋 Listar CFDIs
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

  // ❌ Cancelar CFDI
  Future<void> cancelarCfdi() async {
    final TextEditingController uuidCtrl = TextEditingController();
    final TextEditingController motivoCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancelar CFDI'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: uuidCtrl,
                decoration: const InputDecoration(labelText: 'UUID del CFDI'),
              ),
              TextField(
                controller: motivoCtrl,
                decoration:
                    const InputDecoration(labelText: 'Motivo de cancelación'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                setState(() => resultado = '⏳ Cancelando CFDI...');
                try {
                  final cancelarApi = ClienteSATCancelar();
                  final r = await cancelarApi.cancelarCFDI(
                    uuidCtrl.text.trim(),
                    motivoCtrl.text.trim(),
                  );
                  // ✅ Actualizar automáticamente la lista tras cancelación
                  final lista = await api.listarCFDIs();
                  setState(() => resultado = '''
✅ ${r['mensaje']}
🧾 UUID: ${r['uuid']}
📅 Fecha: ${r['fechaCancelacion']}
📦 Estatus: ${r['estatus']}
💬 Motivo: ${r['motivo']}

📋 CFDIs actuales (${lista.length}):
${lista.take(5).map((c) => "• ${c.uuid} — ${c.estatus}").join("\n")}
''');
                } catch (e) {
                  setState(() => resultado = '❌ Error al cancelar CFDI: $e');
                }
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
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
            ElevatedButton.icon(
              onPressed: cancelarCfdi,
              icon: const Icon(Icons.cancel_outlined),
              label: const Text('Cancelar CFDI'),
            ),
          ],
        ),
      ),
    );
  }
}

