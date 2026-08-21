import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';
import 'package:three_alfa_mobile_app/features/admin/provider/admin_provider.dart';
import 'package:three_alfa_mobile_app/features/inscription/model/inscription_model.dart';
<<<<<<< HEAD
=======
import 'package:three_alfa_mobile_app/features/inscription/widgets/inscription_status_badge.dart';
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1

class ManageInscriptionsScreen extends StatefulWidget {
  const ManageInscriptionsScreen({super.key});

  @override
  State<ManageInscriptionsScreen> createState() =>
      _ManageInscriptionsScreenState();
}

class _ManageInscriptionsScreenState extends State<ManageInscriptionsScreen> {
  String _statusFilter = 'all';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadData() {
    context.read<AdminProvider>().loadAllInscriptions();
  }

<<<<<<< HEAD
=======
  void _changeFilter(String value) {
    setState(() {
      _statusFilter = value;
    });
  }

>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
  Future<void> _confirmAccept(InscriptionModel inscription) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Accepter l\'inscription'),
        content: Text(
          'Voulez-vous vraiment accepter l\'inscription de ${inscription.userFullName} à "${inscription.formationTitle}" ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Annuler', style: TextStyle(color: AppColors.textMute)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Accepter',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final provider = context.read<AdminProvider>();
    final success = await provider.confirmInscription(inscription.id);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? (provider.successMessage ?? 'Inscription acceptée.')
              : (provider.errorMessage ?? 'Erreur.'),
        ),
        backgroundColor: success ? AppColors.success : AppColors.error,
      ),
    );
  }

<<<<<<< HEAD
  Future<void> _confirmDelete(InscriptionModel inscription) async {
    final provider = context.read<AdminProvider>();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'inscription'),
        content: Text('Voulez-vous vraiment supprimer cette demande d\'inscription ? Cette action est irréversible et l\'étudiant ne la verra plus.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final success = await provider.deleteInscription(inscription.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? (provider.successMessage ?? 'Inscription supprimée.')
                  : (provider.errorMessage ?? 'Erreur lors de la suppression.'),
            ),
            backgroundColor: success ? AppColors.success : AppColors.error,
          ),
        );
      }
    }
  }

=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
  Future<void> _confirmReject(InscriptionModel inscription) async {
    final noteController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Refuser l\'inscription'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Voulez-vous vraiment refuser l\'inscription de ${inscription.userFullName} ?',
              style: TextStyle(fontSize: 11.sp),
            ),
            Gap(1.5.h),
            TextField(
              controller: noteController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Note / Raison du refus (optionnel)',
                hintStyle: TextStyle(
                  fontSize: 10.sp,
                  color: AppColors.textMute,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Annuler', style: TextStyle(color: AppColors.textMute)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Refuser', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final provider = context.read<AdminProvider>();
    final success = await provider.rejectInscription(
      inscription.id,
      note: noteController.text,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? (provider.successMessage ?? 'Inscription refusée.')
              : (provider.errorMessage ?? 'Erreur.'),
        ),
        backgroundColor: success ? AppColors.success : AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final filteredList = admin.getFilteredInscriptions(
      searchQuery: _searchController.text,
      statusFilter: _statusFilter,
    );

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        elevation: 0,
        title: Text(
          'Gestion des Inscriptions',
          style: TextStyle(
            color: Colors.white,
<<<<<<< HEAD
            fontSize: 20.sp,
=======
            fontSize: 14.sp,
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // ── Search & Filter Section ──
          Container(
            color: AppColors.navy,
            padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.h),
            child: Column(
              children: [
                // Search TextField
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Rechercher par nom, email, tél, formation...',
                    hintStyle: TextStyle(
                      color: AppColors.textMute,
<<<<<<< HEAD
                      fontSize: 13.sp,
=======
                      fontSize: 11.sp,
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.textMute,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear_rounded,
                              color: AppColors.textMute,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 1.2.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
<<<<<<< HEAD
=======
                Gap(1.5.h),
                // Filter Chips Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'Toutes',
                        value: 'all',
                        current: _statusFilter,
                        onTap: _changeFilter,
                      ),
                      Gap(2.w),
                      _FilterChip(
                        label: 'En attente',
                        value: 'pending',
                        current: _statusFilter,
                        onTap: _changeFilter,
                      ),
                      Gap(2.w),
                      _FilterChip(
                        label: 'Acceptées',
                        value: 'confirmed',
                        current: _statusFilter,
                        onTap: _changeFilter,
                      ),
                      Gap(2.w),
                      _FilterChip(
                        label: 'Refusées',
                        value: 'rejected',
                        current: _statusFilter,
                        onTap: _changeFilter,
                      ),
                    ],
                  ),
                ),
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
              ],
            ),
          ),

          // ── Main Content Body ──
          Expanded(
            child: RefreshIndicator(
              color: AppColors.pink,
              onRefresh: () async => _loadData(),
              child: _buildListBody(admin, filteredList),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListBody(
    AdminProvider admin,
    List<InscriptionModel> filteredList,
  ) {
    // 1. Loading State
    if (admin.isLoadingInscriptions && admin.allInscriptions.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.pink),
      );
    }

    // 2. Error State with Retry
    if (admin.hasErrorInscriptions && admin.allInscriptions.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: AppColors.error,
                size: 14.w,
              ),
              Gap(1.6.h),
              Text(
                admin.errorMessage ?? 'Erreur lors du chargement des données.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textDark, fontSize: 12.sp),
              ),
              Gap(2.h),
              ElevatedButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                label: const Text(
                  'Réessayer',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 3. Empty State
    if (filteredList.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: 15.h),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  color: AppColors.textMute,
                  size: 14.w,
                ),
                Gap(1.6.h),
                Text(
                  'Aucune inscription trouvée.',
                  style: TextStyle(
                    color: AppColors.textMute,
<<<<<<< HEAD
                    fontSize: 16.sp,
=======
                    fontSize: 12.sp,
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

<<<<<<< HEAD
    // 4. Group by User
    final groupedInscriptions = <String, List<InscriptionModel>>{};
    for (final inscription in filteredList) {
      final key = inscription.userId; // Group by user
      groupedInscriptions.putIfAbsent(key, () => []).add(inscription);
    }
    final userIds = groupedInscriptions.keys.toList();

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      itemCount: userIds.length,
      itemBuilder: (context, index) {
        final userId = userIds[index];
        final userInscriptions = groupedInscriptions[userId]!;

        return _UserInscriptionGroupCard(
          inscriptions: userInscriptions,
          adminProvider: admin,
          onAccept: _confirmAccept,
          onReject: _confirmReject,
          onDelete: _confirmDelete,
=======
    // 4. Inscription Cards List
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final inscription = filteredList[index];
        final isProcessing = admin.isProcessingId(inscription.id);

        return _AdminInscriptionCard(
          inscription: inscription,
          isProcessing: isProcessing,
          onAccept: () => _confirmAccept(inscription),
          onReject: () => _confirmReject(inscription),
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
        );
      },
    );
  }
}

<<<<<<< HEAD
class _UserInscriptionGroupCard extends StatelessWidget {
  final List<InscriptionModel> inscriptions;
  final AdminProvider adminProvider;
  final Function(InscriptionModel) onAccept;
  final Function(InscriptionModel) onReject;
  final Function(InscriptionModel) onDelete;

  const _UserInscriptionGroupCard({
    required this.inscriptions,
    required this.adminProvider,
    required this.onAccept,
    required this.onReject,
    required this.onDelete,
=======
class _FilterChip extends StatelessWidget {
  final String label;
  final String value;
  final String current;
  final ValueChanged<String> onTap;

  const _FilterChip({
    required this.label,
    required this.value,
    required this.current,
    required this.onTap,
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
  });

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final first = inscriptions.first;
    final String initiales =
        (first.userPrenom?.isNotEmpty == true
            ? first.userPrenom![0].toUpperCase()
            : '') +
        (first.userNom?.isNotEmpty == true
            ? first.userNom![0].toUpperCase()
            : '');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          leading: Container(
            width: 14.w,
            height: 14.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF4A90E2), const Color(0xFF50E3C2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initiales.isNotEmpty ? initiales : '?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            first.userFullName,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(0.5.h),
              if (first.userEmail != null && first.userEmail!.isNotEmpty)
                Text(
                  first.userEmail!,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textMute),
                ),
              Gap(1.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppColors.pink.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${inscriptions.length} formation(s)',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pink,
                  ),
                ),
              ),
            ],
          ),
          children: inscriptions.map((inscription) {
            final isProcessing = adminProvider.isProcessingId(inscription.id);
            return _AdminInscriptionCard(
              inscription: inscription,
              isProcessing: isProcessing,
              onAccept: () => onAccept(inscription),
              onReject: () => onReject(inscription),
              onDelete: () => onDelete(inscription),
            );
          }).toList(),
=======
    final isSelected = value == current;
    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.9.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.pink
              : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 11.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
        ),
      ),
    );
  }
}

class _AdminInscriptionCard extends StatelessWidget {
  final InscriptionModel inscription;
  final bool isProcessing;
  final VoidCallback onAccept;
  final VoidCallback onReject;
<<<<<<< HEAD
  final VoidCallback onDelete;
=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1

  const _AdminInscriptionCard({
    required this.inscription,
    required this.isProcessing,
    required this.onAccept,
    required this.onReject,
<<<<<<< HEAD
    required this.onDelete,
=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
  });

  @override
  Widget build(BuildContext context) {
    return Container(
<<<<<<< HEAD
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColors.pink.withValues(alpha: 0.2),
        ),
=======
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEEEEF5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
<<<<<<< HEAD
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 14.w,
                height: 14.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(inscription.formationImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Gap(3.w),
=======
          // ── Header: Formation Title + Category + Status Badge ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (inscription.formationImageUrl.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    inscription.formationImageUrl,
                    width: 14.w,
                    height: 14.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 14.w,
                        height: 14.w,
                        decoration: BoxDecoration(
                          color: AppColors.navy2,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      );
                    },
                  ),
                ),
                Gap(3.w),
              ],
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
<<<<<<< HEAD
                    Text(
                      inscription.formationTitle,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(0.5.h),
                    Row(
                      children: [
                        Icon(Icons.category_rounded, size: 12.sp, color: AppColors.pink),
                        Gap(1.w),
                        Expanded(
                          child: Text(
                            inscription.formationCategoryName,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.pink,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
=======
                    if (inscription.formationCategoryName.isNotEmpty) ...[
                      Text(
                        inscription.formationCategoryName.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.pink,
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Gap(0.3.h),
                    ],
                    Text(
                      inscription.formationTitle,
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                      ),
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
                    ),
                  ],
                ),
              ),
<<<<<<< HEAD
            ],
          ),
          Gap(1.5.h),
          Row(
            children: [
              Icon(Icons.access_time_rounded, size: 12.sp, color: AppColors.textMute),
              Gap(1.w),
              Text(
                inscription.createdAt != null
                    ? _formatDate(inscription.createdAt!)
                    : 'Date inconnue',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textMute,
=======
              InscriptionStatusBadge(
                status: inscription.status,
                customLabel: inscription.status == InscriptionStatus.confirmed
                    ? 'Accepted'
                    : null,
              ),
            ],
          ),

          Gap(1.6.h),
          const Divider(height: 1, color: Color(0xFFF0F0F5)),
          Gap(1.6.h),

          // ── User Profile Information ──
          Row(
            children: [
              const Icon(Icons.person_rounded, color: AppColors.pink, size: 18),
              Gap(2.w),
              Expanded(
                child: Text(
                  inscription.userFullName,
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
                ),
              ),
            ],
          ),
<<<<<<< HEAD
          
          if (inscription.centreNote != null && inscription.centreNote!.isNotEmpty) ...[
            Gap(1.5.h),
=======
          if (inscription.userEmail != null &&
              inscription.userEmail!.isNotEmpty) ...[
            Gap(0.8.h),
            Row(
              children: [
                const Icon(
                  Icons.email_outlined,
                  color: AppColors.textMute,
                  size: 16,
                ),
                Gap(2.w),
                Expanded(
                  child: Text(
                    inscription.userEmail!,
                    style: TextStyle(
                      color: AppColors.textMute,
                      fontSize: 10.5.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (inscription.userTelephone != null &&
              inscription.userTelephone!.isNotEmpty) ...[
            Gap(0.8.h),
            Row(
              children: [
                const Icon(
                  Icons.phone_outlined,
                  color: AppColors.textMute,
                  size: 16,
                ),
                Gap(2.w),
                Expanded(
                  child: Text(
                    inscription.userTelephone!,
                    style: TextStyle(
                      color: AppColors.textMute,
                      fontSize: 10.5.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],

          // ── Inscription Date ──
          if (inscription.createdAt != null) ...[
            Gap(0.8.h),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.textMute,
                  size: 16,
                ),
                Gap(2.w),
                Text(
                  _formatDate(inscription.createdAt!),
                  style: TextStyle(
                    color: AppColors.textMute,
                    fontSize: 10.5.sp,
                  ),
                ),
              ],
            ),
          ],

          // ── Centre Note (if rejected with note) ──
          if (inscription.centreNote != null &&
              inscription.centreNote!.isNotEmpty) ...[
            Gap(1.2.h),
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
            Container(
              padding: EdgeInsets.all(2.5.w),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.error,
                    size: 16,
                  ),
                  Gap(2.w),
                  Expanded(
                    child: Text(
<<<<<<< HEAD
                      'Note: \${inscription.centreNote!}',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 12.sp,
=======
                      'Note: ${inscription.centreNote!}',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 10.sp,
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          Gap(1.8.h),

<<<<<<< HEAD
          // ── Action Buttons ──
          Row(
            children: [
              // Delete Button
              IconButton(
                onPressed: isProcessing ? null : onDelete,
                icon: const Icon(Icons.delete_outline_rounded),
                color: AppColors.error,
                tooltip: 'Supprimer l\'inscription',
              ),
              Gap(1.w),
=======
          // ── Accept / Reject Action Buttons ──
          Row(
            children: [
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
              // Reject Button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isProcessing ? null : onReject,
                  icon: isProcessing
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.error,
                          ),
                        )
                      : const Icon(Icons.close_rounded, size: 18),
                  label: const Text('Refuser'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 1.2.h),
                  ),
                ),
              ),
              Gap(3.w),
              // Accept Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isProcessing ? null : onAccept,
                  icon: isProcessing
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_rounded, size: 18),
                  label: const Text('Accepter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 1.2.h),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }
}
<<<<<<< HEAD

=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
