import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/config/route/route_names.dart';
import 'package:home_cache/constants/app_assets.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/controller/auth_controller.dart';
import 'package:home_cache/utils/form_validator.dart';
import 'package:home_cache/view/auth/signup/widgets/custom_elevated_button.dart';
import 'package:home_cache/view/auth/widgets/custom_social_button.dart';
import 'package:home_cache/view/auth/widgets/auth_text_form_field.dart';
import 'package:home_cache/view/widget/text_button_widget_light.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

final TextEditingController _emailTEController = TextEditingController();
final TextEditingController _passwordTEController = TextEditingController();

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final FormValidator _formValidator = FormValidator();

final AuthController _authController = Get.put(AuthController());

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.sp),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 100.h),
                Text(
                  'Welcome Back!',
                  style:
                      AppTypoGraphy.bold.copyWith(color: AppColors.secondary),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40.h),
                Text(
                  'Email',
                  style:
                      AppTypoGraphy.semiBold.copyWith(color: AppColors.black),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 6.h),
                AuthTextFormField(
                  hintText: 'example@example.com',
                  controller: _emailTEController,
                  validator: _formValidator.validateEmail,
                ),
                SizedBox(height: 20.h),
                Text(
                  'Password',
                  style:
                      AppTypoGraphy.semiBold.copyWith(color: AppColors.black),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 6.h),
                AuthTextFormField(
                  hintText: '*************',
                  controller: _passwordTEController,
                  validator: _formValidator.validatePassword,
                ),
                SizedBox(height: 6.h),
                _buildForgotPassButton(),
                SizedBox(height: 50.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.w),
                  child: Column(
                    children: [
                      Obx(
                        () => CustomElevatedButton(
                          onTap: _loginButton,
                          width: 208.w,
                          btnText: 'Log In',
                          isLoading: _authController.isLoading.value,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      TextButtonWidgetLight(
                        text: 'Create Account',
                        width: 208.w,
                        onPressed: () {
                          Get.toNamed(RouteNames.signup);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50.h),
                Text(
                  'Or log in with',
                  style: AppTypoGraphy.semiBold.copyWith(
                    color: AppColors.black,
                    fontSize: 14.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
                _buildSocialLoginSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPassButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {},
        child: Text(
          'Forgot Password',
          style: AppTypoGraphy.semiBold.copyWith(
            color: AppColors.secondary,
            fontSize: 14.sp,
          ),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  Widget _buildSocialLoginSection() {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      children: [
        CustomSocialButton(
          btnIcon: AppAssets.googleIcon,
          onTap: () {},
        ),
        CustomSocialButton(
          btnIcon: AppAssets.appleIcon,
          onTap: () {},
        ),
        CustomSocialButton(
          btnIcon: AppAssets.microsoftIcon,
          onTap: () {},
        ),
        CustomSocialButton(
          btnIcon: AppAssets.metaIcon,
          onTap: () {},
        ),
      ],
    );
  }

  void _loginButton() {
    _formValidator.validateAndProceed(
      _formKey,
      () {
        // Get.toNamed(RouteNames.bottomNav);
        _authController.login({
          "email": _emailTEController.text,
          "password": _passwordTEController.text,
        });
      },
    );
  }
}
