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

    final pending = provider.pendingInscriptions;
    final confirmed = provider.confirmedInscriptions;
    final rejected = provider.myInscriptions
        .where((i) => i.status == InscriptionStatus.rejected)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TitleBigContainer(),
        Gap(1.6.h),
        if (pending.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Text(
              'En attente de confirmation',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Gap(1.h),
          ...pending.map(
            (i) => InscriptionCard(
              inscription: i,
              onCancel: () => _confirmCancel(i.id),
            ),
          ),
          Gap(1.h),
        ],
        if (confirmed.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Text(
              'Formations confirmées',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Gap(1.h),
          ...confirmed.map((i) => InscriptionCard(inscription: i)),
          Gap(1.h),
        ],
        if (rejected.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Text(
              'Demandes refusées',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Gap(1.h),
          ...rejected.map((i) => InscriptionCard(inscription: i)),
        ],
        Gap(2.h),
      ],
    );
  }
}
