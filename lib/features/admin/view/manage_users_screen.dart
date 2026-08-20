import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

import 'package:three_alfa_mobile_app/features/admin/provider/admin_provider.dart';
import 'package:three_alfa_mobile_app/features/admin/model/user_admin_model.dart';

class _ManageColors {
  static const mainText = Color(0xFF06042E);
  static const mauve = Color(0xFFD36CCE);
  static const tertiary = Color(0xFF58205E);
  static const complementary = Color(0xFF282568);
  static const white = Color(0xFFFFFFFF);
  static const background = Color(0xFFF7F7F9);

  static const iconBackground = Color(0xFFFBEAF9);
}

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedRoleFilter = 'all'; // 'all', 'admin', 'user'

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadAllUsers();
    });

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final users = admin.getFilteredUsers(
      searchQuery: _searchController.text,
      statusFilter: _selectedRoleFilter,
    );

    return Scaffold(
      backgroundColor: _ManageColors.background,
      appBar: AppBar(
        backgroundColor: _ManageColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Utilisateurs',
          style: TextStyle(
            color: _ManageColors.mainText,
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: _ManageColors.mainText,
            size: 20.sp,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Header Section (Search & Filters)
          Container(
            padding: EdgeInsets.only(
              left: 5.w,
              right: 5.w,
              bottom: 2.h,
              top: 1.h,
            ),
            decoration: BoxDecoration(
              color: _ManageColors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: _ManageColors.mauve.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Bar
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 0.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: _ManageColors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _ManageColors.mauve.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Rechercher un utilisateur...',
                      hintStyle: TextStyle(
                        color: _ManageColors.complementary.withOpacity(0.5),
                        fontSize: 13.sp,
                      ),
                      icon: Icon(
                        Icons.search_rounded,
                        color: _ManageColors.mauve,
                        size: 20.sp,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear_rounded, size: 18.sp),
                              color: _ManageColors.mauve,
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                Gap(2.h),
                // Role Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _buildFilterChip('Tous', 'all'),
                      Gap(2.w),
                      _buildFilterChip('Administrateurs', 'admin'),
                      Gap(2.w),
                      _buildFilterChip('Standards', 'user'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Users List
          Expanded(
            child: RefreshIndicator(
              color: _ManageColors.mauve,
              onRefresh: () => context.read<AdminProvider>().loadAllUsers(),
              child: admin.isLoadingUsers
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: _ManageColors.mauve,
                      ),
                    )
                  : admin.hasErrorUsers
                  ? Center(
                      child: Text(
                        admin.errorMessage ?? 'Une erreur est survenue.',
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : users.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline_rounded,
                            size: 40.sp,
                            color: _ManageColors.complementary.withOpacity(0.3),
                          ),
                          Gap(2.h),
                          Text(
                            'Aucun utilisateur trouvé',
                            style: TextStyle(
                              color: _ManageColors.complementary.withOpacity(
                                0.6,
                              ),
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.only(
                        top: 2.h,
                        bottom: 5.h,
                        left: 5.w,
                        right: 5.w,
                      ),
                      itemCount: users.length,
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      separatorBuilder: (context, index) => Gap(2.h),
                      itemBuilder: (context, index) {
                        return _buildUserTile(context, users[index]);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedRoleFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRoleFilter = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.2.h),
        decoration: BoxDecoration(
          color: isSelected ? _ManageColors.mauve : _ManageColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? _ManageColors.mauve
                : _ManageColors.mauve.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _ManageColors.mauve.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? _ManageColors.white
                : _ManageColors.complementary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildUserTile(BuildContext context, UserAdminModel user) {
    final isAdmin = user.role == 'admin';
    final isSuperAdmin = user.isSuperAdmin;
    final String initiales =
        (user.prenom.isNotEmpty ? user.prenom[0].toUpperCase() : '') +
        (user.nom.isNotEmpty ? user.nom[0].toUpperCase() : '');

    return Container(
      decoration: BoxDecoration(
        color: _ManageColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isSuperAdmin
              ? _ManageColors.mauve
              : _ManageColors.mauve.withOpacity(0.5),
          width: isSuperAdmin ? 2.0 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: _ManageColors.mauve.withOpacity(isSuperAdmin ? 0.2 : 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => context.push('/admin/users/${user.uid}', extra: user),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                Container(
                  width: 14.w,
                  height: 14.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [_ManageColors.mauve, _ManageColors.tertiary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _ManageColors.mauve.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initiales.isNotEmpty ? initiales : '?',
                    style: TextStyle(
                      color: _ManageColors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Gap(3.w),

                // Info (Name, Email, Role)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName.isNotEmpty
                            ? user.fullName
                            : 'Utilisateur sans nom',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: _ManageColors.mainText,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Gap(0.3.h),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: _ManageColors.complementary.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Gap(1.5.h),
                      Row(
                        children: [
                          // Role Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.5.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSuperAdmin
                                  ? _ManageColors.mauve.withOpacity(0.1)
                                  : isAdmin
                                  ? _ManageColors.tertiary.withOpacity(0.1)
                                  : _ManageColors.mauve.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSuperAdmin
                                    ? _ManageColors.mauve
                                    : isAdmin
                                    ? _ManageColors.tertiary.withOpacity(0.3)
                                    : _ManageColors.mauve.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                if (isSuperAdmin)
                                  Text('👑', style: TextStyle(fontSize: 10.sp))
                                else
                                  Icon(
                                    isAdmin
                                        ? Icons.admin_panel_settings_rounded
                                        : Icons.person_rounded,
                                    color: isAdmin
                                        ? _ManageColors.tertiary
                                        : _ManageColors.mauve,
                                    size: 12.sp,
                                  ),
                                Gap(1.w),
                                Text(
                                  isSuperAdmin
                                      ? 'Super Administrateur'
                                      : (isAdmin ? 'Admin' : 'Utilisateur'),
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isSuperAdmin
                                        ? _ManageColors.mauve
                                        : (isAdmin
                                              ? _ManageColors.tertiary
                                              : _ManageColors.mauve),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          if (user.createdAt != null && !isSuperAdmin)
                            Text(
                              DateFormat('dd/MM/yyyy').format(user.createdAt!),
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: _ManageColors.complementary.withOpacity(
                                  0.6,
                                ),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                Gap(2.w),

                // Action Icons (Edit & Delete) AFTER the user info
                if (isSuperAdmin)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_rounded,
                        color: _ManageColors.mauve,
                        size: 20.sp,
                      ),
                      Gap(0.5.h),
                      Text(
                        'Compte protégé',
                        style: TextStyle(
                          color: _ManageColors.mauve,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => _showEditSheet(context, user),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: EdgeInsets.all(1.w),
                          child: Icon(
                            Icons.edit_rounded,
                            color: _ManageColors.mauve,
                            size: 20.sp,
                          ),
                        ),
                      ),
                      Gap(1.h),
                      InkWell(
                        onTap: () => _confirmDelete(context, user),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: EdgeInsets.all(1.w),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.red.shade400,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, UserAdminModel user) async {
    final provider = context.read<AdminProvider>();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: _ManageColors.white,
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24.sp),
            Gap(2.w),
            Expanded(
              child: Text(
                "Supprimer l'utilisateur",
                style: TextStyle(
                  color: _ManageColors.mainText,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer l\'utilisateur ${user.fullName} ?\n\nCette action est définitive et supprimera également toutes ses demandes d\'inscription.',
          style: TextStyle(color: _ManageColors.complementary, fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Annuler',
              style: TextStyle(
                color: _ManageColors.complementary,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Supprimer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      final success = await provider.deleteUser(user.uid);
      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Utilisateur supprimé avec succès'),
              backgroundColor: _ManageColors.tertiary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(provider.errorMessage ?? 'Erreur de suppression'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  void _showEditSheet(BuildContext context, UserAdminModel user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EditUserSheet(user: user),
    );
  }
}

class _EditUserSheet extends StatefulWidget {
  final UserAdminModel user;
  const _EditUserSheet({required this.user});

  @override
  State<_EditUserSheet> createState() => _EditUserSheetState();
}

class _EditUserSheetState extends State<_EditUserSheet> {
  late TextEditingController _nomCtrl;
  late TextEditingController _prenomCtrl;
  late TextEditingController _telCtrl;
  late TextEditingController _dateNaissanceCtrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nomCtrl = TextEditingController(text: widget.user.nom);
    _prenomCtrl = TextEditingController(text: widget.user.prenom);
    _telCtrl = TextEditingController(text: widget.user.telephone);
    _dateNaissanceCtrl = TextEditingController(text: widget.user.dateNaissance);
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _telCtrl.dispose();
    _dateNaissanceCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);
    final provider = context.read<AdminProvider>();

    final data = {
      'nom': _nomCtrl.text.trim(),
      'prenom': _prenomCtrl.text.trim(),
      'telephone': _telCtrl.text.trim(),
      'dateNaissance': _dateNaissanceCtrl.text.trim(),
    };

    final success = await provider.updateUserDetails(widget.user.uid, data);

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Informations mises à jour avec succès'),
            backgroundColor: _ManageColors.mauve,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Erreur de modification'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 2.h,
        left: 6.w,
        right: 6.w,
        top: 3.h,
      ),
      decoration: const BoxDecoration(
        color: _ManageColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 15.w,
                height: 5,
                decoration: BoxDecoration(
                  color: _ManageColors.complementary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Gap(3.h),
            Row(
              children: [
                Icon(
                  Icons.edit_document,
                  color: _ManageColors.mauve,
                  size: 24.sp,
                ),
                Gap(2.w),
                Text(
                  "Modifier l'utilisateur",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: _ManageColors.mainText,
                  ),
                ),
              ],
            ),
            Gap(3.h),
            _buildTextField('Nom', _nomCtrl, Icons.person_outline),
            Gap(2.h),
            _buildTextField('Prénom', _prenomCtrl, Icons.person_outline),
            Gap(2.h),
            _buildTextField(
              'Téléphone',
              _telCtrl,
              Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            Gap(2.h),
            _buildTextField(
              'Date de naissance',
              _dateNaissanceCtrl,
              Icons.calendar_today_outlined,
            ),
            Gap(4.h),
            SizedBox(
              width: double.infinity,
              height: 6.5.h,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _ManageColors.mauve,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  shadowColor: _ManageColors.mauve.withOpacity(0.5),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Enregistrer',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            Gap(2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: _ManageColors.complementary,
          ),
        ),
        Gap(1.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(
            fontSize: 14.sp,
            color: _ManageColors.mainText,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: _ManageColors.mauve, size: 18.sp),
            filled: true,
            fillColor: _ManageColors.iconBackground,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 1.5.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: _ManageColors.mauve,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
