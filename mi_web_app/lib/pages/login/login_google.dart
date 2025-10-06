import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginGoogleButton extends StatelessWidget {
  const LoginGoogleButton({super.key});

  Future<void> _iniciarSesionConGoogle() async {
    final Uri url = Uri.parse('http://localhost:3000/api/auth/google');

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication, // 👈 muy importante
    )) {
      throw Exception('No se pudo abrir el flujo de Google OAuth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _iniciarSesionConGoogle,
      icon: const Icon(Icons.login),
      label: const Text('Iniciar sesión con Google'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}
