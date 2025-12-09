import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart' show AppColors;
import 'package:home_cache/controller/appliance_controller.dart';
import 'package:home_cache/view/home/details/type/appliances/dialog_appliance.dart';
import 'package:home_cache/view/widget/custom_progress_indicator.dart';
import '../../../../../config/route/route_names.dart';
import 'package:home_cache/model/appliance.dart';

class AppliancesScreen extends StatefulWidget {
  const AppliancesScreen({super.key});

  @override
  State<AppliancesScreen> createState() => _AppliancesScreenState();
}

class _AppliancesScreenState extends State<AppliancesScreen> {
  final ApplianceController controller = Get.put(ApplianceController());

  int selectedCategoryIndex = 0;
  late String applianceTypeId;

  @override
  void initState() {
    super.initState();

    // Receive the applianceTypeId argument safely
    applianceTypeId = Get.arguments['id'] ?? '';
    print('Received Appliance Type ID:=====>>> $applianceTypeId');

    // Fetch categories and types after the widget is built
    Future.microtask(() async {
      await controller.getApplianceCategories();
      await controller.getApplianceTypes(applianceTypeId);

      // Fetch appliances for the first category if available
      if (controller.applianceCategoryList.isNotEmpty) {
        final firstCategoryId = controller.applianceCategoryList[0].id;
        await controller.getAppliancesByCategory(firstCategoryId);
      }
    });
  }

  void selectCategory(int index) {
    setState(() => selectedCategoryIndex = index);

    final categoryId = controller.applianceCategoryList[index].id;
    controller.getAppliancesByCategory(categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appliances', style: AppTypoGraphy.medium),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => DialogAppliance(
                    applianceTypeId: applianceTypeId,
                  ),
                );
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CustomProgressIndicator());
        }

        if (controller.applianceCategoryList.isEmpty) {
          return Center(
            child: Text(
              'No appliance categories found',
              style: AppTypoGraphy.medium.copyWith(color: AppColors.black),
            ),
          );
        }

        // Ensure selected index is valid
        if (selectedCategoryIndex >= controller.applianceCategoryList.length) {
          selectedCategoryIndex = 0;
        }

        return Padding(
          padding: EdgeInsets.all(24.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // CATEGORY BUTTONS
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10.w,
                runSpacing: 8.h,
                children: List.generate(
                  controller.applianceCategoryList.length,
                  (index) {
                    final isSelected = selectedCategoryIndex == index;
                    final categoryName =
                        controller.applianceCategoryList[index].appliance;

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
                        categoryName,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 12.sp,
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 20.h),
              Text(
                'View All',
                style: AppTypoGraphy.medium.copyWith(color: AppColors.black),
              ),
              SizedBox(height: 20.h),

              // LIST OF APPLIANCES
              Expanded(
                child: controller.appliancesByCategoryList.isEmpty
                    ? Center(
                        child: Text(
                          'No appliances in this category.',
                          style: AppTypoGraphy.medium
                              .copyWith(color: AppColors.black),
                        ),
                      )
                    : ListView.separated(
                        itemCount: controller.appliancesByCategoryList.length,
                        separatorBuilder: (_, __) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final ApplianceModel appliance =
                              controller.appliancesByCategoryList[index];

                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(RouteNames.editAppliances,
                                  arguments: {
                                    'id': appliance.id,
                                  });
                            },
                            child: Container(
                              padding: EdgeInsets.all(12.sp),
                              decoration: BoxDecoration(
                                color: AppColors.lightgrey,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          appliance
                                              .userAppliance.appliance.name,
                                          style: AppTypoGraphy.medium
                                              .copyWith(fontSize: 20.sp),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          appliance.room.name,
                                          style: AppTypoGraphy.regular
                                              .copyWith(fontSize: 14.sp),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // EDIT BUTTON
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: AppColors.black),
                                    onPressed: () {
                                      Get.toNamed(RouteNames.editAppliances,
                                          arguments: {
                                            'id': appliance.id,
                                          });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
