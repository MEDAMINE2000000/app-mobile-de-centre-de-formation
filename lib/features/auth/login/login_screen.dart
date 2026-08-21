import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:three_alfa_mobile_app/core/utils/performance_monitor.dart';
=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:three_alfa_mobile_app/features/auth/login/widgets/login_form_card.dart';
import 'package:three_alfa_mobile_app/features/auth/provider/auth_provider.dart';
import 'package:three_alfa_mobile_app/features/auth/widgets/login_logo_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController identifiantController = TextEditingController();
  final TextEditingController motDePasseController = TextEditingController();
  bool obscurePassword = true;

  @override
  void dispose() {
    identifiantController.dispose();
    motDePasseController.dispose();
    super.dispose();
  }

  void _toggleObscure() => setState(() => obscurePassword = !obscurePassword);

  Future<void> _onSeConnecter() async {
    if (!_formKey.currentState!.validate()) return;

<<<<<<< HEAD
    PerformanceMonitor.start('connexion');

=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.login(
      identifiantController.text.trim(),
      motDePasseController.text.trim(),
    );

<<<<<<< HEAD
    if (success) {
      if (authProvider.isAdmin) {
        PerformanceMonitor.start('nav_Login_Admin');
      } else {
        PerformanceMonitor.start('nav_Login_Home');
      }
    }

    if (!mounted) return;

    if (!success) {
      final errorMsg = authProvider.errorMessage ?? 'Échec de la connexion.';
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    errorMsg,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFD32F2F),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 5),
          ),
        );
=======
    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Échec de la connexion.'),
          backgroundColor: Colors.redAccent,
        ),
      );
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
    }

    // لا تستعمل context.go هنا.
    // GoRouter سيختار:
    // email غير مفعّل → /verify-email
    // admin → /admin
    // user عادي → /
  }

  void _onCreerCompte() {
    context.push('/register');
  }

  void _onMotDePasseOublie() {
    context.push('/forgot-password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: 100.w,
        height: 100.h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E0F3D), Color(0xFF120821)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                Gap(4.h),
                const LoginLogoHeader(),
                Gap(3.h),
                LoginFormCard(
                  formKey: _formKey,
                  identifiantController: identifiantController,
                  motDePasseController: motDePasseController,
                  obscurePassword: obscurePassword,
                  onToggleObscure: _toggleObscure,
                  onMotDePasseOublie: _onMotDePasseOublie,
                  onSeConnecter: _onSeConnecter,
                  onCreerCompte: _onCreerCompte,
                ),
                Gap(3.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
