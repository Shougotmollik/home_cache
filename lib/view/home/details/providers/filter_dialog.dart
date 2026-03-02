import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/controller/provider_controller.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  final ProviderController providerController = Get.find<ProviderController>();
  String? selectedUsageFilter;

  Map<int, bool> selectedRatings = {};
  Map<String, bool> selectedServices = {};

  final List<String> usageOptions = [
    'Past 30 Days',
    'Past 90 Days',
    'Past Year',
    '2+ Years',
  ];

  final List<int> ratingOptions = [5, 4, 3, 2, 1];

  final List<String> serviceTypes = [
    'Plumber',
    'HVAC',
    'General Contractor',
    'Painter',
    'Landscaper',
    'Electrician',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 8.w),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          // height: 500.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withAlpha(122),
              width: 3.w,
            ),
          ),
          padding: EdgeInsets.all(16.sp),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Sort & Filter Your Providers',
                  style: AppTypoGraphy.bold.copyWith(
                      color: AppColors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 12.h),
                _sectionTitle('Last Used'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: usageOptions.sublist(0, 3).map((title) {
                    return Expanded(child: _buildCheckbox(title));
                  }).toList(),
                ),
                Row(
                  children: [Expanded(child: _buildCheckbox(usageOptions[3]))],
                ),
                SizedBox(height: 16.h),
                _sectionTitle('Rating'),
                Wrap(
                  spacing: 12.w,
                  runSpacing: 8.h,
                  children: ratingOptions
                      .map((rating) => _buildStarRatingCheckbox(rating))
                      .toList(),
                ),
                SizedBox(height: 16.h),
                // _sectionTitle('Favorite'),
                // Row(
                //   children: [
                //     _buildFavoriteCheckbox(true),
                //     SizedBox(
                //       width: 24.w,
                //     ),
                //     _buildFavoriteCheckbox(false),
                //   ],
                // ),
                // SizedBox(height: 16.h),
                _sectionTitle('Service Type'),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: serviceTypes
                      .map((type) => _buildServiceCheckbox(type))
                      .toList(),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 18.w,
                  children: [
                    OutlinedButton(
                        style: ButtonStyle(
                            side: MaterialStateProperty.all(
                          BorderSide(
                            color: AppColors.border,
                            width: 2.w,
                          ),
                        )),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel')),
                    ElevatedButton(
                      onPressed: () {
                        // 1. Prepare Rating List
                        List<int> selectedRatingList = selectedRatings.entries
                            .where((e) => e.value == true)
                            .map((e) => e.key)
                            .toList();

                        // 2. Prepare Service List
                        List<String> selectedServiceList = selectedServices
                            .entries
                            .where((e) => e.value == true)
                            .map((e) => e.key)
                            .toList();

                        // 3. Call the ADVANCED filter method with ALL parameters
                        providerController.applyAdvancedFilters(
                          ratings: selectedRatingList,
                          services: selectedServiceList,
                          usageTimeframe:
                              selectedUsageFilter, // Pass the 'Past 30 Days' etc.
                        );

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white),
                      child: Text('Apply'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(String title) {
    final bool isSelected = selectedUsageFilter == title;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            activeColor: AppColors.primaryLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            onChanged: (_) {
              setState(() {
                selectedUsageFilter = isSelected ? null : title;
              });
            },
          ),
          Flexible(
            child: Text(
              title,
              style: AppTypoGraphy.regular.copyWith(
                fontSize: 12.sp,
                color: AppColors.black.withAlpha(204),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool? favoriteFilter;

  Widget _buildStarRatingCheckbox(int rating) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRatings[rating] = !(selectedRatings[rating] ?? false);
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: selectedRatings[rating] ?? false,
            activeColor: AppColors.primaryLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            onChanged: (val) {
              setState(() {
                selectedRatings[rating] = val ?? false;
              });
            },
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              return Icon(
                index < rating ? Icons.star_rounded : Icons.star_border_rounded,
                color: AppColors.primaryLight,
                size: 16.sp,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCheckbox(String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedServices[title] = !(selectedServices[title] ?? false);
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: selectedServices[title] ?? false,
            activeColor: AppColors.primaryLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            onChanged: (val) {
              setState(() {
                selectedServices[title] = val ?? false;
              });
            },
          ),
          Text(
            title,
            style: AppTypoGraphy.regular.copyWith(
              fontSize: 12.sp,
              color: AppColors.black.withAlpha(204),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypoGraphy.bold.copyWith(
            color: AppColors.black,
            fontSize: 16.sp,
          ),
        ),
        Divider(color: AppColors.black, thickness: 1.h, height: 12.h),
      ],
    );
  }
}
