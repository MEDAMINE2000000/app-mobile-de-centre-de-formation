import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:three_alfa_mobile_app/core/widgets/shared_button.dart';
import 'package:three_alfa_mobile_app/features/auth/widgets/create_account_row.dart';
import 'package:three_alfa_mobile_app/features/auth/widgets/forgot_password_link.dart';

import 'package:three_alfa_mobile_app/features/auth/widgets/login_title_section.dart';

import 'package:three_alfa_mobile_app/features/auth/widgets/shared_text_form_field.dart';
import 'package:three_alfa_mobile_app/features/auth/provider/auth_provider.dart';

class LoginFormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController identifiantController;
  final TextEditingController motDePasseController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final VoidCallback onMotDePasseOublie;
  final VoidCallback onSeConnecter;
  final VoidCallback onCreerCompte;

  const LoginFormCard({
    super.key,
    required this.formKey,
    required this.identifiantController,
    required this.motDePasseController,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.onMotDePasseOublie,
    required this.onSeConnecter,
    required this.onCreerCompte,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.5.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            //----------------------------------------------------------------------------------------------------------------> Titles
            const LoginTitleSection(
              label: 'Se connecter',
              sousLabel: 'Ravis de vous revoir !',
            ),
            Gap(3.h),

            //----------------------------------------------------------------------------------------------------------------> Identifiant
            SharedTextFormField(
              controller: identifiantController,
              hintText: 'Identifiant',
              prefixIcon: Icons.person_outline,

              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Identifiant requis';
                }
                final gmailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
                if (!gmailRegex.hasMatch(value.trim())) {
                  return 'Identifiant invalide (ex: nom@gmail.com)';
                }
                return null;
              },
            ),
            Gap(2.h),

            //----------------------------------------------------------------------------------------------------------------> Mot de passe
            SharedTextFormField(
              controller: motDePasseController,
              hintText: 'Mot de passe',
              prefixIcon: Icons.lock_outline,
              obscureText: obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white.withOpacity(0.7),
                ),
                onPressed: onToggleObscure,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Mot de passe requis';
                }
                if (value.length < 6) {
                  return '6 caractères minimum';
                }
                return null;
              },
            ),
            Gap(1.6.h),

            //----------------------------------------------------------------------------------------------------------------> Mot de passe oublié
            Align(
              alignment: Alignment.centerRight,
              child: ForgotPasswordLink(onTap: onMotDePasseOublie),
            ),
            Gap(3.h),

            //----------------------------------------------------------------------------------------------------------------> Se connecter
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return SizedBox(
                  width: double.infinity,
                  child: SharedButton(
                    isLoading: authProvider.isLoading,
                    onPressed: onSeConnecter,
                    label: 'Se connecter',
                    icon: Icons.login_rounded,
                  ),
                );
              },
            ),
            Gap(3.h),
            CreateAccountRow(
              onTap: onCreerCompte,
              label: 'Pas encore de compte ? ',
              subLabel: 'Créer un compte',
            ),
          ],
        ),
      ),
    );
  }
}
