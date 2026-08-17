import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';

class AdminPlaceholderScreen extends StatelessWidget {
  final String title;

  const AdminPlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Text(
          'Bientôt disponible',
          style: TextStyle(color: AppColors.textMute, fontSize: 13.sp),
        ),
      ),
    );
  }
}
