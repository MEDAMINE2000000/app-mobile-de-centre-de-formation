import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';
import 'package:three_alfa_mobile_app/features/formation/models/formation_model.dart';

class FormationCategoryItem extends StatelessWidget {
  final FormationCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const FormationCategoryItem({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: 2.5.w),
        padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 1.2.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.pink : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.pink : const Color(0xFFD0D0E0),
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.pink.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Icon(Icons.check_rounded, color: Colors.white, size: 15.sp),
              Gap(1.5.w),
            ],
            Text(
              category.name,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF2C2A4A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
