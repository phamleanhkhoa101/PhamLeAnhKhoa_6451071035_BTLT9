import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../data/models/auth_user_model.dart';
import '../utils/auth_snackbar.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
    required this.controller,
    required this.user,
  });

  final AuthController controller;
  final AuthUserModel user;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _isLoggingOut = false;

  Future<void> _logout() async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      await widget.controller.logout();
    } catch (error) {
      if (!mounted) {
        return;
      }
      AuthSnackBar.show(context, error.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home - 6451071035'),
        actions: [
          IconButton(
            onPressed: _isLoggingOut ? null : _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Dang xuat',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified_user, size: 72),
              const SizedBox(height: 16),
              const Text(
                'Dang nhap thanh cong',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Email hien tai: ${widget.user.email}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _isLoggingOut ? null : _logout,
                icon: const Icon(Icons.logout),
                label: Text(_isLoggingOut ? 'Dang xu ly...' : 'Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
