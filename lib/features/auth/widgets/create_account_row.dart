import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class CreateAccountRow extends StatelessWidget {
  String label;
  String subLabel;
  final VoidCallback onTap;

  CreateAccountRow({
    super.key,
    required this.onTap,
    required this.label,
    required this.subLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14.5.sp,
          ),
        ),
        Gap(0.5.w),
        GestureDetector(
          onTap: onTap,
          child: Text(
            subLabel,
            style: TextStyle(
              color: const Color(0xFFE0388B),
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
