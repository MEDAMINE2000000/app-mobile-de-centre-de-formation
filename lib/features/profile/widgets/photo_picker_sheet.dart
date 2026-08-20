import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';
import 'package:three_alfa_mobile_app/features/profile/model/profile_model.dart';
import 'package:three_alfa_mobile_app/features/profile/provider/profile_provider.dart';

Future<void> showPhotoPickerSheet(BuildContext context, ProfileModel profile) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => PhotoPickerSheet(profile: profile),
  );
}

class PhotoPickerSheet extends StatelessWidget {
  final ProfileModel profile;

  const PhotoPickerSheet({super.key, required this.profile});

  Future<void> _pickAndUpload(BuildContext context, ImageSource source) async {
    final provider = context.read<ProfileProvider>();
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile == null) return; // user cancelled

      if (!context.mounted) return;
      Navigator.of(
        context,
      ).pop(); // close the sheet, show progress on the screen behind

      final success = await provider.uploadProfilePicture(
        File(pickedFile.path),
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? (provider.successMessage ?? 'Photo mise à jour.')
                : (provider.errorMessage ?? 'Erreur lors de la mise à jour.'),
          ),
          backgroundColor: success ? AppColors.success : AppColors.error,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            source == ImageSource.camera
                ? 'Impossible d\'accéder à la caméra.'
                : 'Impossible d\'accéder à la galerie.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _remove(BuildContext context) async {
    final provider = context.read<ProfileProvider>();
    Navigator.of(context).pop();

    final success = await provider.removeProfilePicture();

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? (provider.successMessage ?? 'Photo supprimée.')
              : (provider.errorMessage ?? 'Erreur lors de la suppression.'),
        ),
        backgroundColor: success ? AppColors.success : AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.5.h),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
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
              'Photo de profil',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(2.4.h),
            _PickerOption(
              icon: Icons.camera_alt_rounded,
              label: 'Prendre une photo',
              onTap: () => _pickAndUpload(context, ImageSource.camera),
            ),
            Gap(1.4.h),
            _PickerOption(
              icon: Icons.photo_library_rounded,
              label: 'Choisir depuis la galerie',
              onTap: () => _pickAndUpload(context, ImageSource.gallery),
            ),
            if (profile.hasPhoto) ...[
              Gap(1.4.h),
              _PickerOption(
                icon: Icons.delete_outline_rounded,
                label: 'Supprimer la photo',
                iconColor: AppColors.error,
                textColor: AppColors.error,
                onTap: () => _remove(context),
              ),
            ],
            Gap(1.h),
          ],
        ),
      ),
    );
  }
}

class _PickerOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  const _PickerOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.6.h),
        decoration: BoxDecoration(
          color: AppColors.bgLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? AppColors.purple, size: 5.5.w),
            Gap(3.w),
            Text(
              label,
              style: TextStyle(
                color: textColor ?? AppColors.textDark,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
