import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/config/route/route_names.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';

class AppBarBack extends StatelessWidget implements PreferredSizeWidget {
  const AppBarBack({super.key, this.title, this.titleColor, this.actions});
  final String? title;
  final Color? titleColor;
  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Get.offAllNamed(RouteNames.bottomNav);
          }
        },
        child: Container(
          margin: EdgeInsets.only(left: 10.w),
          decoration: BoxDecoration(
            color: AppColors.lightgrey.withAlpha(150),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.arrow_back_ios,
                size: 18.sp,
                color: AppColors.secondary,
              ),
            ),
          ),
        ),
      ),
      title: Text(title ?? '',
          style: AppTypoGraphy.bold
              .copyWith(color: titleColor ?? AppColors.black)),
      elevation: 0,
      backgroundColor: AppColors.surface,
      actions: actions ?? [],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
