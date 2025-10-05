import 'package:flutter/material.dart';
import 'services/sat_api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ERP SAT Demo',
      debugShowCheckedModeBanner: false,
      home: const SatTestScreen(),
    );
  }
}

class SatTestScreen extends StatefulWidget {
  const SatTestScreen({super.key});

  @override
  State<SatTestScreen> createState() => _SatTestScreenState();
}

class _SatTestScreenState extends State<SatTestScreen> {
  String resultado = 'Presiona el botón para probar conexión';

  Future<void> _probarConexion() async {
    setState(() => resultado = '⏳ Probando conexión...');
    try {
      final datos = await SatApiService.probarConexionBD();
      setState(() => resultado = '''
✅ Conexión: ${datos['conexion']}
🧠 Base: ${datos['baseDatos']}
👤 Usuario: ${datos['usuario']}
🕒 Hora servidor: ${datos['horaServidor']}
''');
    } catch (e) {
      setState(() => resultado = '❌ Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba de conexión SAT')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                resultado,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _probarConexion,
                child: const Text('Probar conexión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
