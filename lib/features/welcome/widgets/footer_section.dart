import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.symmetric(vertical: 1.2.h, horizontal: 5.w),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [Color(0xFF06042E), Color(0xFF282568), Color(0xFFD63384)],
        ),

        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, -3),
          ),
        ],
      ),

      child: Text(
        "© 2026 Three Alfa Formation\nTous droits réservés.",

        textAlign: TextAlign.center,

        style: TextStyle(color: Colors.white70, fontSize: 9.5.sp, height: 1.4),
      ),
    );
  }
}
