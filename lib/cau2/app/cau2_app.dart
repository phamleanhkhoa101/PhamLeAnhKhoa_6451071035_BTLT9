import 'package:flutter/material.dart';

import '../views/auth_gate_view.dart';

class Cau2App extends StatelessWidget {
  const Cau2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Authentication App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const AuthGateView(),
    );
  }
}
