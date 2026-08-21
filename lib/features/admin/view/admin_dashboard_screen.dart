import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:three_alfa_mobile_app/core/utils/performance_monitor.dart';
=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
<<<<<<< HEAD
import 'package:flutter_animate/flutter_animate.dart';

import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';
import 'package:three_alfa_mobile_app/features/admin/provider/admin_provider.dart';
=======

import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';
import 'package:three_alfa_mobile_app/core/widgets/titles_acceuil.dart';
import 'package:three_alfa_mobile_app/features/admin/provider/admin_provider.dart';
import 'package:three_alfa_mobile_app/features/admin/widgets/admin_action_tile.dart';
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
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
<<<<<<< HEAD
      PerformanceMonitor.stop('connexion', customMessage: 'Temps de connexion');
      PerformanceMonitor.stop('nav_Login_Admin', customMessage: 'Temps de navigation [Login -> Admin]');
=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      context.read<AdminProvider>().loadStats();
    });
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
<<<<<<< HEAD
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: AppColors.error,
                  size: 24.sp,
                ),
              ),
              Gap(3.h),
              Text(
                'Déconnexion',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              Gap(1.h),
              Text(
                'Voulez-vous vraiment vous déconnecter de l\'espace administration ?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp, color: AppColors.textMute),
              ),
              Gap(4.h),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Annuler',
                        style: TextStyle(
                          color: AppColors.textMute,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Gap(3.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Déconnexion',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
=======
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
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
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
<<<<<<< HEAD
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildHeader(),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeSection()
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.1, end: 0),
                    Gap(4.h),
                    _buildQuickActions()
                        .animate()
                        .fadeIn(delay: 100.ms, duration: 400.ms)
                        .slideY(begin: 0.1, end: 0),
                    Gap(4.h),
                    _buildOverviewSection(admin)
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 400.ms)
                        .slideY(begin: 0.1, end: 0),
                    Gap(4.h),
                    _buildManagementSection()
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 400.ms)
                        .slideY(begin: 0.1, end: 0),
                    Gap(6.h),
                    _buildLogoutButton().animate().fadeIn(
                      delay: 400.ms,
                      duration: 400.ms,
                    ),
                    Gap(4.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      expandedHeight: 14.h,
      pinned: true,
      backgroundColor: const Color(0xFF06042E),
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/welcome/three_alfa_logo.png',
              height: 25.sp,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.business,
                color: const Color(0xFF06042E),
                size: 25.sp,
              ),
            ),
          ),
          Gap(3.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Three Alfa',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              Text(
                'Administration',
                style: TextStyle(
                  color: AppColors.pink,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_rounded, color: Colors.white, size: 20.sp),
          ),
        ],
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFD63384), Color(0xFF58205E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFD63384),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Espace Admin',
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.w900,
            color: AppColors.textDark,
            letterSpacing: -0.5,
          ),
        ),
        Gap(1.h),
        Text(
          'Gérez les utilisateurs, les inscriptions et les formations depuis votre tableau de bord.',
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textMute,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Accès rapides',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        Gap(2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildQuickActionButton(
              icon: Icons.people_alt_rounded,
              label: 'Utilisateurs',
              color: const Color(0xFF4A90E2),
              onTap: () => context.push('/admin/users'),
            ),
            _buildQuickActionButton(
              icon: Icons.how_to_reg_rounded,
              label: 'Inscriptions',
              color: AppColors.purple,
              onTap: () => context.push('/admin/inscriptions'),
            ),
            _buildQuickActionButton(
              icon: Icons.school_rounded,
              label: 'Formations',
              color: AppColors.warning,
              onTap: () => context.push('/admin/formations'),
            ),
            _buildQuickActionButton(
              icon: Icons.bar_chart_rounded,
              label: 'Statistiques',
              color: AppColors.pink,
              onTap: () => context.push('/admin/statistics'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 22.sp),
          ),
          Gap(1.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewSection(AdminProvider admin) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vue d\'ensemble',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        Gap(2.h),
        if (admin.isLoadingStats)
          const Center(child: CircularProgressIndicator(color: AppColors.pink))
        else
          Column(
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 3.w,
                crossAxisSpacing: 3.w,
                childAspectRatio: 1.1,
                children: [
                  AdminStatCard(
                    label: 'Total Utilisateurs',
                    value: '${admin.stats.totalUsers}',
                    icon: Icons.group_rounded,
                    accentColor: AppColors.pink,
                  ),
                  AdminStatCard(
                    label: 'Administrateurs',
                    value: '${admin.stats.totalAdmins}',
                    icon: Icons.admin_panel_settings_rounded,
                    accentColor: AppColors.purple,
                  ),
                  AdminStatCard(
                    label: 'Utilisateurs standards',
                    value: '${admin.stats.totalNormalUsers}',
                    icon: Icons.person_outline_rounded,
                    accentColor: const Color(0xFF4A90E2),
                  ),
                  AdminStatCard(
                    label: 'Inscriptions en attente',
                    value: '${admin.stats.pendingInscriptions}',
                    icon: Icons.hourglass_top_rounded,
                    accentColor: const Color(0xFFF5A623),
                  ),
                ],
              ),
              Gap(3.w),
              // Big Statistics Card
              GestureDetector(
                onTap: () => context.push('/admin/statistics'),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF282568), Color(0xFF58205E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF58205E).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.bar_chart_rounded,
                          color: Colors.white,
                          size: 28.sp,
                        ),
                      ),
                      Gap(4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Statistiques & Analyses',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Gap(0.5.h),
                            Text(
                              'Consultez les graphiques détaillés',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white70,
                        size: 16.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildManagementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gestion',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        Gap(2.h),
        _buildActionCard(
          title: 'Gérer les utilisateurs',
          subtitle:
              'Accédez à la liste complète, modifiez les rôles et consultez les détails.',
          icon: Icons.people_alt_rounded,
          color: const Color(0xFF4A90E2),
          onTap: () => context.push('/admin/users'),
        ),
        Gap(2.h),
        _buildActionCard(
          title: 'Gérer les inscriptions',
          subtitle: 'Consultez et validez les demandes d\'inscription.',
          icon: Icons.assignment_ind_rounded,
          color: AppColors.purple,
          onTap: () => context.push('/admin/inscriptions'),
          badgeCount: context.watch<AdminProvider>().stats.pendingInscriptions,
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    int? badgeCount,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          highlightColor: color.withOpacity(0.05),
          splashColor: color.withOpacity(0.1),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 24.sp),
                ),
                Gap(4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          if (badgeCount != null && badgeCount > 0) ...[
                            Gap(2.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.warning,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$badgeCount',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Gap(0.8.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textMute,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(2.w),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.textMute.withOpacity(0.5),
                  size: 16.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _confirmLogout,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error.withOpacity(0.1),
          foregroundColor: AppColors.error,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 1.8.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: Icon(Icons.logout_rounded, size: 18.sp),
        label: Text(
          'Se déconnecter',
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
        ),
=======
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
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      ),
    );
  }
}
