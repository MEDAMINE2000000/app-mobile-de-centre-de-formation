import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';

import 'package:three_alfa_mobile_app/core/widgets/shared_button.dart';
import 'package:three_alfa_mobile_app/features/auth/widgets/login_title_section.dart';
import 'package:three_alfa_mobile_app/features/auth/widgets/shared_text_form_field.dart';

class SendOtpCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController otpController;
  final void Function()? onPressed;

  const SendOtpCard({
    super.key,
    required this.formKey,
    required this.otpController,
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
            //---------------------------------------------> Titre
            const LoginTitleSection(
              label: 'Vérification OTP',
              sousLabel: 'Entrez le code à 6 chiffres reçu par email',
            ),
            Gap(3.h),

            //---------------------------------------------> Champ OTP
            SharedTextFormField(
              controller: otpController,
              hintText: 'Code OTP (6 chiffres)',
              prefixIcon: Icons.pin_outlined,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Le code OTP est requis';
                }
                final otpRegex = RegExp(r'^\d{6}$');
                if (!otpRegex.hasMatch(value.trim())) {
                  return 'Le code doit contenir exactement 6 chiffres';
                }
                return null;
              },
            ),
            Gap(3.h),

            //---------------------------------------------> Bouton confirmer
            SizedBox(
              width: double.infinity,
              child: SharedButton(
                onPressed: onPressed,
                label: 'Confirmer le code',
                icon: Icons.verified_outlined,
              ),
            ),
            Gap(3.h),
          ],
        ),
      ),
    );
  }
}
