import 'package:flutter/material.dart';

class AppColors {
  static const navy = Color(0xFF14123A);
  static const navy2 = Color(0xFF1C1A4D);
  static const pink = Color(0xFFEC3F8F);
  static const purple = Color(0xFF6B2C91); // rapproché mel logo
  static const purpleDark = Color(0xFF3D1A5B); // partie foncée du "S"
  static const bgLight = Color(0xFFF5F6FB);
  static const textDark = Color(0xFF1B1A3A);
  static const textMute = Color(0xFF6B6A86);
  static const white = Colors.white;
  static const success = Colors.green;
<<<<<<< HEAD
  static const warning = Colors.orange;
=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
  static const error = Colors.red;
  static const grey = Colors.grey;
  static const containerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.navy, Color(0xFF4B1453), AppColors.navy],
  );

  static const appBarColorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFCE4F2), Color(0xFFC374CB)],
  );
  static const gradient = LinearGradient(
    colors: [pink, purpleDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
