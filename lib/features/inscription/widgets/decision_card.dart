import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';
import 'package:three_alfa_mobile_app/features/inscription/model/inscription_model.dart';
import 'package:three_alfa_mobile_app/features/inscription/provider/inscription_provider .dart';

/// Card displayed in the "Decisions to read" section.
/// Contains the animated "Lu" button and dismissal animation.
class DecisionCard extends StatefulWidget {
  final InscriptionModel inscription;

  const DecisionCard({super.key, required this.inscription});

  @override
  State<DecisionCard> createState() => _DecisionCardState();
}

class _DecisionCardState extends State<DecisionCard>
    with TickerProviderStateMixin {
  // ── Pulse animation (idle) ──────────────────────────────────
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseScale;
  late final Animation<double> _pulseGlow;

  // ── Tap animation ───────────────────────────────────────────
  late final AnimationController _tapCtrl;
  late final Animation<double> _tapScale;

  // ── Check animation ─────────────────────────────────────────
  late final AnimationController _checkCtrl;
  late final Animation<double> _checkScale;
  late final Animation<double> _checkOpacity;

  // ── Dismissal animation ─────────────────────────────────────
  late final AnimationController _dismissCtrl;
  late final Animation<double> _dismissOpacity;
  late final Animation<Offset> _dismissSlide;

  bool _isConfirmed = false;
  bool _isProcessing = false;
  Timer? _pulseTimer;

  bool get _isAccepted =>
      widget.inscription.status == InscriptionStatus.confirmed;

  @override
  void initState() {
    super.initState();

    // Pulse: repeats every 2.5 s with a gentle scale + glow
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.08), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _pulseGlow = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 4.0, end: 12.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 12.0, end: 4.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _startPulse();

    // Tap feedback
    _tapCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _tapScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.92), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.92, end: 1.08), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _tapCtrl, curve: Curves.easeInOut));

    // Check mark
    _checkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _checkScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _checkCtrl, curve: Curves.elasticOut),
    );
    _checkOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _checkCtrl, curve: Curves.easeIn),
    );

    // Dismissal
    _dismissCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _dismissOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _dismissCtrl, curve: Curves.easeOut),
    );
    _dismissSlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.3, 0),
    ).animate(
      CurvedAnimation(parent: _dismissCtrl, curve: Curves.easeInCubic),
    );
  }

  void _startPulse() {
    _pulseTimer = Timer(const Duration(milliseconds: 600), () {
      if (mounted && !_isConfirmed) {
        _pulseCtrl.forward().then((_) {
          if (mounted && !_isConfirmed) {
            _pulseTimer = Timer(const Duration(milliseconds: 1600), () {
              if (mounted && !_isConfirmed) {
                _pulseCtrl.reset();
                _startPulse();
              }
            });
          }
        });
      }
    });
  }

  Future<void> _onMarkRead() async {
    if (_isProcessing || _isConfirmed) return;
    HapticFeedback.lightImpact();
    setState(() => _isProcessing = true);

    // 1. Stop pulse, play tap feedback
    _pulseCtrl.stop();
    await _tapCtrl.forward();
    _tapCtrl.reset();

    // 2. Show check mark
    setState(() => _isConfirmed = true);
    _checkCtrl.forward();

    if (!mounted) return;

    // 3. Show elegant snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Décision consultée',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'La décision a bien été retirée.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: _isAccepted
            ? const Color(0xFF1A7A4A)
            : const Color(0xFFB03A2E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        duration: const Duration(seconds: 3),
      ),
    );

    // 4. Wait briefly, then animate dismissal
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      await _dismissCtrl.forward();
    }

    // 5. Delete from database
    if (mounted) {
      final provider = context.read<InscriptionProvider>();
      await provider.cancelInscription(widget.inscription.id);
    }
  }

  @override
  void dispose() {
    _pulseTimer?.cancel();
    _pulseCtrl.dispose();
    _tapCtrl.dispose();
    _checkCtrl.dispose();
    _dismissCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAccepted = _isAccepted;
    final accentColor = isAccepted
        ? const Color(0xFF1A7A4A)
        : const Color(0xFFB03A2E);
    final accentLight = isAccepted
        ? const Color(0xFFE8F5EE)
        : const Color(0xFFFAEBE9);

    return AnimatedBuilder(
      animation: _dismissCtrl,
      builder: (context, child) {
        return FadeTransition(
          opacity: _dismissOpacity,
          child: SlideTransition(
            position: _dismissSlide,
            child: SizeTransition(
              sizeFactor: Tween<double>(begin: 1.0, end: 0.0).animate(
                CurvedAnimation(
                  parent: _dismissCtrl,
                  curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
                ),
              ),
              axisAlignment: -1,
              child: child,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: accentColor.withOpacity(0.35), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.10),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ──────────────────────────────────────────────
              // IMAGE + CONTENT
              // ──────────────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Formation image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      widget.inscription.formationImageUrl,
                      width: 24.w,
                      height: 24.w,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          color: AppColors.navy2,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.school_rounded,
                          color: Colors.white.withOpacity(0.8),
                          size: 14.w,
                        ),
                      ),
                    ),
                  ),

                  Gap(3.w),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category chip
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.5.w,
                            vertical: 0.4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.pink.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            widget.inscription.formationCategoryName,
                            style: TextStyle(
                              color: AppColors.pink,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        Gap(0.8.h),

                        // Title
                        Text(
                          widget.inscription.formationTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                          ),
                        ),

                        Gap(0.8.h),

                        // Status badge
                        _StatusBadge(
                          isAccepted: isAccepted,
                          accentColor: accentColor,
                          accentLight: accentLight,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Gap(1.5.h),

              // Date row
              if (widget.inscription.createdAt != null)
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 13.sp,
                      color: AppColors.textMute,
                    ),
                    Gap(1.5.w),
                    Text(
                      _formatDate(widget.inscription.createdAt!),
                      style: TextStyle(
                        color: AppColors.textMute,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

              // Centre note (for rejected)
              if (!isAccepted &&
                  widget.inscription.centreNote != null &&
                  widget.inscription.centreNote!.isNotEmpty) ...[
                Gap(1.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: accentColor.withOpacity(0.15)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline_rounded,
                          color: accentColor, size: 15.sp),
                      Gap(2.w),
                      Expanded(
                        child: Text(
                          widget.inscription.centreNote!,
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 10.sp,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              Gap(2.h),

              // ──────────────────────────────────────────────
              // ANIMATED "Lu" BUTTON
              // ──────────────────────────────────────────────
              Center(
                child: _isConfirmed
                    ? _ConfirmCheckWidget(
                        checkScale: _checkScale,
                        checkOpacity: _checkOpacity,
                        accentColor: accentColor,
                      )
                    : AnimatedBuilder(
                        animation: Listenable.merge([_pulseCtrl, _tapCtrl]),
                        builder: (context, child) {
                          final scale = _tapCtrl.isAnimating
                              ? _tapScale.value
                              : _pulseScale.value;
                          final glow = _pulseCtrl.isAnimating
                              ? _pulseGlow.value
                              : 4.0;
                          return Transform.scale(
                            scale: scale,
                            child: GestureDetector(
                              onTap: _onMarkRead,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 1.4.h,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      accentColor,
                                      accentColor.withOpacity(0.75),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: accentColor.withOpacity(0.45),
                                      blurRadius: glow,
                                      spreadRadius: glow * 0.15,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.white,
                                      size: 16.sp,
                                    ),
                                    Gap(2.w),
                                    Text(
                                      'Obligatoire : J\'ai consulté la décision',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.5.sp,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/${m}/${date.year}';
  }
}

// ──────────────────────────────────────────────────────────────
// Status Badge
// ──────────────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final bool isAccepted;
  final Color accentColor;
  final Color accentLight;

  const _StatusBadge({
    required this.isAccepted,
    required this.accentColor,
    required this.accentLight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.8.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: accentLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAccepted ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: accentColor,
            size: 13.sp,
          ),
          Gap(1.5.w),
          Text(
            isAccepted ? 'Acceptee' : 'Refusee',
            style: TextStyle(
              color: accentColor,
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Animated Check Mark shown after confirmation
// ──────────────────────────────────────────────────────────────
class _ConfirmCheckWidget extends StatelessWidget {
  final Animation<double> checkScale;
  final Animation<double> checkOpacity;
  final Color accentColor;

  const _ConfirmCheckWidget({
    required this.checkScale,
    required this.checkOpacity,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: checkScale,
      builder: (context, _) {
        return FadeTransition(
          opacity: checkOpacity,
          child: Transform.scale(
            scale: checkScale.value,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 1.4.h),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: accentColor.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: accentColor,
                    size: 18.sp,
                  ),
                  Gap(2.w),
                  Text(
                    'Consulte',
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
