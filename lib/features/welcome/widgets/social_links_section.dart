import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLinksSection extends StatelessWidget {
  const SocialLinksSection({super.key});

  Future<void> _openLink(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);

    try {
      final bool ok = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!ok && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Impossible d’ouvrir : $url')));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Impossible d’ouvrir : $url')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Suivez-nous sur les réseaux',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF000027),
          ),
        ),

        Gap(2.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialIconButton(
              icon: Icons.facebook,
              color: const Color(0xFF1877F2),
              onTap: () => _openLink(
                context,
                'https://www.facebook.com/centreThreealfa',
              ),
            ),

            Gap(4.w),

            _SocialIconButton(
              icon: Icons.camera_alt,
              color: const Color(0xFFE1306C),
              onTap: () => _openLink(
                context,
                'https://www.instagram.com/three_alfa_formation/',
              ),
            ),

            Gap(4.w),

            _SocialIconButton(
              icon: Icons.business,
              color: const Color(0xFF0A66C2),
              onTap: () => _openLink(
                context,
                'https://www.linkedin.com/company/centre-three-alfa-formation/posts/?feedView=all',
              ),
            ),

            Gap(4.w),

            _SocialIconButton(
              icon: Icons.language,
              color: const Color(0xFF6C3EBF),
              onTap: () => _openLink(context, 'https://three-alfa.com/'),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialIconButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<_SocialIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _scale;
  late Animation<double> _move;
  late Animation<double> _particles;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scale = Tween<double>(
      begin: 1,
      end: 1.25,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _move = Tween<double>(
      begin: 0,
      end: -12,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _particles = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    // animation الأول
    _controller.forward();

    // نستنى قبل فتح الرابط
    Future.delayed(const Duration(milliseconds: 1000), () {
      widget.onTap();

      // رجوع الزر
      Future.delayed(const Duration(milliseconds: 500), () {
        _controller.reverse();
      });
    });
  }

  void _tapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _tapDown,

      onTapUp: _tapUp,

      onTapCancel: _tapCancel,

      child: AnimatedBuilder(
        animation: _controller,

        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _move.value),

            child: Transform.scale(
              scale: _scale.value,

              child: Stack(
                alignment: Alignment.center,

                children: [
                  // ✨ points effect
                  ...List.generate(8, (index) {
                    double angle = index * (math.pi / 4);

                    double distance = _particles.value * 55;

                    return Transform.translate(
                      offset: Offset(
                        math.cos(angle) * distance,

                        math.sin(angle) * distance,
                      ),

                      child: Opacity(
                        opacity: 1 - (_particles.value * 0.7),

                        child: Container(
                          width: 7,

                          height: 7,

                          decoration: BoxDecoration(
                            color: widget.color,

                            shape: BoxShape.circle,

                            boxShadow: [
                              BoxShadow(
                                color: widget.color.withOpacity(0.7),

                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  Container(
                    width: 14.w,

                    height: 14.w,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: Colors.white,

                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withOpacity(
                            0.35 + (_controller.value * 0.5),
                          ),

                          blurRadius: 18 + (_controller.value * 20),

                          spreadRadius: 2 + (_controller.value * 4),
                        ),
                      ],
                    ),

                    child: Center(
                      child: Icon(
                        widget.icon,

                        color: widget.color,

                        size: 6.5.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
