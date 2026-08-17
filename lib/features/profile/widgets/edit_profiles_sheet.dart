import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';
import 'package:three_alfa_mobile_app/core/widgets/shared_button.dart';
import 'package:three_alfa_mobile_app/features/profile/model/profile_model.dart';
import 'package:three_alfa_mobile_app/features/profile/provider/profile_provider.dart';

Future<void> showEditProfileSheet(BuildContext context, ProfileModel profile) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => EditProfileSheet(profile: profile),
  );
}

class EditProfileSheet extends StatefulWidget {
  final ProfileModel profile;

  const EditProfileSheet({super.key, required this.profile});

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nomCtrl;
  late final TextEditingController _prenomCtrl;
  late final TextEditingController _telCtrl;
  late final TextEditingController _dateCtrl;

  @override
  void initState() {
    super.initState();
    _nomCtrl = TextEditingController(text: widget.profile.nom);
    _prenomCtrl = TextEditingController(text: widget.profile.prenom);
    _telCtrl = TextEditingController(text: widget.profile.telephone);
    _dateCtrl = TextEditingController(text: widget.profile.dateNaissance);
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _telCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    DateTime initial =
        DateTime.tryParse(_normalizeForPicker(_dateCtrl.text)) ??
        DateTime(2000, 1, 1);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.purple,
              onPrimary: Colors.white,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateCtrl.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  String _normalizeForPicker(String value) {
    // expects dd/MM/yyyy, converts to yyyy-MM-dd for DateTime.tryParse
    final parts = value.split('/');
    if (parts.length != 3) return '';
    return '${parts[2]}-${parts[1]}-${parts[0]}';
  }

  Future<void> _submit(ProfileProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await provider.updateProfile(
      nom: _nomCtrl.text,
      prenom: _prenomCtrl.text,
      telephone: _telCtrl.text,
      dateNaissance: _dateCtrl.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.successMessage ?? 'Profil mis à jour.'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ?? 'Erreur lors de la mise à jour.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.5.h),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 12.w,
                    height: 0.5.h,
                    decoration: BoxDecoration(
                      color: AppColors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Gap(2.h),
                Text(
                  'Modifier mon profil',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(2.h),
                _buildField(
                  controller: _nomCtrl,
                  label: 'Nom',
                  icon: Icons.person_outline_rounded,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Le nom est requis.';
                    if (v.trim().length < 2) return 'Nom trop court.';
                    return null;
                  },
                ),
                Gap(1.6.h),
                _buildField(
                  controller: _prenomCtrl,
                  label: 'Prénom',
                  icon: Icons.badge_outlined,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Le prénom est requis.';
                    if (v.trim().length < 2) return 'Prénom trop court.';
                    return null;
                  },
                ),
                Gap(1.6.h),
                _buildField(
                  controller: _telCtrl,
                  label: 'Téléphone',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(8),
                  ],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Le téléphone est requis.';
                    }
                    if (v.trim().length != 8) {
                      return 'Numéro invalide (8 chiffres).';
                    }
                    return null;
                  },
                ),
                Gap(1.6.h),
                _buildField(
                  controller: _dateCtrl,
                  label: 'Date de naissance',
                  icon: Icons.cake_outlined,
                  readOnly: true,
                  onTap: _pickDate,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'La date de naissance est requise.';
                    }
                    return null;
                  },
                ),
                Gap(3.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: provider.isSaving
                            ? null
                            : () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 1.6.h),
                          side: BorderSide(
                            color: AppColors.grey.withOpacity(0.5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Annuler',
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                    Gap(3.w),
                    Expanded(
                      child: SharedButton(
                        onPressed: provider.isSaving
                            ? () {}
                            : () => _submit(provider),
                        label: provider.isSaving
                            ? 'enregistrement...'
                            : 'enregistrer',
                        icon: Icons.check_circle_outline_rounded,
                      ),
                    ),
                  ],
                ),
                Gap(1.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required FormFieldValidator<String> validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: TextStyle(fontSize: 12.5.sp, color: AppColors.textDark),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 16.sp, color: AppColors.textMute),
        prefixIcon: Icon(icon, color: AppColors.purple, size: 9.w),
        filled: true,
        fillColor: AppColors.bgLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.pink, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error, width: 1.2),
        ),
      ),
    );
  }
}
