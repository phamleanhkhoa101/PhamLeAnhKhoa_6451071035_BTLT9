import '../data/models/auth_user_model.dart';
import '../data/repository/auth_repository.dart';

class AuthController {
  AuthController({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  final AuthRepository _repository;

  Stream<AuthUserModel?> authStateChanges() => _repository.authStateChanges();

  AuthUserModel? get currentUser => _repository.currentUser;

  Future<void> register({
    required String email,
    required String password,
  }) async {
    await _repository.register(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _repository.login(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<void> logout() => _repository.logout();
}
