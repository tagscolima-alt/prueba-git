import 'package:flutter/material.dart';
import 'sat/cliente_sat.dart'; // Importa tu módulo SAT

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cliente SAT Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SATDemoPage(),
    );
  }
}

class SATDemoPage extends StatefulWidget {
  const SATDemoPage({super.key});

  @override
  State<SATDemoPage> createState() => _SATDemoPageState();
}

class _SATDemoPageState extends State<SATDemoPage> {
  String _resultado = "Presiona el botón para solicitar token.";

  Future<void> _solicitarTokenSAT() async {
    setState(() {
      _resultado = "Solicitando token al SAT...";
    });

    try {
      await ClienteSAT.obtenerTokenDemo();
      setState(() {
        _resultado =
            "✅ Token obtenido correctamente. Revisa la consola para detalles.";
      });
    } catch (e) {
      setState(() {
        _resultado = "❌ Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Cliente SAT'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _resultado,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _solicitarTokenSAT,
                icon: const Icon(Icons.cloud),
                label: const Text("Solicitar Token al SAT"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
