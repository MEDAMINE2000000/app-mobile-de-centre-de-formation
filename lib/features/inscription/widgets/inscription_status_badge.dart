import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';

import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';
import 'package:three_alfa_mobile_app/features/inscription/model/inscription_model.dart';

class InscriptionStatusBadge extends StatelessWidget {
  final InscriptionStatus status;
  final String? customLabel;

  const InscriptionStatusBadge({
    super.key,
    required this.status,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    late final Color color;
    late final IconData icon;
    late final String label;

    switch (status) {
      case InscriptionStatus.pending:
        color = const Color(0xFFF5A623);
        icon = Icons.hourglass_top_rounded;
        label = customLabel ?? 'En attente';
        break;

      case InscriptionStatus.confirmed:
        color = AppColors.success;
        icon = Icons.check_circle_rounded;
        label = customLabel ?? 'Accepted';
        break;

      case InscriptionStatus.rejected:
        color = AppColors.error;
        icon = Icons.cancel_rounded;
        label = customLabel ?? 'Refusée';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.7.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14.sp),
          Gap(1.3.w),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
