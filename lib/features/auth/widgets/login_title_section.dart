import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';

class LoginTitleSection extends StatelessWidget {
  final String label;
  final String sousLabel;
  const LoginTitleSection({
    super.key,
    required this.label,
    required this.sousLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        Gap(0.6.h),
        Text(
          sousLabel,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 15.sp,
          ),
        ),
      ],
    );
  }
}
