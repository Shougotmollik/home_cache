import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_cache/constants/colors.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25.h,
      width: 30.w,
      child: const SpinKitWave(
        size: 50.0,
        color: AppColors.primary,
        itemCount: 5,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
