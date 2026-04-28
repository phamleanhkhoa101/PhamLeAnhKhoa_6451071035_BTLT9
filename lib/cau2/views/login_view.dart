import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../utils/auth_snackbar.dart';
import '../widgets/auth_text_field.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    super.key,
    required this.controller,
  });

  final AuthController controller;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.controller.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      AuthSnackBar.show(context, error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _openRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RegisterView(controller: widget.controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dang nhap - 6451071035')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_outline, size: 72),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _passwordController,
                    label: 'Mat khau',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _login(),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Text(_isLoading ? 'Dang xu ly...' : 'Dang nhap'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _openRegister,
                    child: const Text('Chua co tai khoan? Dang ky'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Vui long nhap email';
    }
    if (!email.contains('@') || !email.contains('.')) {
      return 'Email khong hop le';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final password = value?.trim() ?? '';
    if (password.isEmpty) {
      return 'Vui long nhap mat khau';
    }
    if (password.length < 6) {
      return 'Mat khau phai tu 6 ky tu tro len';
    }
    return null;
  }
}
