import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/colors.dart';

class TaskProgressBar extends StatelessWidget {
  final RxInt totalTasks;
  final RxInt completedTasks;

  TaskProgressBar({
    super.key,
    required int totalTasks,
    required int completedTasks,
  })  : totalTasks = totalTasks.obs,
        completedTasks = completedTasks.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final total = totalTasks.value;
      final completed = completedTasks.value;

      final progress = total > 0 ? (completed / total).clamp(0.0, 1.0) : 0.0;

      final percentage = (progress * 100).round();

      final numberOfDots = ((percentage / 10).ceil()).clamp(1, 10);

      return Container(
        height: 14.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Stack(
          children: [
            // Animated progress fill
            AnimatedFractionallySizedBox(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                height: 14.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
            ),
            // Dots overlay
            LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;
                final filledWidth = totalWidth * progress;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(numberOfDots, (index) {
                    // Calculate dot position (evenly spaced)
                    final dotPosition = numberOfDots > 1
                        ? (index / (numberOfDots - 1)) * totalWidth
                        : totalWidth / 2; // Center the dot if only one

                    // Check if this dot should be filled (covered by progress)
                    final isInsideFilled = dotPosition + 4.w <= filledWidth;

                    return Padding(
                      padding: EdgeInsets.all(4.sp),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color:
                              isInsideFilled ? AppColors.white : Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
