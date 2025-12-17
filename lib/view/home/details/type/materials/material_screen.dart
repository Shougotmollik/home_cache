import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/config/route/route_names.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/controller/material_controller.dart';
import 'package:home_cache/view/home/details/type/materials/dialog_material.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';
import 'package:home_cache/view/widget/custom_progress_indicator.dart';
import 'package:home_cache/model/material_model.dart';

class MaterialScreen extends StatefulWidget {
  const MaterialScreen({super.key});

  @override
  State<MaterialScreen> createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  final MaterialController controller = Get.put(MaterialController());

  int selectedCategoryIndex = 0;
  late String materialTypeId;

  @override
  void initState() {
    super.initState();

    materialTypeId = Get.arguments['id'] ?? '';
    debugPrint('Received Material Type ID: $materialTypeId');

    Future.microtask(() async {
      await controller.getMaterialCategories();
      await controller.getMaterialTypes(materialTypeId);

      if (controller.materialCategoryList.isNotEmpty) {
        final firstCategoryId = controller.materialCategoryList.first.id;
        await controller.getMaterialByCategory(firstCategoryId);
      }
    });
  }

  void selectCategory(int index) {
    setState(() => selectedCategoryIndex = index);

    final categoryId = controller.materialCategoryList[index].id;
    controller.getMaterialByCategory(categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(
        title: 'Materials',
        titleColor: AppColors.secondary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) =>
                      DialogMaterial(materialTypeId: materialTypeId),
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

        if (controller.materialCategoryList.isEmpty) {
          return Center(
            child: Text(
              'No material categories found',
              style: AppTypoGraphy.medium.copyWith(color: AppColors.black),
            ),
          );
        }

        if (selectedCategoryIndex >= controller.materialCategoryList.length) {
          selectedCategoryIndex = 0;
        }

        return Padding(
          padding: EdgeInsets.all(24.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// CATEGORY BUTTONS
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10.w,
                runSpacing: 8.h,
                children: List.generate(
                  controller.materialCategoryList.length,
                  (index) {
                    final isSelected = selectedCategoryIndex == index;
                    final categoryName =
                        controller.materialCategoryList[index].material;

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
                        "$categoryName(${controller.materialCategoryList[index].amount})",
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

              /// MATERIAL LIST
              Expanded(
                child: controller.materialsByCategoryList.isEmpty
                    ? Center(
                        child: Text(
                          'No materials in this category.',
                          style: AppTypoGraphy.medium
                              .copyWith(color: AppColors.black),
                        ),
                      )
                    : ListView.separated(
                        itemCount: controller.materialsByCategoryList.length,
                        separatorBuilder: (_, __) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final MaterialModel material =
                              controller.materialsByCategoryList[index];

                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(RouteNames.editMaterial,
                                  arguments: {'id': material.id});
                            },
                            child: Container(
                              padding: EdgeInsets.all(12.sp),
                              decoration: BoxDecoration(
                                color: AppColors.lightgrey,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          material.userMaterial.material.name,
                                          style: AppTypoGraphy.medium
                                              .copyWith(fontSize: 18.sp),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          material.room.name,
                                          style: AppTypoGraphy.regular
                                              .copyWith(fontSize: 14.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      Get.toNamed(RouteNames.editMaterial,
                                          arguments: {'id': material.id});
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
