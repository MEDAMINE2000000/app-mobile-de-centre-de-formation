import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';

import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';
import 'package:three_alfa_mobile_app/features/inscription/model/inscription_model.dart';
import 'package:three_alfa_mobile_app/features/inscription/widgets/inscription_status_badge.dart';

class InscriptionCard extends StatelessWidget {
  final InscriptionModel inscription;
  final VoidCallback? onCancel;

  const InscriptionCard({super.key, required this.inscription, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE9E9F2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================
            // IMAGE + CONTENT
            // =====================================================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Formation image
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    inscription.formationImageUrl,
                    width: 27.w,
                    height: 27.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 27.w,
                        height: 27.w,
                        decoration: BoxDecoration(
                          color: AppColors.navy2,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          Icons.school_rounded,
                          color: Colors.white.withOpacity(0.8),
                          size: 16.w,
                        ),
                      );
                    },
                  ),
                ),

                Gap(4.w),

                // Formation information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.8.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.pink.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          inscription.formationCategoryName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.pink,
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      Gap(1.h),

                      // Title
                      Text(
                        inscription.formationTitle,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                        ),
                      ),

                      Gap(1.h),

                      // Status
                      InscriptionStatusBadge(status: inscription.status),
                    ],
                  ),
                ),
              ],
            ),

            Gap(2.h),

            // =====================================================
            // DIVIDER
            // =====================================================
            Container(
              height: 1,
              width: double.infinity,
              color: const Color(0xFFF0F0F5),
            ),

            Gap(1.5.h),

            // =====================================================
            // BOTTOM SECTION
            // =====================================================
            Row(
              children: [
                // Date
                if (inscription.createdAt != null) ...[
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 14.sp,
                    color: AppColors.textMute,
                  ),
                  Gap(1.5.w),
                  Text(
                    _formatDate(inscription.createdAt!),
                    style: TextStyle(
                      color: AppColors.textMute,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],

                const Spacer(),

                // Cancel button
                if (inscription.status == InscriptionStatus.pending &&
                    onCancel != null)
                  GestureDetector(
                    onTap: onCancel,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.5.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.error.withOpacity(0.15),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.close_rounded,
                            color: AppColors.error,
                            size: 18.sp,
                          ),
                          Gap(1.w),
                          Text(
                            'Annuler',
                            style: TextStyle(
                              color: AppColors.error,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // =====================================================
            // CENTRE NOTE
            // =====================================================
            if (inscription.status == InscriptionStatus.rejected &&
                inscription.centreNote != null &&
                inscription.centreNote!.isNotEmpty) ...[
              Gap(1.5.h),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.error.withOpacity(0.12)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.error,
                      size: 17.sp,
                    ),
                    Gap(2.w),
                    Expanded(
                      child: Text(
                        inscription.centreNote!,
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 10.5.sp,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }
}
