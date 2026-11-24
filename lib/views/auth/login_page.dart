import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../models/auth_requests.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.controller});

  final AuthController controller;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final result = await widget.controller.login(
      LoginRequest(
        identifier: _identifierController.text,
        password: _passwordController.text,
        rememberMe: _rememberMe,
      ),
    );
    if (!mounted) return;
    showAuthMessage(context, result.message, success: result.success);
  }

  @override
  Widget build(BuildContext context) => AuthPage(
    title: 'تسجيل الدخول',
    subtitle: 'سجّل الدخول للوصول إلى خدماتك الأكاديمية',
    icon: Icons.login_rounded,
    children: [
      Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthField(
              controller: _identifierController,
              label: 'البريد الجامعي أو الرقم الأكاديمي',
              icon: Icons.person_outline_rounded,
              validator: FormValidators.loginIdentifier,
              keyboardType: TextInputType.emailAddress,
              textDirection: TextDirection.ltr,
            ),
            AuthField(
              controller: _passwordController,
              label: 'كلمة المرور',
              icon: Icons.lock_outline_rounded,
              validator: FormValidators.loginPassword,
              obscureText: _obscurePassword,
              suffix: IconButton(
                tooltip: _obscurePassword
                    ? 'إظهار كلمة المرور'
                    : 'إخفاء كلمة المرور',
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
              ),
              textDirection: TextDirection.ltr,
            ),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) =>
                      setState(() => _rememberMe = value ?? false),
                ),
                const Text('تذكرني'),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          ForgotPasswordPage(controller: widget.controller),
                    ),
                  ),
                  child: const Text('نسيت كلمة المرور؟'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            AnimatedBuilder(
              animation: widget.controller,
              builder: (context, _) => AuthSubmitButton(
                label: 'تسجيل الدخول',
                isLoading: widget.controller.isLoading,
                onPressed: _login,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text('ليس لديك حساب؟'),
          TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => RegisterPage(controller: widget.controller),
              ),
            ),
            child: const Text('إنشاء حساب جديد'),
          ),
        ],
      ),
    ],
  );
}
