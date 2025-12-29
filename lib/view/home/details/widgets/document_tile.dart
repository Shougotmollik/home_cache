import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';

class DocumentTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final String iconPath;
  final VoidCallback onTap;

  const DocumentTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120.h,
        width: 120.w,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.lightgrey,
          border: Border.all(color: AppColors.lightgrey, width: 1.w),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.3),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              iconPath,
              height: 72.h,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 6.h),
            Text(
              title,
              style: AppTypoGraphy.medium.copyWith(
                color: AppColors.black,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: TextStyle(
                  color: AppColors.black.withValues(alpha: 0.7),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Text(
                date,
                style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.black.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
