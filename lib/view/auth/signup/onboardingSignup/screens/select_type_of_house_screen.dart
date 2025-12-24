import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/controller/auth_controller.dart';
import 'package:home_cache/view/auth/signup/onboardingSignup/dialogs/welcome_dialog.dart';
import 'package:home_cache/view/auth/signup/onboardingSignup/dialogs/home_selection_dialog.dart';
import 'package:home_cache/view/auth/signup/onboardingSignup/dialogs/home_progress_dialog.dart';
import 'package:home_cache/view/auth/signup/widgets/custom_elevated_button.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';
import 'package:home_cache/view/widget/rounded_search_bar.dart';
import 'package:home_cache/view/widget/selectable_tiles.dart';
import 'package:home_cache/view/widget/text_button_widget_light.dart';

import '../../../../../config/route/route_names.dart';

class SelectTypeOfHouseScreen extends StatefulWidget {
  const SelectTypeOfHouseScreen({super.key});

  @override
  State<SelectTypeOfHouseScreen> createState() =>
      _SelectTypeOfHouseScreenState();
}

class _SelectTypeOfHouseScreenState extends State<SelectTypeOfHouseScreen> {
  int? selectedIndex;
  bool isOtherSelected = false;
  final TextEditingController otherController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Future.delayed(const Duration(seconds: 0), () {
    //     _showFirstDialog();
    //   });
    // });
  }

  // void _showFirstDialog() {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) => const WelcomeDialog(),
  //   ).then((_) => _showSecondDialog());
  // }

  // void _showSecondDialog() {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) => const HomeSelectionDialog(),
  //   ).then((_) => _showThirdDialog());
  // }

  // void _showThirdDialog() {
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) => const HomeProgressDialog());
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const AppBarBack(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hey,',
                style: AppTypoGraphy.bold.copyWith(
                  color: AppColors.primary,
                  fontSize: 32.sp,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'What Type Of House Do You Live In?',
                style: AppTypoGraphy.bold.copyWith(
                  color: AppColors.secondary,
                  fontSize: 26.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),
              Wrap(
                spacing: 16.w,
                runSpacing: 16.h,
                children: [
                  _buildTile("House", "assets/images/house.png", 0),
                  _buildTile("Condo", "assets/images/condo.png", 1),
                  _buildTile("Townhouse", "assets/images/townhouse.png", 2),
                  _buildTile("Apartment", "assets/images/apartment.png", 3),
                ],
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = null;
                    isOtherSelected = true;
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
                const RoundedSearchBar(),
              ],
              SizedBox(height: 72.h),
              Row(
                children: [
                  Expanded(
                    child: TextButtonWidgetLight(
                      text: 'Skip',
                      onPressed: () {
                        Get.toNamed(RouteNames.finishUtility);
                      },
                    ),
                  ),
                  SizedBox(width: 100.w),
                  CustomElevatedButton(
                    onTap: () {
                      String? selectedHomeType;

                      if (isOtherSelected) {
                        selectedHomeType = otherController.text.trim();
                      } else if (selectedIndex != null) {
                        final houseTypes = [
                          "House",
                          "Condo",
                          "Townhouse",
                          "Apartment"
                        ];
                        selectedHomeType = houseTypes[selectedIndex!];
                      } else {
                        selectedHomeType = null;
                      }

                      if (selectedHomeType != null &&
                          selectedHomeType.isNotEmpty) {
                        authController.updateHomeType(selectedHomeType);
                      }

                      // Navigate to next screen
                      Get.toNamed(RouteNames.homeInfo);
                    },
                    btnText: 'Next',
                    icon: Icons.arrow_forward,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(String title, String iconPath, int index) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 64.w) / 2,
      child: SelectableTile(
        title: title,
        imageAsset: iconPath,
        isSelected: selectedIndex == index,
        onTap: () => setState(() {
          selectedIndex = index;
          isOtherSelected = false;
        }),
      ),
    );
  }
}
