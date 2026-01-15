import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/config/route/route_names.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/controller/paint_controller.dart';
import 'package:home_cache/model/paint_item.dart';
import 'package:home_cache/view/home/details/type/paint/paint_dialog.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';
import 'package:home_cache/view/widget/custom_progress_indicator.dart';

class PaintScreen extends StatefulWidget {
  const PaintScreen({super.key});

  @override
  State<PaintScreen> createState() => _PaintScreenState();
}

class _PaintScreenState extends State<PaintScreen> {
  final PaintController controller = Get.put(PaintController());
  int selectedCategoryIndex = 0;

  @override
  void initState() {
    // controller.fetchRoomWithPaint();
    super.initState();
  }

  void selectCategory(int index) {
    setState(() => selectedCategoryIndex = index);
    final categoryId = controller.roomWithPaint.value?.userRooms[index].id;

    controller.fetchingPaintItem(
        categoryId!, controller.roomWithPaint.value!.itemId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(
        title: 'Paint',
        titleColor: AppColors.secondary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => PaintDialog(
                    selectedItemId: controller.roomWithPaint.value!.itemId,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () {

            final roomData=controller.roomWithPaint.value;
            if (controller.isLoading.value) {
              return const Center(
                child: CustomProgressIndicator(),
              );
            }

            if(roomData==null){
              return const Center(
                child: Text('No paint data available.'),
              );
            }

            if (roomData.userRooms.isEmpty) {
              return const Center(
                child: Text('No paint data available.'),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10.w,
                    runSpacing: 8.h,
                    children: List.generate(
                      controller.roomWithPaint.value!.userRooms.length,
                      (index) {
                        final isSelected = selectedCategoryIndex == index;
                        final categoryName = controller
                            .roomWithPaint.value?.userRooms[index].roomType;
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
                            categoryName ?? 'paint',
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
                    style:
                        AppTypoGraphy.medium.copyWith(color: AppColors.black),
                  ),
                  SizedBox(height: 20.h),

                  /// paint item LIST
                  Expanded(
                    child: controller.paintItemList.isEmpty
                        ? Center(
                            child: Text(
                              'No materials in this category.',
                              style: AppTypoGraphy.medium
                                  .copyWith(color: AppColors.black),
                            ),
                          )
                        : ListView.separated(
                            itemCount: controller.paintItemList.length,
                            separatorBuilder: (_, __) => SizedBox(height: 12.h),
                            itemBuilder: (context, index) {
                              final PaintItem paintItem =
                                  controller.paintItemList[index];

                              return GestureDetector(
                                onTap: () {
                                  Get.toNamed(RouteNames.updatePaintItemScreen,
                                      arguments: {'paintItem': paintItem});
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
                                              paintItem.details.brand,
                                              style: AppTypoGraphy.medium
                                                  .copyWith(fontSize: 18.sp),
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              paintItem.details.location,
                                              style: AppTypoGraphy.regular
                                                  .copyWith(fontSize: 14.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          // Get.toNamed(RouteNames.editMaterial,
                                          //     arguments: {
                                          //       'id': material.id,
                                          //       'type_name': material
                                          //           .userMaterial.material.name,
                                          //       'room_name': material.room.name
                                          //     });
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
          },
        ),
      ),
    );
  }
}
