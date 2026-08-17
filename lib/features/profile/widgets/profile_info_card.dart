import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';

import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';
import 'package:three_alfa_mobile_app/features/profile/model/profile_model.dart';

class ProfileInfoCard extends StatelessWidget {
  final ProfileModel profile;

  const ProfileInfoCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.person_outline_rounded,
            label: 'Nom',
            value: profile.nom.isEmpty ? '—' : profile.nom,
          ),
          const Divider(height: 1),
          _InfoRow(
            icon: Icons.badge_outlined,
            label: 'Prénom',
            value: profile.prenom.isEmpty ? '—' : profile.prenom,
          ),
          const Divider(height: 1),
          _InfoRow(
            icon: Icons.phone_outlined,
            label: 'Téléphone',
            value: profile.telephone.isEmpty ? '—' : profile.telephone,
          ),
          const Divider(height: 1),
          _InfoRow(
            icon: Icons.cake_outlined,
            label: 'Date de naissance',
            value: profile.dateNaissance.isEmpty ? '—' : profile.dateNaissance,
          ),
          const Divider(height: 1),
          _InfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: profile.email.isEmpty ? '—' : profile.email,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.4.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppColors.bgLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.purple, size: 7.w),
          ),
          Gap(3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: AppColors.textMute, fontSize: 15.sp),
                ),
                Gap(0.3.h),
                Text(
                  value,
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
