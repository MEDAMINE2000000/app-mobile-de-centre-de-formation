import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: AppColors.navy, // Dark background color
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem(number: "13+", label: "Formateurs"),
          _verticalDivider(),
          _statItem(number: "2 000+", label: "Diplômés"),
          _verticalDivider(),
          _statItem(number: "19+", label: "Formations"),
          _verticalDivider(),
          _statItem(number: "17+", label: "Partenaires"),
        ],
      ),
    );
  }
}

Widget _verticalDivider() {
  return SizedBox(
    height: 6.h,
    child: VerticalDivider(color: Colors.grey[600], thickness: 0.5, width: 2.w),
  );
}

Widget _statItem({required String number, required String label}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        number,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 0.5.h),
      Text(
        label,
        style: TextStyle(fontSize: 14.sp, color: Colors.white.withOpacity(0.7)),
      ),
    ],
  );
}
