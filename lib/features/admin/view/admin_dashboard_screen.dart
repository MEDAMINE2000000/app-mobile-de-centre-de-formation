import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';
import 'package:three_alfa_mobile_app/core/widgets/titles_acceuil.dart';
import 'package:three_alfa_mobile_app/features/admin/provider/admin_provider.dart';
import 'package:three_alfa_mobile_app/features/admin/widgets/admin_action_tile.dart';
import 'package:three_alfa_mobile_app/features/admin/widgets/admin_stat_card.dart';
import 'package:three_alfa_mobile_app/features/auth/provider/auth_provider.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadStats();
    });
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Annuler', style: TextStyle(color: AppColors.textMute)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'Déconnexion',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await context.read<AuthProvider>().logout();
    context.read<AdminProvider>().reset();

    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: RefreshIndicator(
        color: AppColors.pink,
        onRefresh: () => context.read<AdminProvider>().loadStats(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(5.w, 6.h, 5.w, 3.h),
                decoration: const BoxDecoration(
                  gradient: AppColors.containerGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.5.w),
                      decoration: BoxDecoration(
                        color: AppColors.pink.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings_rounded,
                        color: Colors.white,
                      ),
                    ),
                    Gap(3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Espace Administrateur',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Three Alfa — Centre de formation',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 10.5.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _confirmLogout,
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              Gap(2.4.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TitlesAcceuil(
                      label: 'Vue d\'ensemble',
                      sousLabel: 'Statistiques en temps réel',
                    ),
                    Gap(1.6.h),

                    if (admin.isLoadingStats)
                      const Center(
                        child: CircularProgressIndicator(color: AppColors.pink),
                      )
                    else
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 3.w,
                        crossAxisSpacing: 3.w,
                        childAspectRatio: 1.25,
                        children: [
                          AdminStatCard(
                            label: 'Utilisateurs',
                            value: '${admin.stats.totalUsers}',
                            icon: Icons.people_alt_rounded,
                            accentColor: AppColors.purple,
                          ),
                          AdminStatCard(
                            label: 'Formations',
                            value: '${admin.stats.totalFormations}',
                            icon: Icons.school_rounded,
                            accentColor: AppColors.pink,
                          ),
                          AdminStatCard(
                            label: 'En attente',
                            value: '${admin.stats.pendingInscriptions}',
                            icon: Icons.hourglass_top_rounded,
                            accentColor: const Color(0xFFF5A623),
                          ),
                          AdminStatCard(
                            label: 'Confirmées',
                            value: '${admin.stats.confirmedInscriptions}',
                            icon: Icons.check_circle_rounded,
                            accentColor: AppColors.success,
                          ),
                        ],
                      ),

                    Gap(2.8.h),

                    const TitlesAcceuil(
                      label: 'Actions',
                      sousLabel: 'Gérer votre centre de formation',
                    ),
                    Gap(1.6.h),

                    AdminActionTile(
                      icon: Icons.how_to_reg_rounded,
                      label: 'Gérer les inscriptions',
                      onTap: () => context.push('/admin/inscriptions'),
                    ),
                    AdminActionTile(
                      icon: Icons.people_outline_rounded,
                      label: 'Gérer les utilisateurs',
                      onTap: () => context.push('/admin/users'),
                    ),
                    AdminActionTile(
                      icon: Icons.menu_book_rounded,
                      label: 'Gérer les formations',
                      onTap: () => context.push('/admin/formations'),
                    ),
                    AdminActionTile(
                      icon: Icons.notifications_none_rounded,
                      label: 'Notifications',
                      onTap: () => context.push('/admin/notifications'),
                    ),
                    AdminActionTile(
                      icon: Icons.settings_outlined,
                      label: 'Paramètres',
                      onTap: () => context.push('/admin/settings'),
                    ),

                    Gap(2.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
