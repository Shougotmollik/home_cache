import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/config/route/route_names.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/controller/auth_controller.dart';
import 'package:home_cache/view/auth/signup/widgets/custom_elevated_button.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';
import 'package:home_cache/view/widget/rounded_search_bar.dart';
import 'package:home_cache/view/widget/selectable_tiles.dart';
import 'package:home_cache/view/widget/text_button_widget_light.dart';

class SelectResponsibleTypeScreen extends StatefulWidget {
  const SelectResponsibleTypeScreen({super.key});

  @override
  State<SelectResponsibleTypeScreen> createState() =>
      _SelectResponsibleTypeScreenState();
}

class _SelectResponsibleTypeScreenState
    extends State<SelectResponsibleTypeScreen> {
  void onSelected(int index) {
    setState(() {
      if (index == options.length) {
        isOtherSelected = !isOtherSelected;
      } else {
        if (selectedIndexes.contains(index)) {
          selectedIndexes.remove(index);
        } else {
          selectedIndexes.add(index);
        }
      }
    });
  }

  final Set<int> selectedIndexes = {};
  bool isOtherSelected = false;
  final TextEditingController otherController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  final List<String> options = ["Sewage", "Water", "Waste", "Recycling"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const AppBarBack(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'You Or The City?',
                style: AppTypoGraphy.bold.copyWith(
                  color: AppColors.secondary,
                  fontSize: 26.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),
              Text(
                'Select What You Are Responsible For (Select All That Apply)',
                style: AppTypoGraphy.medium.copyWith(color: AppColors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 16.w,
                runSpacing: 16.h,
                children: List.generate(
                  options.length,
                  (index) => _buildTile(
                      context,
                      options[index],
                      "assets/images/${options[index].toLowerCase()}.png",
                      index),
                ),
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isOtherSelected = true;
                    selectedIndexes.clear();
                  });
                },
                child: Text(
                  'Other (not listed)',
                  style: AppTypoGraphy.bold.copyWith(
                    color: AppColors.primary,
                    fontSize: 20.sp,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              if (isOtherSelected) ...[
                SizedBox(height: 16.h),
                RoundedSearchBar(controller: otherController),
              ],
              SizedBox(height: 100.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButtonWidgetLight(
                    text: 'Skip',
                    onPressed: () {
                      Get.toNamed(RouteNames.finishUtility);
                    },
                  ),
                  CustomElevatedButton(
                    btnText: 'Next',
                    icon: Icons.arrow_forward,
                    onTap: () {
                      // Collect selected values
                      List<String> selectedValues = isOtherSelected
                          ? [otherController.text]
                          : selectedIndexes.map((i) => options[i]).toList();

                      // Update AuthController
                      authController.updateResponsibleFor(selectedValues);

                      // Navigate
                      Get.toNamed(RouteNames.finishUtility);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(
      BuildContext context, String title, String iconPath, int index) {
    final isSelected = selectedIndexes.contains(index) && !isOtherSelected;
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 64.w) / 2,
      child: SelectableTile(
        title: title,
        imageAsset: iconPath,
        isSelected: isSelected,
        onTap: () {
          setState(() {
            isOtherSelected = false;
            if (isSelected) {
              selectedIndexes.remove(index);
            } else {
              selectedIndexes.add(index);
            }
          });
        },
      ),
    );
  }
}
