import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:authentication_system/controllers/auth_controller.dart';
import 'package:authentication_system/models/auth_requests.dart';
import 'package:authentication_system/repositories/auth_repository_impl.dart';
import 'package:authentication_system/utils/form_validators.dart';
import 'package:authentication_system/views/auth/login_page.dart';

void main() {
  group('FormValidators', () {
    test('validates login identifier and password requirements', () {
      expect(FormValidators.loginIdentifier(''), isNotNull);
      expect(FormValidators.loginIdentifier('ab'), isNotNull);
      expect(FormValidators.loginIdentifier('student123'), isNull);
      expect(FormValidators.loginIdentifier('bad@email'), isNotNull);
      expect(FormValidators.loginPassword('12345'), isNotNull);
      expect(FormValidators.loginPassword('123456'), isNull);
    });

    test('validates registration and password reset requirements', () {
      expect(FormValidators.academicId('12345678'), isNotNull);
      expect(FormValidators.academicId('123456789'), isNull);
      expect(FormValidators.academicId('12345678x'), isNotNull);
      expect(FormValidators.email('student@university.edu'), isNull);
      expect(FormValidators.email('not-an-email'), isNotNull);
      expect(FormValidators.strongPassword('password1'), isNotNull);
      expect(FormValidators.strongPassword('Password1'), isNull);
      expect(
        FormValidators.confirmPassword('Password2', 'Password1'),
        isNotNull,
      );
      expect(FormValidators.otp('12345'), isNotNull);
      expect(FormValidators.otp('123456'), isNull);
    });
  });

  testWidgets('login page exposes the required auth entry points', (
    tester,
  ) async {
    final controller = AuthController(AuthRepositoryImpl());
    await tester.pumpWidget(
      MaterialApp(home: LoginPage(controller: controller)),
    );

    expect(find.text('تسجيل الدخول'), findsWidgets);
    expect(find.text('نسيت كلمة المرور؟'), findsOneWidget);
    expect(find.text('إنشاء حساب جديد'), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);
  });

  test(
    'repository supports account creation, login, and password reset',
    () async {
      final repository = AuthRepositoryImpl();
      const registration = RegisterRequest(
        fullName: 'طالب تجريبي',
        academicId: '123456789',
        email: 'student@university.edu',
        password: 'Password1',
      );

      expect((await repository.register(registration)).success, isTrue);
      expect(
        (await repository.login(
          const LoginRequest(
            identifier: '123456789',
            password: 'Password1',
            rememberMe: false,
          ),
        )).success,
        isTrue,
      );
      expect(
        (await repository.sendPasswordResetCode(
          'student@university.edu',
        )).success,
        isTrue,
      );
      expect(
        (await repository.resetPassword(
          const PasswordResetRequest(
            identifier: 'student@university.edu',
            code: '123456',
            newPassword: 'Newpass2',
          ),
        )).success,
        isTrue,
      );
      expect(
        (await repository.login(
          const LoginRequest(
            identifier: 'student@university.edu',
            password: 'Newpass2',
            rememberMe: true,
          ),
        )).success,
        isTrue,
      );
    },
  );
}
