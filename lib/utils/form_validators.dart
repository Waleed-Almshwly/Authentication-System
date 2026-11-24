class FormValidators {
  FormValidators._();

  static final RegExp _emailPattern = RegExp(
    r"^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?(?:\.[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?)+$",
  );
  static final RegExp _digitsPattern = RegExp(r'^\d+$');
  static final RegExp _uppercasePattern = RegExp(r'[A-Z]');
  static final RegExp _numberPattern = RegExp(r'\d');

  static String? loginIdentifier(String? value) {
    final identifier = value?.trim() ?? '';
    if (identifier.isEmpty) return 'أدخل البريد أو الرقم الأكاديمي.';
    if (identifier.length < 5) return 'يجب ألا يقل المعرف عن 5 خانات.';
    if (identifier.contains('@') && !_emailPattern.hasMatch(identifier)) {
      return 'أدخل بريداً إلكترونياً صحيحاً.';
    }
    return null;
  }

  static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) return 'أدخل كلمة المرور.';
    if (value.length < 6) return 'يجب ألا تقل كلمة المرور عن 6 محارف.';
    return null;
  }

  static String? fullName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'أدخل الاسم الكامل.';
    if (name.length < 3) return 'يجب ألا يقل الاسم عن 3 محارف.';
    return null;
  }

  static String? academicId(String? value) {
    final id = value?.trim() ?? '';
    if (id.isEmpty) return 'أدخل الرقم الأكاديمي.';
    if (!_digitsPattern.hasMatch(id)) return 'استخدم الأرقام فقط.';
    if (id.length < 9 || id.length > 10) {
      return 'يجب أن يتكون الرقم الأكاديمي من 9 أو 10 خانات.';
    }
    return null;
  }

  static String? email(String? value) {
    final address = value?.trim() ?? '';
    if (address.isEmpty) return 'أدخل البريد الجامعي.';
    if (!_emailPattern.hasMatch(address)) return 'أدخل بريداً إلكترونياً صحيحاً.';
    return null;
  }

  static String? strongPassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'أدخل كلمة المرور.';
    if (password.length < 8) return 'يجب ألا تقل كلمة المرور عن 8 محارف.';
    if (!_uppercasePattern.hasMatch(password)) {
      return 'أضف حرفاً كبيراً واحداً على الأقل.';
    }
    if (!_numberPattern.hasMatch(password)) {
      return 'أضف رقماً واحداً على الأقل.';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'أكد كلمة المرور.';
    if (value != password) return 'كلمتا المرور غير متطابقتين.';
    return null;
  }

  static String? termsAccepted(bool accepted) =>
      accepted ? null : 'يجب الموافقة على اللوائح والشروط.';

  static String? resetIdentifier(String? value) {
    final identifier = value?.trim() ?? '';
    if (identifier.isEmpty) return 'أدخل البريد أو الرقم الأكاديمي.';
    if (identifier.length < 5) return 'يجب ألا يقل المعرف عن 5 خانات.';
    if (identifier.contains('@') && !_emailPattern.hasMatch(identifier)) {
      return 'أدخل بريداً إلكترونياً صحيحاً.';
    }
    return null;
  }

  static String? otp(String? value) {
    final code = value?.trim() ?? '';
    if (code.isEmpty) return 'أدخل رمز التحقق.';
    if (code.length != 6 || !_digitsPattern.hasMatch(code)) {
      return 'يجب أن يتكون الرمز من 6 أرقام.';
    }
    return null;
  }
}
