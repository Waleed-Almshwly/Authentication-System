import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key, required this.controller});

  final AuthController controller;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    final result = await widget.controller.resetPassword(
      code: _otpController.text,
      newPassword: _passwordController.text,
    );
    if (!mounted) return;
    if (!result.success) {
      showAuthMessage(context, result.message);
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.check_circle_outline, color: Color(0xFF16804A)),
        title: const Text('تم تحديث كلمة المرور'),
        content: const Text('يمكنك الآن تسجيل الدخول باستخدام كلمة المرور الجديدة.'),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
    widget.controller.resetIdentifier = null;
  }

  @override
  Widget build(BuildContext context) => AuthPage(
    title: 'تعيين كلمة مرور جديدة',
    subtitle: 'أدخل رمز التحقق واختر كلمة مرور آمنة',
    icon: Icons.password_rounded,
    children: [
      Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthField(
              controller: _otpController,
              label: 'رمز التحقق (6 أرقام)',
              icon: Icons.pin_outlined,
              validator: FormValidators.otp,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              maxLength: 6,
            ),
            AuthField(
              controller: _passwordController,
              label: 'كلمة المرور الجديدة',
              icon: Icons.lock_outline_rounded,
              validator: FormValidators.strongPassword,
              obscureText: _obscurePassword,
              textDirection: TextDirection.ltr,
              suffix: IconButton(
                tooltip: _obscurePassword ? 'إظهار كلمة المرور' : 'إخفاء كلمة المرور',
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
            AuthField(
              controller: _confirmController,
              label: 'تأكيد كلمة المرور الجديدة',
              icon: Icons.lock_reset_rounded,
              validator: (value) =>
                  FormValidators.confirmPassword(value, _passwordController.text),
              obscureText: _obscureConfirmation,
              textDirection: TextDirection.ltr,
              suffix: IconButton(
                tooltip: _obscureConfirmation
                    ? 'إظهار كلمة المرور'
                    : 'إخفاء كلمة المرور',
                onPressed: () => setState(
                  () => _obscureConfirmation = !_obscureConfirmation,
                ),
                icon: Icon(
                  _obscureConfirmation
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: widget.controller,
              builder: (context, _) => AuthSubmitButton(
                label: 'تحديث كلمة المرور',
                isLoading: widget.controller.isLoading,
                onPressed: _resetPassword,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
