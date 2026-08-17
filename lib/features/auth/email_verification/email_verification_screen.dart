import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:three_alfa_mobile_app/core/widgets/shared_button.dart';
import 'package:three_alfa_mobile_app/features/auth/provider/auth_provider.dart';
import 'package:three_alfa_mobile_app/features/auth/widgets/login_logo_header.dart';
import 'package:three_alfa_mobile_app/features/auth/widgets/login_title_section.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: 100.w,
        height: 100.h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E0F3D), Color(0xFF120821)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                Gap(4.h),
                const LoginLogoHeader(),
                Gap(3.h),

                // ── Card container (same style as login / register) ──
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 3.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Column(
                    children: [
                      const LoginTitleSection(
                        label: 'Vérifiez votre e-mail',
                        sousLabel: 'Un e-mail de vérification a été envoyé',
                      ),
                      Gap(2.h),

                      // ── Icon ──
                      Icon(
                        Icons.mark_email_unread_outlined,
                        color: const Color(0xFFE0388B),
                        size: 50.sp,
                      ),
                      Gap(2.h),

                      // ── Instructions ──
                      Text(
                        'Veuillez vérifier votre boîte de réception et cliquer sur le lien de vérification.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13.sp,
                        ),
                      ),
                      Gap(3.h),

                      // ── Check verification button ──
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          return SizedBox(
                            width: double.infinity,
                            child: SharedButton(
                              isLoading: authProvider.isLoading,
                              onPressed: () async {
                                final verified = await authProvider
                                    .checkEmailVerification();
                                if (!context.mounted) return;
                                if (verified) {
                                  context.go('/');
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        authProvider.errorMessage ??
                                            'Email non vérifié.',
                                      ),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                }
                              },
                              label: "J'ai vérifié mon email",
                              icon: Icons.check_circle_outline,
                            ),
                          );
                        },
                      ),
                      Gap(2.h),

                      // ── Resend verification email ──
                      GestureDetector(
                        onTap: () async {
                          final authProvider = context.read<AuthProvider>();
                          await authProvider.sendEmailVerification();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Email de vérification renvoyé.'),
                              backgroundColor: Color(0xFFE0388B),
                            ),
                          );
                        },
                        child: Text(
                          'Renvoyer l\'email de vérification',
                          style: TextStyle(
                            color: const Color(0xFFE0388B),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Gap(2.h),

                      // ── Logout / switch account ──
                      GestureDetector(
                        onTap: () async {
                          await context.read<AuthProvider>().logout();
                          if (!context.mounted) return;
                          context.go('/login');
                        },
                        child: Text(
                          'Se déconnecter',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(3.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
