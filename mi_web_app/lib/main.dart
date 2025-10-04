import 'package:flutter/material.dart';
import 'sat/cliente_sat_api.dart'; // usamos directamente la API

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
  String? _ultimoToken; // para guardar el último token obtenido

  // 🔴 Solicitar token inicial
  Future<void> _solicitarTokenSAT() async {
    setState(() {
      _resultado = "Solicitando token al SAT...";
    });

    try {
      final tokenResponse = await ClienteSATAPI.solicitarToken(
        rfc: "AAA010101AAA",
        password: "123456",
        certificado: "BASE64_CERT",
      );

      setState(() {
        _ultimoToken = tokenResponse["access_token"];
        _resultado = "✅ Token obtenido correctamente:\n"
            "Access Token: ${tokenResponse['access_token']}\n"
            "Tipo: ${tokenResponse['token_type']}\n"
            "Expira en: ${tokenResponse['expires_in']} segundos";
      });
    } catch (e) {
      setState(() {
        _resultado = "❌ Error al solicitar token: $e";
      });
    }
  }

  // 🟠 Renovar token existente
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
      final tokenResponse = await ClienteSATAPI.renovarToken(
        refreshToken: _ultimoToken!,
      );

      setState(() {
        _ultimoToken = tokenResponse["access_token"];
        _resultado = "🔁 Token renovado correctamente:\n"
            "Access Token: ${tokenResponse['access_token']}\n"
            "Tipo: ${tokenResponse['token_type']}\n"
            "Expira en: ${tokenResponse['expires_in']} segundos";
      });
    } catch (e) {
      setState(() {
        _resultado = "❌ Error al renovar token: $e";
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
            ],
          ),
        ),
      ),
    );
  }
}
