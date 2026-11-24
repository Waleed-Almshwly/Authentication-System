import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';
import 'reset_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key, required this.controller});

  final AuthController controller;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) return;
    final result = await widget.controller.sendPasswordResetCode(
      _identifierController.text,
    );
    if (!mounted) return;
    showAuthMessage(context, result.message, success: result.success);
    if (result.success) {
      await Future<void>.delayed(const Duration(milliseconds: 350));
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ResetPasswordPage(controller: widget.controller),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => AuthPage(
    title: 'استعادة كلمة المرور',
    subtitle: 'لا تقلق، سنساعدك على استعادة إمكانية الدخول',
    icon: Icons.mark_email_read_outlined,
    children: [
      Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF5F7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline_rounded, color: authPrimary),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'أدخل بريدك الجامعي أو رقمك الأكاديمي. سنرسل إليك رمز تحقق صالحاً لإعادة تعيين كلمة المرور.',
              ),
            ),
          ],
        ),
      ),
      Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthField(
              controller: _identifierController,
              label: 'البريد الجامعي أو الرقم الأكاديمي',
              icon: Icons.person_outline_rounded,
              validator: FormValidators.resetIdentifier,
              keyboardType: TextInputType.emailAddress,
              textDirection: TextDirection.ltr,
            ),
            AnimatedBuilder(
              animation: widget.controller,
              builder: (context, _) => AuthSubmitButton(
                label: 'إرسال رمز التحقق',
                isLoading: widget.controller.isLoading,
                onPressed: _sendCode,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      TextButton.icon(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_forward_rounded),
        label: const Text('العودة إلى تسجيل الدخول'),
      ),
    ],
  );
}
