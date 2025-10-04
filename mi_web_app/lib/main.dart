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
  String _resultado = "Presiona un botón para interactuar con el SAT.";
  String? _ultimoToken; // guarda el token actual

  // 🔴 Solicitar token
  Future<void> _solicitarTokenSAT() async {
    setState(() {
      _resultado = "Solicitando token al SAT...";
    });

    try {
      await ClienteSAT.obtenerTokenDemo();
      setState(() {
        _resultado = "✅ Token solicitado correctamente (ver consola).";
      });
      _ultimoToken = "ABC123XYZ"; // token simulado para el siguiente paso
    } catch (e) {
      setState(() {
        _resultado = "❌ Error al solicitar token: $e";
      });
    }
  }

  // 🟠 Renovar token
  Future<void> _renovarTokenSAT() async {
    if (_ultimoToken == null) {
      setState(() {
        _resultado = "⚠️ No hay token previo. Primero solicita uno.";
      });
      return;
    }

    setState(() {
      _resultado = "Renovando token...";
    });

    try {
      await ClienteSAT.renovarTokenDemo(_ultimoToken!);
      setState(() {
        _resultado = "🔁 Token renovado correctamente (ver consola).";
      });
      _ultimoToken = "NEW_TOKEN_456"; // token simulado para el siguiente paso
    } catch (e) {
      setState(() {
        _resultado = "❌ Error al renovar token: $e";
      });
    }
  }

  // 🧾 Validar CFDI
  Future<void> _validarCFDISAT() async {
    if (_ultimoToken == null) {
      setState(() {
        _resultado = "⚠️ No hay token activo. Solicita o renueva uno antes.";
      });
      return;
    }

    setState(() {
      _resultado = "Validando CFDI...";
    });

    try {
      await ClienteSAT.validarCFDIDemo(token: _ultimoToken!);
      setState(() {
        _resultado = "🧾 CFDI validado correctamente (ver consola).";
      });
    } catch (e) {
      setState(() {
        _resultado = "❌ Error al validar CFDI: $e";
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
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _renovarTokenSAT,
                icon: const Icon(Icons.refresh),
                label: const Text("Renovar Token"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _validarCFDISAT,
                icon: const Icon(Icons.receipt_long),
                label: const Text("Validar CFDI"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
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
