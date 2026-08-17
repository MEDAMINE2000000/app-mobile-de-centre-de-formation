import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';
import 'package:three_alfa_mobile_app/core/widgets/titles_acceuil.dart';

class TitleBigContainer extends StatelessWidget {
  const TitleBigContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 15.h,
      decoration: BoxDecoration(
        gradient: AppColors.containerGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.center,
        child: TitlesAcceuil(
          label: "Catalogue des Formations",
          sousLabel: "Découvrez tous nos programmes certifiants",
          color: AppColors.bgLight,
        ),
      ),
    );
  }
}
