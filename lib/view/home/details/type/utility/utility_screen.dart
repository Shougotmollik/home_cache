import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/config/route/route_names.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart' show AppColors;
import 'package:home_cache/controller/utilities_controller.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';

class UtilityScreen extends StatefulWidget {
  const UtilityScreen({super.key});

  @override
  State<UtilityScreen> createState() => _UtilityScreenState();
}

class _UtilityScreenState extends State<UtilityScreen> {
  int selectedCategoryIndex = 0;

  final UtilitiesController utilitiesController =
      Get.put(UtilitiesController());

  @override
  void initState() {
    super.initState();

    utilitiesController.getUtilitiesTypes().then((_) {
      if (utilitiesController.utilityTypeList.isNotEmpty) {
        final firstId = utilitiesController.utilityTypeList.first.id;

        utilitiesController.getUtilityTypeDetails(firstId);
      }
    });
  }

  void selectCategory(int index) {
    final selectedId = utilitiesController.utilityTypeList[index].id;

    setState(() {
      selectedCategoryIndex = index;
    });

    utilitiesController.getUtilityTypeDetails(selectedId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(
        title: 'Utilities',
        titleColor: AppColors.secondary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {
                Get.toNamed(RouteNames.addUtilitiesScreen);
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                '+ Add',
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.surface,
      body: Padding(
        padding: EdgeInsets.all(24.sp),
        child: Obx(() {
          final categories = utilitiesController.utilityTypeList;
          final details = utilitiesController.utilityTypeDetailList;

          if (categories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Categories
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: List.generate(categories.length, (index) {
                  final isSelected = selectedCategoryIndex == index;
                  return ElevatedButton(
                    onPressed: () => selectCategory(index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? AppColors.primary.withValues(alpha: 0.7)
                          : AppColors.lightgrey,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      categories[index].utilityType.name,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: 12.sp,
                      ),
                    ),
                  );
                }),
              ),

              SizedBox(height: 24.h),

              Text(
                'Viewing All',
                style: AppTypoGraphy.medium.copyWith(color: AppColors.black),
              ),

              SizedBox(height: 16.h),

              /// Details list (already filtered by API)
              Expanded(
                child: details.isEmpty
                    ? Center(
                        child: Text(
                          'No utilities in this category.',
                          style: AppTypoGraphy.medium,
                        ),
                      )
                    : ListView.separated(
                        itemCount: details.length,
                        separatorBuilder: (_, __) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final item = details[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.lightgrey,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: ListTile(
                              title: Text(
                                item.utilityItem.name,
                                style: AppTypoGraphy.medium
                                    .copyWith(fontSize: 18.sp),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
