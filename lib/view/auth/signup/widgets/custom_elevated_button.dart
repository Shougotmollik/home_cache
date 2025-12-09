import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_cache/constants/colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData? icon;
  final String btnText;
  final double? width;
  final double? height;
  final bool? isLoading;

  const CustomElevatedButton({
    super.key,
    required this.onTap,
    this.icon,
    required this.btnText,
    this.width,
    this.height,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height ?? 40.h,
        width: width ?? 96.w,
        decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10.r)),
        child: Center(
          child: Wrap(
            spacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            children: [
              Icon(
                icon,
                color: AppColors.white,
                size: 18.sp,
              ),
              isLoading!
                  ? SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: SpinKitWave(
                        color: AppColors.white,
                        size: 12.sp,
                        itemCount: 5,
                        duration: Duration(milliseconds: 800),
                      ),
                    )
                  : Text(
                      btnText,
                      style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
