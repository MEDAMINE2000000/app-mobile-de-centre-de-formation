import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';

import 'package:three_alfa_mobile_app/core/widgets/app_barr_section.dart';
import 'package:three_alfa_mobile_app/core/widgets/shared_button.dart';
import 'package:three_alfa_mobile_app/features/welcome/widgets/motivation_title.dart';
import 'package:three_alfa_mobile_app/features/welcome/widgets/container_centre_de_formation.dart';
import 'package:three_alfa_mobile_app/features/welcome/widgets/pourquoi_choisir_three_alfa.dart';
import 'package:three_alfa_mobile_app/features/welcome/widgets/sous_titre_motivation.dart';
import 'package:three_alfa_mobile_app/features/welcome/widgets/states_row.dart';
import 'package:three_alfa_mobile_app/core/widgets/titles_acceuil.dart';
import 'package:three_alfa_mobile_app/features/welcome/widgets/videos_section.dart';
import 'package:three_alfa_mobile_app/features/welcome/widgets/logo_marquee.dart';
import 'package:three_alfa_mobile_app/features/welcome/widgets/contact_us_section.dart';
import 'package:three_alfa_mobile_app/features/welcome/widgets/social_links_section.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        //------------------------------------------------------------------------------------------------------------------------------------------------------------> AppBar
        extendBodyBehindAppBar: false,
        appBar: const AppBarrSection(),
        //---------------------------------------------------------------------------------------------------------------------------------------------------------------> BODY
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    // Image en arrière-plan
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.Q),
                        bottomRight: Radius.circular(30.Q),
                      ),
                      child: Image.asset(
                        'assets/welcome/women_marketing.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 1.3.w,
                        vertical: 1.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(1.2.h),
                          const ContainerCentreDeFormation(),
                          Gap(1.2.h),
                          const MotivationTitle(),
                          Gap(1.2.h),
                          const SousTitreMotivation(),
                          Gap(1.2.h),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SharedButton(
                              onPressed: () {},
                              label: 'decouvrir le centre',
                              icon: Icons.explore_rounded,
                            ),
                          ),
                          Gap(2.4.h),
                        ],
                      ),
                    ),
                  ],
                ),
                const StatsRow(),
                Gap(2.4.h),
                const TitlesAcceuil(
                  label: 'Découvrez notre centre',
                  sousLabel: 'une experience au coeur de three alfa',
                ),
                Gap(1.6.h),
                VideosSection(),
                Gap(1.6.h),
                const TitlesAcceuil(
                  label: 'pourquoi choisir three alfa',
                  sousLabel: 'Votre réussite , notre priorité',
                ),
                Gap(1.6.h),
                //-------------------------------------------------------------------------------------------------------------------------> Tommorrow
                const PourquoiChoisirThreeAlfa(),
                Gap(1.6.h),
                const TitlesAcceuil(
                  label: 'Contactez-vous',
                  sousLabel: 'Nous sommes la pour vous aider',
                ),
                Gap(1.6.h),
                const ContactUsSection(),
                Gap(1.6.h),
                const LogoMarquee(),
                Gap(1.6.h),
                const SocialLinksSection(),
                Gap(1.2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
