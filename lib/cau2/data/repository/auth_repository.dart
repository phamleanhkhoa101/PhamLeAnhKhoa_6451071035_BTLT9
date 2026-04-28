import '../models/auth_user_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  AuthRepository({AuthService? service}) : _service = service ?? AuthService();

  final AuthService _service;

  Stream<AuthUserModel?> authStateChanges() => _service.authStateChanges();

  AuthUserModel? get currentUser => _service.currentUser;

  Future<void> register({
    required String email,
    required String password,
  }) {
    return _service.signUp(email: email, password: password);
  }

  Future<void> login({
    required String email,
    required String password,
  }) {
    return _service.signIn(email: email, password: password);
  }

  Future<void> logout() => _service.signOut();
}
