import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';
import 'package:three_alfa_mobile_app/core/widgets/app_barr_section.dart';
import 'package:three_alfa_mobile_app/core/widgets/shared_button.dart';
import 'package:three_alfa_mobile_app/core/widgets/titles_acceuil.dart';
import 'package:three_alfa_mobile_app/features/profile/provider/profile_provider.dart';
import 'package:three_alfa_mobile_app/features/profile/widgets/edit_profiles_sheet.dart';

import 'package:three_alfa_mobile_app/features/profile/widgets/logout_section.dart';
import 'package:three_alfa_mobile_app/features/profile/widgets/profile_header.dart';
import 'package:three_alfa_mobile_app/features/profile/widgets/profile_info_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: const AppBarrSection(),
      body: RefreshIndicator(
        color: AppColors.pink,
        onRefresh: () => context.read<ProfileProvider>().loadProfile(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: _buildBody(provider),
        ),
      ),
    );
  }

  Widget _buildBody(ProfileProvider provider) {
    // ── Loading ──
    if (provider.isLoading && provider.profile == null) {
      return SizedBox(
        height: 60.h,
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.pink),
        ),
      );
    }

    // ── Error, no cached profile ──
    if (provider.profile == null) {
      return SizedBox(
        height: 60.h,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.error,
                  size: 10.w,
                ),
                Gap(1.6.h),
                Text(
                  provider.errorMessage ?? 'Impossible de charger le profil.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textMute, fontSize: 12.sp),
                ),
                Gap(2.h),
                SharedButton(
                  onPressed: () => provider.loadProfile(),
                  label: 'réessayer',
                  icon: Icons.refresh_rounded,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final profile = provider.profile!;

    return Column(
      children: [
        ProfileHeader(profile: profile),
        Gap(2.4.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TitlesAcceuil(
                label: 'Vos informations',
                sousLabel: 'Consultez et gérez vos données personnelles',
              ),
              Gap(1.6.h),
              ProfileInfoCard(profile: profile),
              Gap(2.h),
              SharedButton(
                onPressed: provider.isSaving
                    ? () {}
                    : () => showEditProfileSheet(context, profile),
                label: 'modifier mes informations',
                icon: Icons.edit_outlined,
              ),
              Gap(1.6.h),
              const LogoutSection(),
              Gap(2.h),
            ],
          ),
        ),
      ],
    );
  }
}
