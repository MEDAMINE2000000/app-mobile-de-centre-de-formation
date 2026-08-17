import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';

class LoginLogoHeader extends StatelessWidget {
  const LoginLogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 22.w,
          height: 22.w,
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Image.asset(
            'assets/welcome/three_alfa_logo.png',
            fit: BoxFit.contain,
          ),
        ),
        Gap(1.6.h),
        Text(
          'THREE ALFA',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: 3,
          ),
        ),
        Gap(0.4.h),
        Text(
          'F O R M A T I O N',
          style: TextStyle(
            color: const Color(0xFFE0388B),
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
