import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_cache/constants/colors.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      width: 30.w,
      child: const SpinKitPouringHourGlassRefined(
        size: 50.0,
        color: AppColors.primary,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
