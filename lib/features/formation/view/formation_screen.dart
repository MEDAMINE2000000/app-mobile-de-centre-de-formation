import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';
import 'package:three_alfa_mobile_app/core/widgets/app_barr_section.dart';
import 'package:three_alfa_mobile_app/features/formation/models/formation_model.dart';
import 'package:three_alfa_mobile_app/features/formation/widgets/formation_card.dart';
import 'package:three_alfa_mobile_app/features/formation/widgets/formation_category_filters.dart';
import 'package:three_alfa_mobile_app/features/formation/widgets/title_big_container.dart';

class FormationScreen extends StatefulWidget {
  const FormationScreen({super.key});

  @override
  State<FormationScreen> createState() => _FormationScreenState();
}

class _FormationScreenState extends State<FormationScreen> {
  String _selectedCategoryId = 'toutes';

  List<Formation> get _filteredFormations {
    if (_selectedCategoryId == 'toutes') {
      return FormationMockData.formations;
    }
    return FormationMockData.formations
        .where((f) => f.categoryId == _selectedCategoryId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredFormations;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar:
          AppBarrSection(), // make sure AppBarrSection sets elevation: 0, scrolledUnderElevation: 0
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header title and subtext — no top border, only rounded bottom + shadow
            TitleBigContainer(),
            Gap(2.5.h),
            FormationCategoryFilters(
              categories: FormationMockData.categories,
              selectedCategoryId: _selectedCategoryId,
              onSelectCategory: (categoryId) {
                setState(() {
                  _selectedCategoryId = categoryId;
                });
              },
            ),
            Gap(2.h),

            // Available Formations Count Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Text(
                '${filteredList.length} formation(s) disponible(s)',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF333252),
                ),
              ),
            ),
            Gap(1.5.h),

            // Formations Cards List or Empty State
            if (filteredList.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 6.h),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 40.sp,
                      color: AppColors.textMute,
                    ),
                    Gap(1.h),
                    Text(
                      'Aucune formation disponible pour cette catégorie.',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textMute,
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  return FormationCard(formation: filteredList[index]);
                },
              ),
            Gap(3.h),
          ],
        ),
      ),
    );
  }
}
