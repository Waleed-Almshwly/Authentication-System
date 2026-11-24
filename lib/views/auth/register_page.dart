import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../models/auth_requests.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.controller});

  final AuthController controller;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _academicIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _acceptedTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;

  @override
  void dispose() {
    _nameController.dispose();
    _academicIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final result = await widget.controller.register(
      RegisterRequest(
        fullName: _nameController.text,
        academicId: _academicIdController.text,
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
    if (!mounted) return;
    showAuthMessage(context, result.message, success: result.success);
    if (result.success) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => AuthPage(
    title: 'إنشاء حساب طالب',
    subtitle: 'أدخل بياناتك الأكاديمية لإنشاء حساب جديد',
    icon: Icons.person_add_alt_1_rounded,
    children: [
      Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthField(
              controller: _nameController,
              label: 'الاسم الكامل',
              icon: Icons.badge_outlined,
              validator: FormValidators.fullName,
              textDirection: TextDirection.rtl,
            ),
            AuthField(
              controller: _academicIdController,
              label: 'الرقم الأكاديمي',
              icon: Icons.numbers_rounded,
              validator: FormValidators.academicId,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              maxLength: 10,
            ),
            AuthField(
              controller: _emailController,
              label: 'البريد الجامعي',
              icon: Icons.alternate_email_rounded,
              validator: FormValidators.email,
              keyboardType: TextInputType.emailAddress,
              textDirection: TextDirection.ltr,
            ),
            AuthField(
              controller: _passwordController,
              label: 'كلمة المرور',
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
              label: 'تأكيد كلمة المرور',
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
            FormField<bool>(
              initialValue: _acceptedTerms,
              validator: (value) =>
                  FormValidators.termsAccepted(value ?? false),
              builder: (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    value: field.value ?? false,
                    onChanged: (value) {
                      field.didChange(value ?? false);
                      setState(() => _acceptedTerms = value ?? false);
                    },
                    title: const Text(
                      'أوافق على اللوائح والشروط الأكاديمية',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  if (field.hasError)
                    Padding(
                      padding: const EdgeInsets.only(right: 12, bottom: 10),
                      child: Text(
                        field.errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AnimatedBuilder(
              animation: widget.controller,
              builder: (context, _) => AuthSubmitButton(
                label: 'إنشاء الحساب',
                isLoading: widget.controller.isLoading,
                onPressed: _register,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
