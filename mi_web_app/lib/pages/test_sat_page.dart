// lib/pages/test_sat_page.dart
import 'package:flutter/material.dart';
import '../sat/cliente_sat/cliente_sat_api.dart';

class TestSatPage extends StatefulWidget {
  const TestSatPage({super.key});

  @override
  State<TestSatPage> createState() => _TestSatPageState();
}

class _TestSatPageState extends State<TestSatPage> {
  final api = ClienteSATApi();
  String resultado = 'Presiona el botón para listar CFDIs';

  Future<void> listar() async {
    setState(() => resultado = '⏳ Consultando CFDIs...');
    try {
      final lista = await api.listarCFDIs();
      setState(() => resultado = '✅ ${lista.length} CFDIs encontrados');
    } catch (e) {
      setState(() => resultado = '❌ Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba SAT API')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(resultado, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: listar,
              child: const Text('Listar CFDIs'),
            ),
          ],
        ),
      ),
    );
  }
}
