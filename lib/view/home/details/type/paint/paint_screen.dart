import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/controller/paint_controller.dart';
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
    controller.fetchRoomWithPaint();
    super.initState();
  }

  void selectCategory(int index) {
    setState(() => selectedCategoryIndex = index);
    // Additional logic can be added here to handle category selection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(
        title: 'Paints',
        titleColor: AppColors.secondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () {
            if (controller.isLoading.value) {
              return const Center(
                child: CustomProgressIndicator(),
              );
            }
            if (controller.roomWithPaintList.isEmpty) {
              return const Center(
                child: Text('No paint data available.'),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10.w,
                    runSpacing: 8.h,
                    children: List.generate(
                      controller.roomWithPaintList.length,
                      (index) {
                        final isSelected = selectedCategoryIndex == index;
                        final categoryName =
                            controller.roomWithPaintList[index].roomType;

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
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
