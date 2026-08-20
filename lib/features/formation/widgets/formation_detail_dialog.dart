import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:three_alfa_mobile_app/core/widgets/shared_button.dart';
import 'package:three_alfa_mobile_app/features/auth/provider/auth_provider.dart';
import 'package:three_alfa_mobile_app/features/formation/models/formation_model.dart';
import 'package:three_alfa_mobile_app/features/inscription/provider/inscription_provider .dart';

class FormationDetailDialog extends StatefulWidget {
  final Formation formation;

  const FormationDetailDialog({super.key, required this.formation});

  @override
  State<FormationDetailDialog> createState() => _FormationDetailDialogState();
}

class _FormationDetailDialogState extends State<FormationDetailDialog> {
  Future<void> _onSInscrire() async {
    final authProvider = context.read<AuthProvider>();

    // ── Not logged in → send to login, keep dialog closed ──
    if (authProvider.user == null) {
      context.pop();
      context.push('/login');
      return;
    }

    final inscriptionProvider = context.read<InscriptionProvider>();

    final success = await inscriptionProvider.submitInscription(
      formationId: widget.formation.id,
      formationTitle: widget.formation.title,
      formationImageUrl: widget.formation.imageUrl,
      formationCategoryName: widget.formation.categoryName,
    );

    if (!mounted) return;

    final overlayState = Overlay.of(context);

    context.pop(); // close the dialog either way

    _showCustomToast(overlayState, success);
  }

  void _showCustomToast(OverlayState overlayState, bool isSuccess) {
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.black.withValues(alpha: 0.3),
        child: Center(
          child: Container(
            width: 55.w,
            height: 55.w,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 30,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: isSuccess
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSuccess
                        ? Icons.check_rounded
                        : Icons.error_outline_rounded,
                    color: isSuccess ? Colors.green : Colors.red,
                    size: 35.sp,
                  ),
                ),
                Gap(2.h),
                Text(
                  isSuccess
                      ? "Formation inscrite\navec succès !"
                      : "Une erreur\nest survenue.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          )
          .animate()
          .scale(
              begin: const Offset(0.7, 0.7),
              end: const Offset(1.0, 1.0),
              duration: 300.ms, // Snappier in animation
              curve: Curves.easeOutBack)
          .then(delay: 1200.ms)
          .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(0.7, 0.7),
              duration: 300.ms,
              curve: Curves.easeInBack),
        ),
      )
      .animate()
      .fadeIn(duration: 300.ms)
      .then(delay: 1200.ms)
      .fadeOut(duration: 300.ms),
    );

    overlayState.insert(overlayEntry);

    Future.delayed(const Duration(milliseconds: 1900), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = context.watch<InscriptionProvider>().isSubmitting;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
      child: Container(
        constraints: BoxConstraints(maxHeight: 75.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: image + floating badges
            Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: 18.h,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: Image.asset(
                      widget.formation.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.navy2,
                        child: Center(
                          child: Icon(
                            widget.formation.badgeIcon,
                            color: Colors.white54,
                            size: 40.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Category badge
                Positioned(
                  top: 1.4.h,
                  left: 4.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.5.w,
                      vertical: 0.7.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.navy2.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      widget.formation.categoryName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // Floating badge icon
                Positioned(
                  left: 4.w,
                  bottom: -2.2.h,
                  child: Container(
                    width: 13.w,
                    height: 13.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.formation.badgeIcon,
                      color: AppColors.pink,
                      size: 19.sp,
                    ),
                  ),
                ),
              ],
            ),

            Gap(2.5.h),

            // Scrollable content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Duration & Level Row
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: AppColors.pink,
                          size: 15.sp,
                        ),
                        Gap(1.2.w),
                        Text(
                          widget.formation.duration,
                          style: TextStyle(
                            color: AppColors.pink,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gap(3.5.w),
                        Icon(
                          Icons.signal_cellular_alt_rounded,
                          color: AppColors.textMute,
                          size: 15.sp,
                        ),
                        Gap(1.2.w),
                        Text(
                          widget.formation.level,
                          style: TextStyle(
                            color: AppColors.textMute,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Gap(1.2.h),

                    // Title
                    Text(
                      widget.formation.title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    Gap(1.5.h),

                    // Description label
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Gap(0.8.h),

                    // Full Description
                    Text(
                      widget.formation.description,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textMute,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                    Gap(2.5.h),
                  ],
                ),
              ),
            ),

            // Bottom action button
            Padding(
              padding: EdgeInsets.fromLTRB(4.5.w, 0, 4.5.w, 3.h),
              child: SharedButton(
                label: isSubmitting ? 'Envoi en cours...' : "S'inscrire",
                icon: Icons.check_circle_outline_rounded,
                onPressed: isSubmitting ? () {} : _onSInscrire,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
