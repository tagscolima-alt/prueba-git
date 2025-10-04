// lib/main.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'sat/cliente_sat_api.dart';

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
  Map<String, dynamic>? _datos;
  String? _ultimoToken;

  // 🔴 Solicitar token
  Future<void> _solicitarTokenSAT() async {
    setState(() {
      _resultado = "Solicitando token al SAT...";
      _datos = null;
    });

    try {
      final response = await ClienteSATAPI.solicitarToken(
        rfc: "AAA010101AAA",
        password: "123456",
        certificado: "BASE64_CERT",
      );

      setState(() {
        _resultado = "✅ Token solicitado correctamente.";
        _datos = response;
        _ultimoToken = response["access_token"];
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
      final response = await ClienteSATAPI.renovarToken(
        refreshToken: _ultimoToken!,
      );

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
        total: 1000.00,
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

  // 🟢 Emitir CFDI (Timbrado)
  Future<void> _emitirCFDISAT() async {
    if (_ultimoToken == null) {
      setState(() {
        _resultado = "⚠️ No hay token activo. Solicita o renueva uno antes.";
      });
      return;
    }

    setState(() {
      _resultado = "Enviando CFDI al SAT...";
      _datos = null;
    });

    try {
      final response = await ClienteSATAPI.emitirCFDI(
        xmlFirmado: "<Comprobante>...</Comprobante>",
        token: _ultimoToken!,
      );

      setState(() {
        _resultado = "✅ CFDI emitido correctamente (Timbrado).";
        _datos = response;
      });
    } catch (e) {
      setState(() {
        _resultado = "❌ Error al emitir CFDI: $e";
      });
    }
  }

  // ❌ Cancelar CFDI
  Future<void> _cancelarCFDISAT() async {
    if (_ultimoToken == null) {
      setState(() {
        _resultado = "⚠️ No hay token activo. Solicita o renueva uno antes.";
      });
      return;
    }

    setState(() {
      _resultado = "Cancelando CFDI...";
      _datos = null;
    });

    try {
      final response = await ClienteSATAPI.cancelarCFDI(
        uuid: "123e4567-e89b-12d3-a456-426614174000",
        token: _ultimoToken!,
      );

      setState(() {
        _resultado = "❌ CFDI cancelado correctamente.";
        _datos = response;
      });
    } catch (e) {
      setState(() {
        _resultado = "🚫 Error al cancelar CFDI: $e";
      });
    }
  }

  // 🎨 Mostrar datos JSON formateados
  Widget _mostrarDatos() {
    if (_datos == null) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Text(
        const JsonEncoder.withIndent('  ').convert(_datos),
        style: const TextStyle(fontFamily: 'Courier', fontSize: 14),
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
              _mostrarDatos(),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _solicitarTokenSAT,
                icon: const Icon(Icons.cloud),
                label: const Text("Solicitar Token al SAT"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _emitirCFDISAT,
                icon: const Icon(Icons.send),
                label: const Text("Emitir CFDI (Timbrado)"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _cancelarCFDISAT,
                icon: const Icon(Icons.cancel),
                label: const Text("Cancelar CFDI"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
