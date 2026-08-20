import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:three_alfa_mobile_app/features/admin/model/user_admin_model.dart';
import 'package:three_alfa_mobile_app/features/admin/provider/admin_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class _ProfileColors {
  // ============================================================
  // PALETTE
  // ============================================================

  // Couleur principale
  static const mainText = Color(0xFF06042E);

  // Mauve principal
  static const mauve = Color(0xFFD36CCE);

  // Mauve foncé
  static const tertiary = Color(0xFF58205E);

  // Couleur complémentaire
  static const complementary = Color(0xFF282568);

  // Blanc
  static const white = Color(0xFFFFFFFF);

  // Background général de la page
  static const background = Color(0xFFF7F7F9);

  // Background très léger des icônes
  static const iconBackground = Color(0xFFFBEAF9);

  // IMPORTANT :
  // Background des containers = BLANC
  static const cardBackground = Color(0xFFFFFFFF);

  // Bordure des containers
  static const cardBorder = Color(0xFFD36CCE);

  // Couleur des attributs / labels
  static const labelColor = Color(0xFFD36CCE);

  // Couleur des valeurs
  static const valueColor = Color(0xFF06042E);
}

class UserDetailsScreen extends StatelessWidget {
  final UserAdminModel user;

  const UserDetailsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final adminProvider = context.watch<AdminProvider>();

    final latestUser = adminProvider.allUsers.firstWhere(
      (u) => u.uid == user.uid,
      orElse: () => user,
    );

    final isAdmin = latestUser.role == 'admin';

    final String initiales =
        (latestUser.prenom.isNotEmpty
            ? latestUser.prenom[0].toUpperCase()
            : '') +
        (latestUser.nom.isNotEmpty ? latestUser.nom[0].toUpperCase() : '');

    return Scaffold(
      backgroundColor: _ProfileColors.background,

      // ==========================================================
      // APP BAR
      // ==========================================================
      appBar: AppBar(
        backgroundColor: _ProfileColors.white,
        elevation: 0,
        centerTitle: true,

        title: Text(
          'Profil Utilisateur',
          style: TextStyle(
            color: _ProfileColors.mainText,
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
          ),
        ),

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: _ProfileColors.mainText,
            size: 20.sp,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),

      // ==========================================================
      // BODY
      // ==========================================================
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),

        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ====================================================
              // HEADER PROFILE
              // ====================================================
              _buildHeaderCard(latestUser, isAdmin, initiales)
                  .animate()
                  .fade(duration: 400.ms)
                  .slideY(begin: 0.1, end: 0, curve: Curves.easeOut),

              Gap(3.h),

              // ====================================================
              // INFORMATIONS PERSONNELLES
              // ====================================================
              _buildSectionTitle(
                'Informations Personnelles',
              ).animate().fade(delay: 100.ms),

              Gap(1.5.h),

              _buildInfoCard(
                Icons.person_outline_rounded,
                'Nom',
                latestUser.nom.isNotEmpty ? latestUser.nom : 'Non renseigné',
              ).animate().fade(delay: 200.ms).slideX(begin: 0.05),

              Gap(1.2.h),

              _buildInfoCard(
                Icons.badge_outlined,
                'Prénom',
                latestUser.prenom.isNotEmpty
                    ? latestUser.prenom
                    : 'Non renseigné',
              ).animate().fade(delay: 300.ms).slideX(begin: 0.05),

              Gap(1.2.h),

              _buildInfoCard(
                Icons.calendar_today_rounded,
                'Date de naissance',
                latestUser.dateNaissance.isNotEmpty
                    ? latestUser.dateNaissance
                    : 'Non renseigné',
              ).animate().fade(delay: 400.ms).slideX(begin: 0.05),

              Gap(3.h),

              // ====================================================
              // COORDONNÉES & CONTACT
              // ====================================================
              _buildSectionTitle(
                'Coordonnées & Contact',
              ).animate().fade(delay: 500.ms),

              Gap(1.5.h),

              _buildInfoCard(
                Icons.phone_outlined,
                'Téléphone',
                latestUser.telephone.isNotEmpty
                    ? latestUser.telephone
                    : 'Non renseigné',
              ).animate().fade(delay: 600.ms).slideX(begin: 0.05),

              Gap(1.2.h),

              _buildInfoCard(
                Icons.email_outlined,
                'Email',
                latestUser.email.isNotEmpty
                    ? latestUser.email
                    : 'Non renseigné',
              ).animate().fade(delay: 700.ms).slideX(begin: 0.05),

              Gap(3.h),

              // ====================================================
              // INFORMATIONS DU COMPTE
              // ====================================================
              _buildSectionTitle(
                'Informations du Compte',
              ).animate().fade(delay: 800.ms),

              Gap(1.5.h),

              _buildInfoCard(
                Icons.fingerprint_rounded,
                'ID',
                latestUser.uid,
              ).animate().fade(delay: 900.ms).slideX(begin: 0.05),

              Gap(1.2.h),

              _buildInfoCard(
                Icons.access_time_rounded,
                'Créé le',
                latestUser.createdAt != null
                    ? DateFormat(
                        'dd MMMM yyyy, à HH:mm',
                      ).format(latestUser.createdAt!)
                    : 'Non renseigné',
              ).animate().fade(delay: 1000.ms).slideX(begin: 0.05),

              Gap(3.h),

              // ====================================================
              // SÉCURITÉ DU COMPTE
              // ====================================================
              _buildSectionTitle(
                'Sécurité du compte',
              ).animate().fade(delay: 1100.ms),

              Gap(1.5.h),

              _buildRoleManagementCard(
                context,
                latestUser,
                isAdmin,
              ).animate().fade(delay: 1200.ms).slideY(begin: 0.05),

              Gap(5.h),
            ],
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // SECTION TITLE
  // ==============================================================

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 1.w),

      child: Text(
        title,

        style: TextStyle(
          fontSize: 17.sp,
          fontWeight: FontWeight.bold,
          color: _ProfileColors.mainText,
        ),
      ),
    );
  }

  // ==============================================================
  // HEADER PROFILE
  // ==============================================================

  Widget _buildHeaderCard(UserAdminModel user, bool isAdmin, String initiales) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(6.w),

      decoration: BoxDecoration(
        // WHITE
        color: _ProfileColors.white,

        borderRadius: BorderRadius.circular(28),

        // Mauve border
        border: Border.all(
          color: _ProfileColors.mauve.withOpacity(0.35),
          width: 1.5,
        ),

        boxShadow: [
          BoxShadow(
            color: _ProfileColors.mauve.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        children: [
          // ========================================================
          // AVATAR
          // ========================================================
          Container(
            padding: const EdgeInsets.all(3),

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              gradient: const LinearGradient(
                colors: [_ProfileColors.mauve, _ProfileColors.tertiary],

                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),

              boxShadow: [
                BoxShadow(
                  color: _ProfileColors.mauve.withOpacity(0.30),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),

            child: Container(
              width: 26.w,
              height: 26.w,

              decoration: const BoxDecoration(
                shape: BoxShape.circle,

                gradient: LinearGradient(
                  colors: [_ProfileColors.mauve, _ProfileColors.tertiary],

                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),

              alignment: Alignment.center,

              child: Text(
                initiales.isNotEmpty ? initiales : '?',

                style: TextStyle(
                  color: _ProfileColors.white,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Gap(2.h),

          // ========================================================
          // NOM COMPLET
          // ========================================================
          Text(
            user.fullName.isNotEmpty ? user.fullName : 'Non renseigné',

            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: _ProfileColors.mainText,
              letterSpacing: -0.5,
            ),

            textAlign: TextAlign.center,
          ),

          Gap(0.5.h),

          // ========================================================
          // EMAIL
          // ========================================================
          Text(
            user.email,

            style: TextStyle(
              fontSize: 14.sp,
              color: _ProfileColors.tertiary,
              fontWeight: FontWeight.w500,
            ),

            textAlign: TextAlign.center,

            overflow: TextOverflow.ellipsis,
          ),

          Gap(2.h),

          // ========================================================
          // ROLE BADGE
          // ========================================================
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),

            decoration: BoxDecoration(
              color: _ProfileColors.mauve.withOpacity(0.10),

              borderRadius: BorderRadius.circular(20),

              border: Border.all(
                color: _ProfileColors.mauve.withOpacity(0.45),
                width: 1.2,
              ),
            ),

            child: Row(
              mainAxisSize: MainAxisSize.min,

              children: [
                if (user.isSuperAdmin)
                  Text('👑', style: TextStyle(fontSize: 14.sp))
                else
                  Icon(
                    isAdmin
                        ? Icons.admin_panel_settings_rounded
                        : Icons.person_rounded,

                    color: _ProfileColors.mauve,
                    size: 15.sp,
                  ),

                Gap(2.w),

                Text(
                  user.isSuperAdmin
                      ? 'Super Administrateur'
                      : (isAdmin ? 'Administrateur' : 'Utilisateur'),

                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: _ProfileColors.mauve,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // INFORMATION CARD
  // ==============================================================

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),

      decoration: BoxDecoration(
        // ========================================================
        // IMPORTANT :
        // Background du container = BLANC
        // ========================================================
        color: _ProfileColors.white,

        borderRadius: BorderRadius.circular(20),

        // ========================================================
        // BORDER = MAUVE
        // ========================================================
        border: Border.all(color: _ProfileColors.mauve, width: 1.2),

        boxShadow: [
          BoxShadow(
            color: _ProfileColors.mauve.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          // ========================================================
          // ICON
          // ========================================================
          Container(
            padding: EdgeInsets.all(2.5.w),

            decoration: BoxDecoration(
              color: _ProfileColors.iconBackground,

              shape: BoxShape.circle,

              border: Border.all(
                color: _ProfileColors.mauve.withOpacity(0.20),
                width: 1,
              ),
            ),

            child: Icon(icon, color: _ProfileColors.mauve, size: 16.sp),
          ),

          Gap(4.w),

          // ========================================================
          // LABEL + VALUE
          // ========================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // ==================================================
                // ATTRIBUT
                // #D36CCE
                // ==================================================
                Text(
                  label,

                  style: TextStyle(
                    fontSize: 15.sp,
                    color: _ProfileColors.labelColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Gap(0.4.h),

                // ==================================================
                // VALEUR
                // #06042E
                // ==================================================
                Text(
                  value,

                  style: TextStyle(
                    fontSize: 15.sp,
                    color: _ProfileColors.valueColor,
                    fontWeight: FontWeight.w700,
                  ),

                  softWrap: true,

                  maxLines: 3,

                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // ROLE MANAGEMENT CARD
  // ==============================================================

  Widget _buildRoleManagementCard(
    BuildContext context,
    UserAdminModel latestUser,
    bool isAdmin,
  ) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(5.w),

      decoration: BoxDecoration(
        // WHITE
        color: _ProfileColors.white,

        borderRadius: BorderRadius.circular(22),

        // MAUVE BORDER
        border: Border.all(color: _ProfileColors.mauve, width: 1.2),

        boxShadow: [
          BoxShadow(
            color: _ProfileColors.mauve.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ========================================================
          // TITLE
          // ========================================================
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.5.w),

                decoration: BoxDecoration(
                  color: _ProfileColors.iconBackground,

                  shape: BoxShape.circle,

                  border: Border.all(
                    color: _ProfileColors.mauve.withOpacity(0.20),
                    width: 1,
                  ),
                ),

                child: Icon(
                  latestUser.isSuperAdmin
                      ? Icons.lock_outline_rounded
                      : Icons.shield_outlined,

                  color: _ProfileColors.mauve,

                  size: 20.sp,
                ),
              ),

              Gap(3.w),

              Expanded(
                child: Text(
                  latestUser.isSuperAdmin ? 'Sécurité' : 'Modifier le rôle',

                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: _ProfileColors.mainText,
                  ),
                ),
              ),
            ],
          ),

          Gap(2.h),

          if (latestUser.isSuperAdmin)
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: _ProfileColors.mauve.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _ProfileColors.mauve.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: _ProfileColors.mauve,
                    size: 20.sp,
                  ),
                  Gap(3.w),
                  Expanded(
                    child: Text(
                      'Ce compte est protégé. Le rôle de Super Administrateur ne peut pas être modifié.',
                      style: TextStyle(
                        color: _ProfileColors.mainText,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            // ========================================================
            // ROLE SELECTOR
            // ========================================================
            Container(
              height: 6.5.h,

              padding: EdgeInsets.all(1.w),

              decoration: BoxDecoration(
                color: _ProfileColors.iconBackground,

                borderRadius: BorderRadius.circular(16),

                border: Border.all(
                  color: _ProfileColors.mauve.withOpacity(0.20),
                  width: 1,
                ),
              ),

              child: Row(
                children: [
                  // ==================================================
                  // UTILISATEUR
                  // ==================================================
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _updateRole(context, latestUser, 'user');
                      },

                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),

                        curve: Curves.easeInOut,

                        alignment: Alignment.center,

                        decoration: BoxDecoration(
                          color: !isAdmin
                              ? _ProfileColors.mauve
                              : Colors.transparent,

                          borderRadius: BorderRadius.circular(12),

                          boxShadow: !isAdmin
                              ? [
                                  BoxShadow(
                                    color: _ProfileColors.mauve.withOpacity(
                                      0.25,
                                    ),

                                    blurRadius: 7,

                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),

                        child: Text(
                          'Utilisateur',

                          style: TextStyle(
                            color: !isAdmin
                                ? _ProfileColors.white
                                : _ProfileColors.tertiary,

                            fontWeight: !isAdmin
                                ? FontWeight.bold
                                : FontWeight.w500,

                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ==================================================
                  // ADMINISTRATEUR
                  // ==================================================
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _updateRole(context, latestUser, 'admin');
                      },

                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),

                        curve: Curves.easeInOut,

                        alignment: Alignment.center,

                        decoration: BoxDecoration(
                          color: isAdmin
                              ? _ProfileColors.mauve
                              : Colors.transparent,

                          borderRadius: BorderRadius.circular(12),

                          boxShadow: isAdmin
                              ? [
                                  BoxShadow(
                                    color: _ProfileColors.mauve.withOpacity(
                                      0.30,
                                    ),

                                    blurRadius: 8,

                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),

                        child: Text(
                          'Administrateur',

                          style: TextStyle(
                            color: isAdmin
                                ? _ProfileColors.white
                                : _ProfileColors.tertiary,

                            fontWeight: isAdmin
                                ? FontWeight.bold
                                : FontWeight.w500,

                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ==============================================================
  // UPDATE ROLE
  // ==============================================================

  Future<void> _updateRole(
    BuildContext context,
    UserAdminModel latestUser,
    String newRole,
  ) async {
    // Le rôle est déjà le même
    if (latestUser.role == newRole) {
      return;
    }

    final success = await context.read<AdminProvider>().updateUserRole(
      latestUser.uid,
      newRole,
    );

    // ============================================================
    // SUCCESS
    // ============================================================

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rôle mis à jour avec succès'),

          backgroundColor: _ProfileColors.mauve,

          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    // ============================================================
    // ERROR
    // ============================================================
    else if (context.mounted) {
      final error = context.read<AdminProvider>().errorMessage;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Erreur lors de la mise à jour'),

          backgroundColor: Colors.red,

          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
