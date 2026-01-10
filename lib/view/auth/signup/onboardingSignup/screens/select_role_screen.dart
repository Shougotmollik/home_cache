import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:home_cache/constants/colors.dart' show AppColors;
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/controller/auth_controller.dart';
import 'package:home_cache/view/auth/signup/onboardingSignup/dialogs/home_progress_dialog.dart';
import 'package:home_cache/view/auth/signup/onboardingSignup/dialogs/home_selection_dialog.dart';
import 'package:home_cache/view/auth/signup/onboardingSignup/dialogs/welcome_dialog.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';
import 'package:home_cache/view/widget/selectable_tiles.dart';
import 'package:home_cache/view/widget/rounded_search_bar.dart';

import '../../../../../config/route/route_names.dart';
import '../../widgets/custom_elevated_button.dart';

class SelectHouseRoleScreen extends StatefulWidget {
  const SelectHouseRoleScreen({super.key});

  @override
  State<SelectHouseRoleScreen> createState() => _SelectHouseRoleScreenState();
}

class _SelectHouseRoleScreenState extends State<SelectHouseRoleScreen> {
  int? selectedIndex;
  bool isOtherSelected = false;
  final TextEditingController otherController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 0), () {
        _showFirstDialog();
      });
    });
  }

  void _showFirstDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const WelcomeDialog(),
    ).then((_) => _showSecondDialog());
  }

  void _showSecondDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const HomeSelectionDialog(),
    ).then((_) => _showThirdDialog());
  }

  void _showThirdDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const HomeProgressDialog());
  }

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

              /// Title
              Text(
                'Select Your House Role',
                style: AppTypoGraphy.bold.copyWith(
                  color: AppColors.secondary,
                  fontSize: 26.sp,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 40.h),

              /// Subtitle
              Text(
                'Choose One Option',
                style: AppTypoGraphy.medium.copyWith(color: AppColors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),

              /// Tiles
              Wrap(
                spacing: 16.w,
                runSpacing: 16.h,
                children: [
                  _buildTile(
                      context, "House Owner", "assets/images/owner.png", 0),
                  _buildTile(context, "House Resident",
                      "assets/images/resident.png", 1),
                ],
              ),

              // SizedBox(height: 20.h),
              SizedBox(height: 180.h),

              // /// Other Option
              // GestureDetector(
              //   onTap: () {
              //     setState(() {
              //       isOtherSelected = true;
              //       selectedIndex = null;
              //     });
              //   },
              //   child: Text(
              //     'Other (not listed)',
              //     style: AppTypoGraphy.bold.copyWith(
              //       color: AppColors.primary,
              //       fontSize: 20.sp,
              //       decoration: TextDecoration.underline,
              //     ),
              //   ),
              // ),

              /// Search Bar for Other
              if (isOtherSelected) ...[
                SizedBox(height: 16.h),
                RoundedSearchBar(controller: otherController),
              ],

              SizedBox(height: 100.h),

              /// Bottom Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // TextButtonWidgetLight(
                  //   text: 'Skip',
                  //   onPressed: () {
                  //     Get.toNamed(RouteNames.finishUtility);
                  //   },
                  // ),
                  CustomElevatedButton(
                    onTap: () {
                      String? selectedRole;

                      if (isOtherSelected && otherController.text.isNotEmpty) {
                        selectedRole = otherController.text.trim();
                      } else if (selectedIndex != null) {
                        final options = [
                          "owner",
                          "resident",
                        ];
                        selectedRole = options[selectedIndex!];
                      } else {
                        selectedRole = null;
                      }

                      if (selectedRole != null && selectedRole.isNotEmpty) {
                        authController.updateHouseRole(selectedRole);
                        Get.toNamed(RouteNames.selectHouse);
                      } else {
                        Get.snackbar(
                            'Error', 'Please select or enter a house role');
                      }
                    },
                    icon: Icons.arrow_forward,
                    btnText: 'Next',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Tile Builder
  Widget _buildTile(
      BuildContext context, String title, String iconPath, int index) {
    final isSelected = selectedIndex == index && !isOtherSelected;

    return SizedBox(
      width: (MediaQuery.of(context).size.width - 64.w) / 2,
      child: SelectableTile(
        title: title,
        imageAsset: iconPath,
        isSelected: isSelected,
        onTap: () {
          setState(() {
            selectedIndex = index;
            isOtherSelected = false;
          });
        },
      ),
    );
  }
}
