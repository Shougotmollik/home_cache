import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_cache/constants/colors.dart';

class SelectableTile extends StatelessWidget {
  final String title;
  final String imageAsset;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableTile({
    super.key,
    required this.title,
    required this.imageAsset,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double tileSize = (MediaQuery.of(context).size.width - 80.w) / 2;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: tileSize,
        height: tileSize,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cardColor : AppColors.lightgrey,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.lightgrey,
            width: 2.w,
          ),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(122),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Image.asset(
              imageAsset,
              width: 72.w,
              height: 72.w,
              fit: BoxFit.contain,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
