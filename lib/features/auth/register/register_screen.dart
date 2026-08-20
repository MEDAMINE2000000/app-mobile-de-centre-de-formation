import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:three_alfa_mobile_app/features/auth/provider/auth_provider.dart';

import 'package:three_alfa_mobile_app/features/auth/register/widgets/register_form_card.dart';
import 'package:three_alfa_mobile_app/features/auth/widgets/create_account_row.dart';

import 'package:three_alfa_mobile_app/features/auth/widgets/login_logo_header.dart';
import 'package:three_alfa_mobile_app/features/auth/widgets/login_title_section.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController dateNaissanceController = TextEditingController();
  final TextEditingController identifiantController = TextEditingController();
  final TextEditingController motDePasseController = TextEditingController();
  final TextEditingController confirmMotDePasseController =
      TextEditingController();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    nomController.dispose();
    prenomController.dispose();
    telephoneController.dispose();
    dateNaissanceController.dispose();
    identifiantController.dispose();
    motDePasseController.dispose();
    confirmMotDePasseController.dispose();
    super.dispose();
  }

  void _toggleObscure() {
    setState(() => obscurePassword = !obscurePassword);
  }

  void _toggleObscureConfirm() {
    setState(() => obscureConfirmPassword = !obscureConfirmPassword);
  }

  void _onSeConnecter() {
    context.go('/login');
  }

  void _onRegister() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.register(
        nom: nomController.text.trim(),
        prenom: prenomController.text.trim(),
        telephone: telephoneController.text.trim(),
        dateNaissance: dateNaissanceController.text.trim(),
        email: identifiantController.text.trim(),
        password: motDePasseController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        context.go('/verify-email');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authProvider.errorMessage ?? 'Échec de l\'inscription.',
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
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 3.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const LoginTitleSection(
                          label: "S'inscrire",
                          sousLabel: 'Creer un compte',
                        ),
                        Gap(3.h),

                        RegisterFormCard(
                          nomController: nomController,
                          prenomController: prenomController,
                          telephoneController: telephoneController,
                          dateNaissanceController: dateNaissanceController,
                          identifiantControllerRegister: identifiantController,
                          motDePasseController: motDePasseController,
                          confirmMotDePasseController:
                              confirmMotDePasseController,
                          obscurePassword: obscurePassword,
                          obscureConfirmPassword: obscureConfirmPassword,
                          onToggleObscure: _toggleObscure,
                          onToggleObscureConfirm: _toggleObscureConfirm,
                          onRegister: _onRegister,
                        ),
                        Gap(3.h),

                        CreateAccountRow(
                          onTap: _onSeConnecter,
                          label: 'Déjà un compte ? ',
                          subLabel: "Connexion",
                        ),
                      ],
                    ),
                  ),
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
