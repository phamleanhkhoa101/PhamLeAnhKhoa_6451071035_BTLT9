import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/auth_user_model.dart';

class AuthService {
  AuthService({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  Stream<AuthUserModel?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(_mapUser);
  }

  AuthUserModel? get currentUser => _mapUser(_firebaseAuth.currentUser);

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    await _runWithTimeout(
      () => _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ),
      actionName: 'dang ky',
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _runWithTimeout(
      () => _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
      actionName: 'dang nhap',
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  AuthUserModel? _mapUser(User? user) {
    if (user == null || user.email == null) {
      return null;
    }

    return AuthUserModel(
      uid: user.uid,
      email: user.email!,
    );
  }

  Future<void> _runWithTimeout(
    Future<UserCredential> Function() action, {
    required String actionName,
  }) async {
    try {
      await action().timeout(const Duration(seconds: 15));
    } on FirebaseAuthException catch (error) {
      debugPrint(
        'FirebaseAuth error [$actionName]: ${error.code} - ${error.message}',
      );
      throw Exception(_mapAuthError(error));
    } on TimeoutException {
      throw Exception(
        'Ket noi Firebase bi qua thoi gian. Hay kiem tra mang va cau hinh Authentication.',
      );
    } catch (error) {
      debugPrint('Unexpected auth error [$actionName]: $error');
      rethrow;
    }
  }

  String _mapAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'Email nay da duoc dang ky.';
      case 'invalid-email':
        return 'Email khong dung dinh dang.';
      case 'weak-password':
        return 'Mat khau qua yeu. Hay nhap it nhat 6 ky tu.';
      case 'user-not-found':
        return 'Khong tim thay tai khoan voi email nay.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email hoac mat khau khong dung.';
      case 'too-many-requests':
        return 'Ban thu qua nhieu lan. Hay doi mot luc roi thu lai.';
      case 'network-request-failed':
        return 'Khong co ket noi mang den Firebase.';
      case 'operation-not-allowed':
        return 'Email/Password Authentication chua duoc bat trong Firebase Console.';
      default:
        return error.message ?? 'Da xay ra loi xac thuc.';
    }
  }
}
