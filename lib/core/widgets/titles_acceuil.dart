import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';

class TitlesAcceuil extends StatelessWidget {
  final Color? color;
  final String label;
  final String sousLabel;

  const TitlesAcceuil({
    super.key,
    required this.label,
    required this.sousLabel,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
            color: color ?? AppColors.navy,
          ),
        ),
        Gap(0.6.h),
        Container(
          width: 20.w,
          height: 0.35.h,
          decoration: BoxDecoration(
            color: AppColors.pink,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Gap(0.8.h),
        Text(
          sousLabel,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textMute,
          ),
        ),
      ],
    );
  }
}
