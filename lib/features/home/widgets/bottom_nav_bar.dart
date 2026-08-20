import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sizer/sizer.dart';

import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const BottomNavBar({super.key, required this.currentIndex, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.all(Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              offset: Offset(0, -2),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        child: GNav(
          selectedIndex: currentIndex,
          onTabChange: onTap,

          // Animation plus courte = sensation plus fluide
          duration: const Duration(milliseconds: 300),

          gap: 1.5.w,

          backgroundColor: AppColors.navy,

          color: Colors.white70,
          activeColor: Colors.white,

          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),

          tabs: [
            GButton(
              icon: Icons.home_rounded,
              text: 'Accueil',
              backgroundGradient: AppColors.gradient,
            ),
            GButton(
              icon: Icons.school_rounded,
              text: 'Formation',
              backgroundGradient: AppColors.gradient,
            ),
            GButton(
              icon: Icons.assignment_rounded,
              text: 'Demandes',
              backgroundGradient: AppColors.gradient,
            ),
            GButton(
              icon: Icons.person_rounded,
              text: 'Profil',
              backgroundGradient: AppColors.gradient,
            ),
          ],
        ),
      ),
    );
  }
}
