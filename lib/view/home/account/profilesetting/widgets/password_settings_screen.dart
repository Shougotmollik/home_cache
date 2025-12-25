import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart' show AppColors;
import 'package:home_cache/controller/profile_controller.dart';
import 'package:home_cache/view/auth/signup/widgets/custom_elevated_button.dart';
import 'package:home_cache/view/auth/widgets/auth_text_form_field.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';

class PasswordSettingsScreen extends StatelessWidget {
  const PasswordSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());
    final TextEditingController _passwordTEController = TextEditingController();
    final TextEditingController _newPasswordTEController =
        TextEditingController();
    final TextEditingController _retypePasswordTEController =
        TextEditingController();
    return Scaffold(
      appBar: AppBarBack(
        title: 'Password Settings',
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
                'Password',
                style: AppTypoGraphy.semiBold.copyWith(color: AppColors.black),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 6.h),
              AuthTextFormField(
                  controller: _passwordTEController, hintText: '*************'),
              SizedBox(height: 48.h),
              Text(
                'New Password',
                style: AppTypoGraphy.semiBold.copyWith(color: AppColors.black),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 6.h),
              AuthTextFormField(
                  controller: _newPasswordTEController,
                  hintText: 'New Password'),
              SizedBox(height: 12.h),
              AuthTextFormField(
                  controller: _retypePasswordTEController,
                  hintText: 'Retype Password'),
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Text(
                  'Your password must be at least 8 characters, include a number, an uppercase letter, a lowercase letter, and a special character. ',
                  style: AppTypoGraphy.regular.copyWith(
                    color: AppColors.black,
                    fontSize: 14.sp,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
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
                "new_password": _newPasswordTEController.text,
                "confirm_password": _retypePasswordTEController.text,
                "old_password": _passwordTEController.text
              };
              await profileController.updatePassword(data);
            },
            btnText: 'Update',
            height: 48.h,
          ),
        ),
      ),
    );
  }
}
