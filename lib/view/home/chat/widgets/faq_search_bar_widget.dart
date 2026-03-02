import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';

class FaqSearchBarWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Function(String)? onChanged;
  final List<String> suggestions;
  final Function(String)? onSuggestionTap;

  const FaqSearchBarWidget({
    super.key,
    this.hintText,
    this.onChanged,
    this.suggestions = const [],
    this.onSuggestionTap,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          style: TextStyle(
            color: AppColors.black,
            fontSize: 16.sp,
          ),
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText ?? "Search topics",
            border: InputBorder.none,
            filled: true,
            fillColor: AppColors.white,
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.grey,
              size: 20.w,
            ),
            suffixIcon: Icon(
              Icons.mic,
              color: AppColors.grey,
              size: 20.w,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey, width: 2.w),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey, width: 2.w),
            ),
          ),
        ),
        if (suggestions.isNotEmpty) ...[
          SizedBox(height: 8.h),
          Container(
            constraints: BoxConstraints(maxHeight: 200.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(90),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    suggestions[index],
                    style:
                        AppTypoGraphy.regular.copyWith(color: AppColors.black),
                  ),
                  onTap: () => onSuggestionTap?.call(suggestions[index]),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
