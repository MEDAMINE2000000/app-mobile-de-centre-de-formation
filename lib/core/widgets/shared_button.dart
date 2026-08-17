import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';

// ignore: must_be_immutable
class SharedButton extends StatelessWidget {
  bool isLoading;
  final String label;
  final IconData icon;
  final void Function()? onPressed;
  SharedButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
    this.isLoading = false,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.gradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: isLoading
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 1.2.h),
              child: Center(
                child: SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            )
          : TextButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, color: Colors.white),
              label: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
              ),
            ),
    );
  }
}
