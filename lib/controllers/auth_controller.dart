import 'package:flutter/foundation.dart';

import '../models/auth_requests.dart';
import '../models/auth_result.dart';
import '../repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._repository);

  final AuthRepository _repository;
  bool isLoading = false;
  String? errorMessage;
  String? resetIdentifier;

  Future<AuthResult> login(LoginRequest request) =>
      _perform(() => _repository.login(request));

  Future<AuthResult> register(RegisterRequest request) =>
      _perform(() => _repository.register(request));

  Future<AuthResult> sendPasswordResetCode(String identifier) async {
    resetIdentifier = identifier.trim();
    return _perform(() => _repository.sendPasswordResetCode(identifier));
  }

  Future<AuthResult> resetPassword({
    required String code,
    required String newPassword,
  }) {
    final identifier = resetIdentifier;
    if (identifier == null || identifier.isEmpty) {
      return Future<AuthResult>.value(
        const AuthResult(
          success: false,
          message: 'انتهت جلسة الاستعادة؛ أعد طلب رمز التحقق.',
        ),
      );
    }
    return _perform(
      () => _repository.resetPassword(
        PasswordResetRequest(
          identifier: identifier,
          code: code,
          newPassword: newPassword,
        ),
      ),
    );
  }

  Future<AuthResult> _perform(Future<AuthResult> Function() action) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final result = await action();
      if (!result.success) errorMessage = result.message;
      return result;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
