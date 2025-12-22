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

      return Container(
        height: 14.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Stack(
          children: [
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
            LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;
                final filledWidth = totalWidth * progress;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(total, (index) {
                    final dotPosition = (index / (total - 1)) * totalWidth;

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
