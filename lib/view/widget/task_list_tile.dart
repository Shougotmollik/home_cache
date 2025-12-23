import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:home_cache/config/route/route_names.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/model/task.dart';
import 'package:intl/intl.dart';

class TaskListTile extends StatelessWidget {
  // final String title;
  // final String date;
  // final VoidCallback? onTap;

  final Task task;

  const TaskListTile({
    super.key,
    // required this.title,
    // required this.date,
    // this.onTap,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteNames.taskDetails, arguments: {
          'task_id': task.id,
          'task_title': task.title,
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(128),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ), // Display rating
                    SizedBox(height: 4.h),
                    Text(
                      DateFormat('yyyy-MM-dd').format(task.initialDate),
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),
            Container(width: 6.w, color: Colors.grey),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.black,
                    size: 20.sp,
                    weight: 24.sp,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Info',
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
