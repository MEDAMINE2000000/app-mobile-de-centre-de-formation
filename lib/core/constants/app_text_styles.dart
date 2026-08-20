import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    letterSpacing: -0.5,
  );

  static const TextStyle bodyS = TextStyle(
    fontSize: 14,
    color: AppColors
        .white, // In forms context, subtitle usually white or light mute
    height: 1.4,
  );

  static const TextStyle link = TextStyle(
    fontSize: 14,
    color: AppColors.pink,
    fontWeight: FontWeight.w600,
  );
}
