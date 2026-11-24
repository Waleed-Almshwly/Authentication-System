import '../models/auth_requests.dart';
import '../models/auth_result.dart';

abstract interface class AuthRepository {
  Future<AuthResult> login(LoginRequest request);

  Future<AuthResult> register(RegisterRequest request);

  Future<AuthResult> sendPasswordResetCode(String identifier);

  Future<AuthResult> resetPassword(PasswordResetRequest request);
}
