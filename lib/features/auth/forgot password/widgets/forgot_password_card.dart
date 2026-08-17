import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:three_alfa_mobile_app/core/widgets/shared_button.dart';
import 'package:three_alfa_mobile_app/features/auth/provider/auth_provider.dart';
import 'package:three_alfa_mobile_app/features/auth/widgets/login_title_section.dart';
import 'package:three_alfa_mobile_app/features/auth/widgets/shared_text_form_field.dart';

class ForgotPasswordCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController identifiantController;
  final VoidCallback onPressed;

  const ForgotPasswordCard({
    super.key,
    required this.formKey,
    required this.identifiantController,
    required this.onPressed,
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
            const LoginTitleSection(
              label: 'Mot de passe oublié',
              sousLabel: 'Entrez votre identifiant',
            ),
            Gap(3.h),

            SharedTextFormField(
              controller: identifiantController,
              hintText: 'Identifiant / E-mail',
              prefixIcon: Icons.email_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Identifiant requis';
                }
                final emailRegex = RegExp(
                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                );
                if (!emailRegex.hasMatch(value.trim())) {
                  return 'Adresse e-mail invalide (ex: exemple@domaine.com)';
                }
                return null;
              },
            ),
            Gap(2.h),

            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return SizedBox(
                  width: double.infinity,
                  child: SharedButton(
                    isLoading: authProvider.isLoading,
                    onPressed: onPressed,
                    label: 'Envoyer le lien',
                    icon: Icons.send_rounded,
                  ),
                );
              },
            ),
            Gap(3.h),
          ],
        ),
      ),
    );
  }
}
