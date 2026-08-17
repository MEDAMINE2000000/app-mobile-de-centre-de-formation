import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SousTitreMotivation extends StatelessWidget {
  const SousTitreMotivation({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 9.0),
      child: Text(
        'Un accompagnement pratique'
        '\n'
        'pour construire votre avenir'
        '\n'
        'professionnel',
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.white.withOpacity(0.8),
          height: 1.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
