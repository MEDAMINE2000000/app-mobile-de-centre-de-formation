import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';

class FormationAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FormationAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(8.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.navy),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        child: AppBar(
          elevation: 4,
          toolbarHeight: 8.h,
          backgroundColor: AppColors.navy,
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppColors.pink.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.school_rounded,
                  color: AppColors.pink,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Nos Formations',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
