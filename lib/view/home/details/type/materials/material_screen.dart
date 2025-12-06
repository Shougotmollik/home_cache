import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart' show AppColors;
import 'package:home_cache/view/home/details/type/appliances/dialog_appliance.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';

class MaterialScreen extends StatefulWidget {
  const MaterialScreen({super.key});

  @override
  State<MaterialScreen> createState() => _StructureScreenState();
}

class _StructureScreenState extends State<MaterialScreen> {
  final List<String> categories = [
    "Foundation",
    "Framing",
    "Roofing",
    "Siding",
    "Windows",
    "Doors",
    "Garage Door",
    "Insulation",
    "Drywall",
    "Flooring",
    "Trim",
    "Decking",
    "Fencing",
    "Driveway",
    "Patio",
    "Water Softener",
    "Plumbing",
  ];

  int selectedCategoryIndex = 0;

  void selectCategory(int index) {
    setState(() {
      selectedCategoryIndex = index;
    });
  }

  final List<Map<String, dynamic>> structureItems = [
    {
      'title': 'Foundation Inspection',
      'subtitle': 'Slab-on-grade, Concrete',
      'date': '15 Mar 25',
      'category': 'Foundation',
    },
    {
      'title': 'Roof Inspection',
      'subtitle': 'Gable, Asphalt',
      'date': '10 Sep 24',
      'category': 'Roofing',
    },
    {
      'title': 'Window Caulking',
      'subtitle': 'Double-Hung, Vinyl',
      'date': '12 Apr 25',
      'category': 'Windows',
    },
    {
      'title': 'Deck Power Wash',
      'subtitle': 'Raised, Composite',
      'date': '01 May 25',
      'category': 'Decking',
    },
  ];

  @override
  Widget build(BuildContext context) {
    String normalize(String s) => s.toLowerCase().replaceAll(' ', '');
    final normalizedSelectedCategory =
        normalize(categories[selectedCategoryIndex]);
    final filteredItems = structureItems.where((item) {
      final normalizedCategory = normalize(item['category'].toString());
      return normalizedCategory == normalizedSelectedCategory;
    }).toList();

    return Scaffold(
      appBar:  AppBarBack(
        title: 'Materials',
        titleColor: AppColors.secondary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {
                // showDialog(
                //   context: context,
                //   builder: (context) => const DialogAppliance(),
                // );
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     SizedBox(width: 40.w),
            //     Text(
            //       'Material',
            //       style: AppTypoGraphy.bold.copyWith(color: AppColors.secondary),
            //       textAlign: TextAlign.center,
            //     ),
            //     TextButton(
            //       onPressed: () {
            //         // Get.toNamed(AppRoutes.addDocuments);
            //       },
            //       style: TextButton.styleFrom(
            //         backgroundColor: AppColors.primary,
            //         padding:
            //             EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(12.r),
            //         ),
            //       ),
            //       child: Text(
            //         '+ Add',
            //         style: TextStyle(color: Colors.white, fontSize: 14.sp),
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 20.h),
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
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
            SizedBox(height: 20.h),
            Text(
              'View All',
              style: AppTypoGraphy.medium.copyWith(color: AppColors.black),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: filteredItems.isEmpty
                  ? Center(
                      child: Text(
                        'No items in this category.',
                        style:
                            AppTypoGraphy.medium.copyWith(color: AppColors.black),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredItems.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.lightgrey,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                                color: AppColors.lightgrey, width: 1),
                          ),
                          child: ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 24.w),
                            title: Text(
                              item['title'],
                              style:
                                  AppTypoGraphy.medium.copyWith(fontSize: 20.sp),
                            ),
                            subtitle: Text(
                              item['subtitle'],
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.edit, color: AppColors.black),
                              onPressed: () {
                                // TODO: Show structure dialog form
                              },
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
