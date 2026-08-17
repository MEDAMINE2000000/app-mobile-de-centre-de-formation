import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';
import 'package:three_alfa_mobile_app/core/widgets/shared_button.dart';
import 'package:three_alfa_mobile_app/features/formation/models/formation_model.dart';
import 'package:three_alfa_mobile_app/features/formation/widgets/formation_detail_dialog.dart';

class FormationCard extends StatelessWidget {
  final Formation formation;

  const FormationCard({super.key, required this.formation});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEEEEF5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover Image & Overlapping Icons Stack
          SizedBox(
            height: 19.h,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Top Cover Image
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Image.asset(
                      formation.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.navy2,
                        child: Center(
                          child: Icon(
                            formation.badgeIcon,
                            color: Colors.white54,
                            size: 34.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Category Badge (Top Right)
                Positioned(
                  bottom: 1.4.h,
                  right: 4.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.5.w,
                      vertical: 0.7.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      formation.categoryName,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // Floating circular badge icon (Bottom Left overlapping image)
                Positioned(
                  left: 4.w,
                  bottom: -2.2.h,
                  child: Container(
                    width: 13.w,
                    height: 13.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      formation.badgeIcon,
                      color: AppColors.pink,
                      size: 19.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Details Padding Container
          Padding(
            padding: EdgeInsets.fromLTRB(4.5.w, 3.h, 4.5.w, 2.2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Duration & Level Metadata Row
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: AppColors.pink,
                      size: 15.sp,
                    ),
                    Gap(1.2.w),
                    Text(
                      formation.duration,
                      style: TextStyle(
                        color: AppColors.pink,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(3.5.w),
                    Icon(
                      Icons.signal_cellular_alt_rounded,
                      color: AppColors.textMute,
                      size: 15.sp,
                    ),
                    Gap(1.2.w),
                    Expanded(
                      child: Text(
                        formation.level,
                        style: TextStyle(
                          color: AppColors.textMute,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Gap(1.h),

                // Title
                Text(
                  formation.title,
                  style: TextStyle(
                    fontSize: 17.5.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                Gap(0.8.h),

                // Description
                Text(
                  formation.description,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: AppColors.textMute,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
                Gap(2.h),

                // Action Button: "Voir les détails →"
                SharedButton(
                  label: 'Voir les détails   ',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          FormationDetailDialog(formation: formation),
                    );
                  },
                  icon: Icons.arrow_forward_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
