import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:home_cache/constants/colors.dart';

class NotificationTile extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onMarkDone;
  final VoidCallback onDismiss;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.title,
    required this.description,
    required this.onMarkDone,
    required this.onDismiss,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/tile.svg",
                  fit: BoxFit.contain,
                  height: 24.h,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, size: 32.w, color: Colors.grey),
              ],
            ),
            SizedBox(height: 12.h),
            SizedBox(
              // height: 110.h,
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  description,
                  style: TextStyle(fontSize: 14.sp, color: AppColors.black),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Divider(height: 1, thickness: 1, color: Colors.grey[500]),
            SizedBox(height: 16.h),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onMarkDone,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check, color: Colors.white, size: 20.sp),
                        SizedBox(width: 4.w),
                        Text(
                          "Mark as done",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 24.w),
                GestureDetector(
                  onTap: onDismiss,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withAlpha(200),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.close, color: Colors.white, size: 20.sp),
                        SizedBox(width: 4.w),
                        Text(
                          "Dismiss",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
