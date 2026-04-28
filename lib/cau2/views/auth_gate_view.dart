import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../data/models/auth_user_model.dart';
import 'home_view.dart';
import 'login_view.dart';

class AuthGateView extends StatefulWidget {
  const AuthGateView({super.key});

  @override
  State<AuthGateView> createState() => _AuthGateViewState();
}

class _AuthGateViewState extends State<AuthGateView> {
  final AuthController _controller = AuthController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthUserModel?>(
      stream: _controller.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user != null) {
          return HomeView(
            controller: _controller,
            user: user,
          );
        }

        return LoginView(controller: _controller);
      },
    );
  }
}
