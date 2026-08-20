import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  // ── Login: Violet foncé -> Violet moyen (dégradé très doux et fluide) ──
  static const LinearGradient loginBackground = LinearGradient(
    colors: [Color(0xFF0B0730), Color(0xFF231648), Color(0xFF451952)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── Register: Violet foncé -> Magenta doux (dégradé fluide) ──
  static const LinearGradient registerBackground = LinearGradient(
    colors: [Color(0xFF0B0730), Color(0xFF33154C), Color(0xFF5A185A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColors.pink, AppColors.purple],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
