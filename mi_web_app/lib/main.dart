// lib/main.dart
import 'package:flutter/material.dart';
import 'sat/cliente_sat.dart'; // Importa tu módulo SAT
import 'sat/cliente_sat_api.dart'; // Necesario para las llamadas directas

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
        useMaterial3: true,
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
  Map<String, dynamic>? _datos; // 🔹 Aquí guardamos la respuesta JSON
  String? _ultimoToken; // guarda el token actual

  // 🔴 Solicitar token
  Future<void> _solicitarTokenSAT() async {
    setState(() {
      _resultado = "Solicitando token al SAT...";
      _datos = null;
    });

    try {
      final tokenResponse = await ClienteSATAPI.solicitarToken(
        rfc: "AAA010101AAA",
        password: "123456",
        certificado: "BASE64_CERT",
      );

      setState(() {
        _resultado = "✅ Token obtenido correctamente.";
        _datos = tokenResponse;
        _ultimoToken = tokenResponse["access_token"];
      });
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
      _datos = null;
    });

    try {
      final response =
          await ClienteSATAPI.renovarToken(refreshToken: _ultimoToken!);
      setState(() {
        _resultado = "🔁 Token renovado correctamente.";
        _datos = response;
        _ultimoToken = response["access_token"];
      });
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
      _datos = null;
    });

    try {
      final response = await ClienteSATAPI.validarCFDI(
        rfcEmisor: "AAA010101AAA",
        rfcReceptor: "BBB010101BBB",
        uuid: "123e4567-e89b-12d3-a456-426614174000",
        total: 1234.56,
        token: _ultimoToken!,
      );

      setState(() {
        _resultado = "🧾 CFDI validado correctamente.";
        _datos = response;
      });
    } catch (e) {
      setState(() {
        _resultado = "❌ Error al validar CFDI: $e";
      });
    }
  }

  // 🔹 Widget para mostrar datos JSON en pantalla
  Widget _buildJsonViewer() {
    if (_datos == null) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _datos!.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              "${entry.key}: ${entry.value}",
              style: const TextStyle(fontSize: 16, fontFamily: "Courier"),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Cliente SAT'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _resultado,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              _buildJsonViewer(),
              const SizedBox(height: 30),
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
