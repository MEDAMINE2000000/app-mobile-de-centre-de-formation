import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:three_alfa_mobile_app/core/widgets/shared_button.dart';
import 'package:three_alfa_mobile_app/features/auth/provider/auth_provider.dart';

import 'package:three_alfa_mobile_app/features/auth/widgets/shared_text_form_field.dart';

class RegisterFormCard extends StatelessWidget {
  final TextEditingController nomController;
  final TextEditingController prenomController;
  final TextEditingController telephoneController;
  final TextEditingController dateNaissanceController;
  final TextEditingController identifiantControllerRegister;
  final TextEditingController motDePasseController;
  final TextEditingController confirmMotDePasseController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onToggleObscure;
  final VoidCallback onToggleObscureConfirm;
  final VoidCallback onRegister;

  const RegisterFormCard({
    super.key,
    required this.nomController,
    required this.prenomController,
    required this.telephoneController,
    required this.dateNaissanceController,
    required this.identifiantControllerRegister,
    required this.motDePasseController,
    required this.confirmMotDePasseController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onToggleObscure,
    required this.onToggleObscureConfirm,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //----------------------------------------------------------------------------------------------------------------> Nom
        SharedTextFormField(
          controller: nomController,
          hintText: 'Nom',
          prefixIcon: Icons.badge_outlined,
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Nom requis';
            }
            return null;
          },
        ),
        Gap(2.h),

        //----------------------------------------------------------------------------------------------------------------> Prénom
        SharedTextFormField(
          controller: prenomController,
          hintText: 'Prénom',
          prefixIcon: Icons.person_outline,
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Prénom requis';
            }
            return null;
          },
        ),
        Gap(2.h),

        //----------------------------------------------------------------------------------------------------------------> Téléphone
        SharedTextFormField(
          controller: telephoneController,
          hintText: 'Téléphone',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Téléphone requis';
            }
            final phoneRegex = RegExp(r'^[0-9]{8}$');
            if (!phoneRegex.hasMatch(value.trim())) {
              return 'Numéro invalide (8 chiffres)';
            }
            return null;
          },
        ),
        Gap(2.h),

        //----------------------------------------------------------------------------------------------------------------> Date de naissance
        GestureDetector(
          onTap: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime(now.year - 18, now.month, now.day),
              firstDate: DateTime(1940),
              lastDate: now,
            );
            if (picked != null) {
              dateNaissanceController.text =
                  '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
            }
          },
          child: AbsorbPointer(
            child: SharedTextFormField(
              controller: dateNaissanceController,
              hintText: 'Date de naissance',
              prefixIcon: Icons.calendar_today_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Date de naissance requise';
                }
                return null;
              },
            ),
          ),
        ),
        Gap(2.h),

        //----------------------------------------------------------------------------------------------------------------> Identifiant
        SharedTextFormField(
          controller: identifiantControllerRegister,
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
        Gap(2.h),

        //----------------------------------------------------------------------------------------------------------------> Confirmer mot de passe
        SharedTextFormField(
          controller: confirmMotDePasseController,
          hintText: 'Confirmer le mot de passe',
          prefixIcon: Icons.lock_outline,
          obscureText: obscureConfirmPassword,
          suffixIcon: IconButton(
            icon: Icon(
              obscureConfirmPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.white.withOpacity(0.7),
            ),
            onPressed: onToggleObscureConfirm,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Confirmation requise';
            }
            if (value != motDePasseController.text) {
              return 'Les mots de passe ne correspondent pas';
            }
            return null;
          },
        ),
        Gap(3.h),

        //----------------------------------------------------------------------------------------------------------------> S'inscrire
        Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return SizedBox(
              width: double.infinity,
              child: SharedButton(
                isLoading: authProvider.isLoading,
                onPressed: onRegister,
                label: 'Se connecter',
                icon: Icons.login_rounded,
              ),
            );
          },
        ),
      ],
    );
  }
}
