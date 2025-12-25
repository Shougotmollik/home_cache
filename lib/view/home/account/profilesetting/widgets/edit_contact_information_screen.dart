import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart' show AppColors;
import 'package:home_cache/controller/profile_controller.dart';
import 'package:home_cache/view/auth/signup/widgets/custom_elevated_button.dart';
import 'package:home_cache/view/auth/widgets/auth_text_form_field.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';

class EditContactInformationScreen extends StatelessWidget {
  const EditContactInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBarBack(
        title: 'Contact Information',
        titleColor: AppColors.black,
      ),
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Name',
                style: AppTypoGraphy.semiBold.copyWith(color: AppColors.black),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  Expanded(
                      child: AuthTextFormField(
                    hintText: 'First',
                    controller: controller.firstNameController,
                  )),
                  SizedBox(width: 16.w),
                  Expanded(
                      child: AuthTextFormField(
                    hintText: 'Last',
                    controller: controller.lastNameController,
                  )),
                ],
              ),
              SizedBox(height: 20.h),
              SizedBox(height: 20.h),
              Text(
                'Address',
                style: AppTypoGraphy.semiBold.copyWith(color: AppColors.black),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 6.h),
              _buildAddressSelection(controller),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.sp),
          child: CustomElevatedButton(
            onTap: () async {
              var data = {
                'first_name': controller.firstNameController.text,
                'last_name': controller.lastNameController.text,
                'address': controller.addressController.text
              };
              await controller.updateProfile(data);
            },
            btnText: controller.isLoading.value ? 'Updating...' : 'Update',
            height: 48.h,
          ),
        ),
      ),
    );
  }

  Widget _buildAddressSelection(ProfileController controller) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        width: double.infinity,
        color: AppColors.lightgrey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 8.h),
            Row(
              children: [
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: TextFormField(
                      controller: controller.addressController,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Your Address',
                        hintStyle:
                            TextStyle(fontSize: 18.sp, color: Colors.black54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                InkWell(
                  onTap: controller.clearAddress,
                  child: SvgPicture.asset(
                    'assets/icons/cross.svg',
                    height: 48.h,
                  ),
                ),
              ],
            ),
            Obx(() => controller.addressSuggestions.isNotEmpty
                ? Column(
                    children: [
                      Divider(
                        color: AppColors.black,
                        thickness: 1.h,
                        height: 6.h,
                      ),
                      ...controller.addressSuggestions.map(
                          (text) => _addressSuggestionItem(text, controller)),
                    ],
                  )
                : SizedBox()),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Widget _addressSuggestionItem(String text, ProfileController controller) {
    return InkWell(
      onTap: () => controller.selectAddress(text),
      child: Container(
        padding: EdgeInsets.only(
            left: 24.sp, right: 24.sp, top: 18.sp, bottom: 18.sp),
        child: Text(
          text,
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
    );
  }
}
