import '../models/auth_requests.dart';
import '../models/auth_result.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Map<String, UserModel> _usersByAcademicId = {};
  final Map<String, String> _pendingResetByIdentifier = {};

  @override
  Future<AuthResult> login(LoginRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    final identifier = request.identifier.trim().toLowerCase();
    UserModel? user;
    for (final candidate in _usersByAcademicId.values) {
      if (candidate.academicId == identifier ||
          candidate.email.toLowerCase() == identifier) {
        user = candidate;
        break;
      }
    }

    if (user == null || user.password != request.password) {
      return const AuthResult(
        success: false,
        message: 'المعرف أو كلمة المرور غير صحيحة.',
      );
    }
    return AuthResult(success: true, message: 'مرحباً ${user.fullName}');
  }

  @override
  Future<AuthResult> register(RegisterRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    final academicId = request.academicId.trim();
    final email = request.email.trim().toLowerCase();
    final duplicate = _usersByAcademicId.values.any(
      (user) =>
          user.academicId == academicId || user.email.toLowerCase() == email,
    );
    if (duplicate) {
      return const AuthResult(
        success: false,
        message: 'الرقم الأكاديمي أو البريد مسجل مسبقاً.',
      );
    }

    _usersByAcademicId[academicId] = UserModel(
      fullName: request.fullName.trim(),
      academicId: academicId,
      email: email,
      password: request.password,
    );
    return const AuthResult(success: true, message: 'تم إنشاء الحساب بنجاح.');
  }

  @override
  Future<AuthResult> sendPasswordResetCode(String identifier) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    final normalized = identifier.trim().toLowerCase();
    final account = _usersByAcademicId.values.where(
      (user) =>
          user.academicId == normalized || user.email.toLowerCase() == normalized,
    );
    if (account.isEmpty) {
      return const AuthResult(
        success: false,
        message: 'لم نعثر على حساب بهذا البريد أو الرقم الأكاديمي.',
      );
    }

    _pendingResetByIdentifier[normalized] = '123456';
    return const AuthResult(
      success: true,
      message: 'تم إرسال رمز التحقق التجريبي: 123456',
    );
  }

  @override
  Future<AuthResult> resetPassword(PasswordResetRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    final identifier = request.identifier.trim().toLowerCase();
    if (_pendingResetByIdentifier[identifier] != request.code) {
      return const AuthResult(
        success: false,
        message: 'رمز التحقق غير صحيح أو منتهي الصلاحية.',
      );
    }

    final entry = _usersByAcademicId.entries.firstWhere(
      (item) =>
          item.key == identifier ||
          item.value.email.toLowerCase() == identifier,
      orElse: () => const MapEntry('', UserModel(
        fullName: '',
        academicId: '',
        email: '',
        password: '',
      )),
    );
    if (entry.key.isEmpty) {
      return const AuthResult(
        success: false,
        message: 'الحساب غير متاح؛ أعد طلب رمز التحقق.',
      );
    }

    _usersByAcademicId[entry.key] = entry.value.copyWith(
      password: request.newPassword,
    );
    _pendingResetByIdentifier.remove(identifier);
    return const AuthResult(
      success: true,
      message: 'تم تحديث كلمة المرور بنجاح.',
    );
  }
}
