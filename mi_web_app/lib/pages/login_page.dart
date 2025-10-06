import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'sat_dashboard_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  String resultado = '';

  Future<void> _login() async {
    setState(() => resultado = '⏳ Iniciando sesión...');
    try {
      final res = await AuthService.login(emailCtrl.text, passCtrl.text);
      final token = res['token'];
      if (token != null) {
        setState(() => resultado = '✅ Sesión iniciada correctamente');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SatDashboardPage()),
        );
      } else {
        setState(() => resultado = '⚠️ No se recibió token');
      }
    } catch (e) {
      setState(() => resultado = '❌ Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login ERP-SAT')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailCtrl,
              decoration:
                  const InputDecoration(labelText: 'Correo electrónico'),
            ),
            TextField(
              controller: passCtrl,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Iniciar sesión'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                );
              },
              child: const Text('¿No tienes cuenta? Regístrate'),
            ),
            const SizedBox(height: 10),
            Text(resultado),
          ],
        ),
      ),
    );
  }
}
