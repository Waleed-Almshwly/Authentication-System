import 'package:flutter/material.dart';

import 'controllers/auth_controller.dart';
import 'repositories/auth_repository_impl.dart';
import 'views/auth/login_page.dart';

void main() {
  final controller = AuthController(AuthRepositoryImpl());
  runApp(StudentAuthApp(controller: controller));
}

class StudentAuthApp extends StatelessWidget {
  const StudentAuthApp({super.key, required this.controller});

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF155E75);
    return MaterialApp(
      title: 'بوابة الطالب',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          surface: const Color(0xFFF7FAFC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7FAFC),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFDCE5EA)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFDCE5EA)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: primary, width: 1.5),
          ),
        ),
      ),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      home: LoginPage(controller: controller),
    );
  }
}
