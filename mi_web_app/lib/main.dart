import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login_page.dart';
import 'pages/sat_dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> verificarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ERP SAT Demo',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: verificarSesion(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.data! ? const SatDashboardPage() : const LoginPage();
        },
      ),
    );
  }
}
