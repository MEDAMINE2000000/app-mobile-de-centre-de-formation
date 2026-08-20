import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:three_alfa_mobile_app/features/auth/forgot%20password/widgets/forgot_password_card.dart';
import 'package:three_alfa_mobile_app/features/auth/provider/auth_provider.dart';
import 'package:three_alfa_mobile_app/features/auth/widgets/login_logo_header.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController identifiantController = TextEditingController();

  @override
  void dispose() {
    identifiantController.dispose();
    super.dispose();
  }

  Future<void> _onSendResetLink() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.forgotPassword(
        identifiantController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Un email de réinitialisation a été envoyé.'),
            backgroundColor: Color(0xFFE0388B),
          ),
        );
        Future.delayed(const Duration(seconds: 10), () {
          context.go('/login');
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authProvider.errorMessage ?? 'Échec de l\'envoi de l\'email.',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
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
                ForgotPasswordCard(
                  formKey: _formKey,
                  identifiantController: identifiantController,
                  onPressed: _onSendResetLink,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
