import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';

class MotivationTitle extends StatelessWidget {
  const MotivationTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.25,
          ),
          children: [
            const TextSpan(text: 'Boostez votre\n'),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.5.w,
                  vertical: 0.3.h,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.gradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'carrière',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const TextSpan(text: ' avec\nThree Alfa'),
          ],
        ),
      ),
    );
  }
}
