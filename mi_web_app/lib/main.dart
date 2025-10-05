import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ERP SAT',
      home: Scaffold(
        appBar: AppBar(title: const Text('ERP SAT - Inicio')),
        body: const Center(
          child: Text('Aplicación ERP SAT funcionando 🚀'),
        ),
      ),
    );
  }
}
