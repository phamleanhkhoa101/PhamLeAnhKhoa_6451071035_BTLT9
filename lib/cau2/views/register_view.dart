import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../utils/auth_snackbar.dart';
import '../widgets/auth_text_field.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({
    super.key,
    required this.controller,
  });

  final AuthController controller;

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.controller.register(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await widget.controller.logout();
      if (!mounted) {
        return;
      }
      AuthSnackBar.show(context, 'Dang ky thanh cong. Hay dang nhap de tiep tuc.');
      Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dang ky - 6451071035')),
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
                  const Icon(Icons.person_add_alt_1, size: 72),
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
                    textInputAction: TextInputAction.next,
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _confirmPasswordController,
                    label: 'Nhap lai mat khau',
                    icon: Icons.lock_reset,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _register(),
                    validator: _validateConfirmPassword,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Text(_isLoading ? 'Dang xu ly...' : 'Tao tai khoan'),
                      ),
                    ),
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

  String? _validateConfirmPassword(String? value) {
    if ((value ?? '').trim() != _passwordController.text.trim()) {
      return 'Mat khau nhap lai khong khop';
    }
    return _validatePassword(value);
  }
}
