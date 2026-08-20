import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:three_alfa_mobile_app/features/formation/models/formation_model.dart';
import 'package:three_alfa_mobile_app/features/formation/widgets/formation_category_item.dart';

class FormationCategoryFilters extends StatelessWidget {
  final List<FormationCategory> categories;
  final String selectedCategoryId;
  final ValueChanged<String> onSelectCategory;

  const FormationCategoryFilters({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6.5.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategoryId == category.id;

          return FormationCategoryItem(
            category: category,
            isSelected: isSelected,
            onTap: () => onSelectCategory(category.id),
          );
        },
      ),
    );
  }
}
