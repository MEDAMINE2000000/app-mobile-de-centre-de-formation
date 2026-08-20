import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';
import 'package:three_alfa_mobile_app/core/widgets/app_barr_section.dart';
import 'package:three_alfa_mobile_app/core/widgets/shared_button.dart';

import 'package:three_alfa_mobile_app/features/formation/widgets/title_big_container.dart';
import 'package:three_alfa_mobile_app/features/inscription/model/inscription_model.dart';
import 'package:three_alfa_mobile_app/features/inscription/provider/inscription_provider%20.dart';

import 'package:three_alfa_mobile_app/features/inscription/widgets/inscription_card.dart';
import 'package:three_alfa_mobile_app/features/inscription/widgets/decision_card.dart';

class InscriptionScreen extends StatefulWidget {
  const InscriptionScreen({super.key});

  @override
  State<InscriptionScreen> createState() => _InscriptionScreenState();
}

class _InscriptionScreenState extends State<InscriptionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InscriptionProvider>().loadMyInscriptions();
    });
  }

  Future<void> _confirmCancel(String inscriptionId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Annuler la demande'),
        content: const Text(
          'Voulez-vous vraiment annuler cette demande d\'inscription ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Non', style: TextStyle(color: AppColors.textMute)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'Oui, annuler',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final provider = context.read<InscriptionProvider>();
    final success = await provider.cancelInscription(inscriptionId);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? (provider.successMessage ?? 'Demande annulée.')
              : (provider.errorMessage ?? 'Erreur lors de l\'annulation.'),
        ),
        backgroundColor: success ? AppColors.success : AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InscriptionProvider>();

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: const AppBarrSection(),
      body: RefreshIndicator(
        color: AppColors.pink,
        onRefresh: () =>
            context.read<InscriptionProvider>().loadMyInscriptions(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: _buildBody(provider),
        ),
      ),
    );
  }

  Widget _buildBody(InscriptionProvider provider) {
    if (provider.isLoading && provider.myInscriptions.isEmpty) {
      return SizedBox(
        height: 60.h,
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.pink),
        ),
      );
    }

    if (provider.myInscriptions.isEmpty) {
      return SizedBox(
        height: 60.h,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.school_outlined,
                  color: AppColors.textMute,
                  size: 12.w,
                ),
                Gap(1.6.h),
                Text(
                  'Vous n\'avez encore aucune demande d\'inscription.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textMute, fontSize: 12.sp),
                ),
                Gap(2.h),
                SharedButton(
                  onPressed: () =>
                      context.read<InscriptionProvider>().loadMyInscriptions(),
                  label: 'actualiser',
                  icon: Icons.refresh_rounded,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final decisionsToRead = provider.decisionsToRead;
    final history = provider.historyInscriptions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleBigContainer(),
        Gap(2.h),

        // ==========================================
        // SECTION 1: Décisions à consulter
        // ==========================================
        if (decisionsToRead.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              children: [
                Icon(Icons.notifications_active_rounded,
                    color: AppColors.pink, size: 20.sp),
                Gap(2.w),
                Expanded(
                  child: Text(
                    'Décisions à consulter',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gap(0.5.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
              decoration: BoxDecoration(
                color: AppColors.pink.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '🔔 ${decisionsToRead.length} nouvelle${decisionsToRead.length > 1 ? 's' : ''} décision${decisionsToRead.length > 1 ? 's' : ''}',
                style: TextStyle(
                  color: AppColors.pink,
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Gap(1.h),
          ...decisionsToRead.map((i) => DecisionCard(
                key: ValueKey(i.id),
                inscription: i,
              )),
          Gap(2.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Divider(color: Colors.grey.withOpacity(0.2), thickness: 1.5),
          ),
          Gap(2.h),
        ],

        // ==========================================
        // SECTION 2: Historique des demandes
        // ==========================================
        if (history.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              children: [
                Icon(Icons.history_rounded,
                    color: AppColors.textMute, size: 20.sp),
                Gap(2.w),
                Text(
                  'Historique des demandes',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          Gap(1.5.h),
          ...history.map(
            (i) => InscriptionCard(
              key: ValueKey(i.id),
              inscription: i,
              onCancel: i.status == InscriptionStatus.pending
                  ? () => _confirmCancel(i.id)
                  : null,
            ),
          ),
        ],
        Gap(3.h),
      ],
    );
  }
}
