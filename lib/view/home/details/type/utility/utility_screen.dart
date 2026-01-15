import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/config/route/route_names.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart' show AppColors;
import 'package:home_cache/view/widget/appbar_back_widget.dart';

class UtilityScreen extends StatefulWidget {
  const UtilityScreen({super.key});

  @override
  State<UtilityScreen> createState() => _UtilityScreenState();
}

class _UtilityScreenState extends State<UtilityScreen> {
  final List<String> categories = [
    'Power Type',
    'Water Supply',
    'Heating',
    'Cooling',
    'Heat Power Source',
    'Other',
  ];

  int selectedCategoryIndex = 0;

  void selectCategory(int index) {
    setState(() {
      selectedCategoryIndex = index;
    });
  }

  final List<Map<String, String>> utilityComponents = [
    {
      'category': 'Power Type',
      'component': 'Electric',
      'service': 'Yes',
      'cadence': 'Annually',
      'season': 'Summer',
      'leadTime': '1 month',
      'initialAlert':
          'Time to inspect your electrical system and test breakers.',
      'reminderAlert': 'Reminder: Electrical panel service due this month.',
    },
    {
      'category': 'Water Supply',
      'component': 'Well',
      'service': 'Yes',
      'cadence': 'Annually',
      'season': 'Spring',
      'leadTime': '1 month',
      'initialAlert': 'Time to test well water and inspect pump system.',
      'reminderAlert': 'Reminder: Time to test well water quality.',
    },
    {
      'category': 'Heating',
      'component': 'Furnace',
      'service': 'Yes',
      'cadence': 'Annually',
      'season': 'Fall',
      'leadTime': '1 month',
      'initialAlert': 'Furnace check due… clean filters and test operation.',
      'reminderAlert': 'Reminder: Furnace maintenance due… stay warm safely.',
    },
    {
      'category': 'Cooling',
      'component': 'Central AC',
      'service': 'Yes',
      'cadence': 'Annually',
      'season': 'Spring',
      'leadTime': '1 month',
      'initialAlert': 'Central AC inspection due… change filters and test.',
      'reminderAlert': 'Reminder: Central AC service needed this month.',
    },
    {
      'category': 'Other',
      'component': 'Sewage Septic',
      'service': 'Yes',
      'cadence': '3 years',
      'season': 'Fall',
      'leadTime': '1 month',
      'initialAlert': 'Septic tank pumping and inspection due.',
      'reminderAlert': 'Reminder: Septic tank pumping due… schedule now.',
    },
    // Add more rows as needed
  ];

  @override
  Widget build(BuildContext context) {
    final selectedCategory = categories[selectedCategoryIndex];
    final filteredUtilities = utilityComponents
        .where((item) => item['category'] == selectedCategory)
        .toList();

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
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 6.w,
              runSpacing: 8.h,
              children: List.generate(categories.length, (index) {
                final isSelected = selectedCategoryIndex == index;
                return ElevatedButton(
                  onPressed: () => selectCategory(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isSelected ? AppColors.primary : AppColors.lightgrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                  ),
                  child: Text(
                    categories[index],
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
              'Reminders',
              style: AppTypoGraphy.medium.copyWith(color: AppColors.black),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: filteredUtilities.isEmpty
                  ? Center(
                      child: Text(
                        'No reminders in this category.',
                        style: AppTypoGraphy.medium
                            .copyWith(color: AppColors.black),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredUtilities.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final item = filteredUtilities[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.lightgrey,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: AppColors.lightgrey),
                          ),
                          child: ListTile(
                            title: Text(
                              item['component']!,
                              style: AppTypoGraphy.medium
                                  .copyWith(fontSize: 18.sp),
                            ),
                            subtitle: Text(
                              '${item['cadence']} • ${item['season']} • ${item['leadTime']}',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
