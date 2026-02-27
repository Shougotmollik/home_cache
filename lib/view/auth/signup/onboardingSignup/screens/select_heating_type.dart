import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/colors.dart' show AppColors;
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/controller/auth_controller.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';
import 'package:home_cache/view/widget/selectable_tiles.dart';
import 'package:home_cache/view/widget/text_button_widget_light.dart';
import 'package:home_cache/view/widget/rounded_search_bar.dart';

import '../../../../../config/route/route_names.dart';
import '../../widgets/custom_elevated_button.dart';

class SelectHeatingTypeScreen extends StatefulWidget {
  const SelectHeatingTypeScreen({super.key});

  @override
  State<SelectHeatingTypeScreen> createState() =>
      _SelectHeatingTypeScreenState();
}

class _SelectHeatingTypeScreenState extends State<SelectHeatingTypeScreen> {
  final Set<int> selectedIndexes = {};
  bool isOtherSelected = false;
  final TextEditingController otherController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

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
              SizedBox(height: 2.h),
              Text(
                'Next, Let’s Cover Your Utilities',
                style: AppTypoGraphy.bold.copyWith(
                  color: AppColors.secondary,
                  fontSize: 24.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),
              Text(
                'Heating (Select All That Apply)',
                style: AppTypoGraphy.medium.copyWith(color: AppColors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 16.w,
                runSpacing: 16.h,
                children: [
                  _buildTile(
                      context, "Furnace", "assets/images/furnace.png", 0),
                  _buildTile(
                      context, "Hydronic", "assets/images/hydonic.png", 1),
                  _buildTile(
                      context, "Radiant", "assets/images/radiant.png", 2),
                  _buildTile(
                      context, "Heatpump", "assets/images/furnace.png", 3),
                  _buildTile(
                      context, "Wood Stove", "assets/images/wood.png", 4),
                  _buildTile(
                      context, "Baseboard", "assets/images/baseboard.png", 5),
                ],
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
                RoundedSearchBar(
                  controller: otherController,
                ),
              ],
              SizedBox(height: 50.h),
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
                    onTap: () {
                      // List of heating types
                      final heatingTypes = [
                        "Furnace",
                        "Hydronic",
                        "Radiant",
                        "Heatpump",
                        "Wood Stove",
                        "Baseboard"
                      ];

                      // Get selected types
                      List<String> selectedHeatingTypes =
                          selectedIndexes.map((i) => heatingTypes[i]).toList();

                      // Include "Other" if typed
                      if (isOtherSelected && otherController.text.isNotEmpty) {
                        selectedHeatingTypes.add(otherController.text.trim());
                      }

                      if (selectedHeatingTypes.isNotEmpty) {
                        // Update AuthController
                        authController
                            .updateHomeHeatingType(selectedHeatingTypes);
                        // Navigate to next screen
                        Get.toNamed(RouteNames.selectHeatPowerType);
                      } else {
                        Get.snackbar('Error',
                            'Please select or enter at least one heating type');
                      }
                    },
                    icon: Icons.arrow_forward,
                    btnText: 'Next',
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
