import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';
import 'package:three_alfa_mobile_app/features/profile/model/profile_model.dart';
import 'package:three_alfa_mobile_app/features/profile/provider/profile_provider.dart';
import 'package:three_alfa_mobile_app/features/profile/widgets/photo_picker_sheet.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileModel profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final isUploading = context.watch<ProfileProvider>().isUploadingPhoto;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
      decoration: const BoxDecoration(
        gradient: AppColors.containerGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: isUploading
                ? null
                : () => showPhotoPickerSheet(context, profile),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.pink, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 11.w,
                    backgroundColor: AppColors.purple,
                    backgroundImage: profile.hasPhoto
                        ? NetworkImage(profile.photoUrl!)
                        : null,
                    onBackgroundImageError: profile.hasPhoto
                        ? (_, __) {}
                        : null,
                    child: !profile.hasPhoto
                        ? Text(
                            profile.initials,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                ),

                // ── Upload spinner overlay ──
                if (isUploading)
                  Container(
                    width: 22.w,
                    height: 22.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.45),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    ),
                  ),

                // ── Camera badge ──
                if (!isUploading)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(1.4.w),
                      decoration: const BoxDecoration(
                        color: AppColors.pink,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 3.6.w,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Gap(1.6.h),
          Text(
            profile.fullName.isEmpty ? 'Utilisateur' : profile.fullName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(0.6.h),
          Text(
            profile.email,
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}
