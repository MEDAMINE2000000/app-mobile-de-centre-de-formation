import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:three_alfa_mobile_app/features/welcome/widgets/features_grid.dart';

class PourquoiChoisirThreeAlfa extends StatelessWidget {
  const PourquoiChoisirThreeAlfa({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: 0,
      mainAxisSpacing: 1.h,
      childAspectRatio: 2.2,
      children: const [
        FeatureCard(
          icon: Icons.play_circle_outline_rounded,
          label: 'cours de tomorow',
        ),
        FeatureCard(
          icon: Icons.verified_user_rounded,
          label: 'cours de tomorow',
        ),
        FeatureCard(
          icon: Icons.card_membership_rounded,
          label: 'cours de tomorow',
        ),
        FeatureCard(
          icon: Icons.checklist_rtl_rounded,
          label: 'cours de tomorow',
        ),
      ],
    );
  }
}
