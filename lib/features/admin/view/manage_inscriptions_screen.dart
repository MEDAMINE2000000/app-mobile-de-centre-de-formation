import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';
import 'package:three_alfa_mobile_app/features/admin/provider/admin_provider.dart';
import 'package:three_alfa_mobile_app/features/inscription/model/inscription_model.dart';

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
            fontSize: 20.sp,
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
                      fontSize: 13.sp,
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
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

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
        );
      },
    );
  }
}

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
  });

  @override
  Widget build(BuildContext context) {
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
  final VoidCallback onDelete;

  const _AdminInscriptionCard({
    required this.inscription,
    required this.isProcessing,
    required this.onAccept,
    required this.onReject,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    ),
                  ],
                ),
              ),
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
                ),
              ),
            ],
          ),
          
          if (inscription.centreNote != null && inscription.centreNote!.isNotEmpty) ...[
            Gap(1.5.h),
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
                      'Note: \${inscription.centreNote!}',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          Gap(1.8.h),

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

