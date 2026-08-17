import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';

import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';

class AdminActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const AdminActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: EdgeInsets.only(bottom: 1.2.h),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.2.w),
              decoration: BoxDecoration(
                color: AppColors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.purple, size: 5.w),
            ),
            Gap(3.5.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMute,
              size: 5.5.w,
            ),
          ],
        ),
      ),
    );
  }
}
