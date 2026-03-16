import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/controller/auth_controller.dart';
import 'package:home_cache/utils/form_validator.dart';
import 'package:home_cache/view/auth/login/verify_reset_password.dart';
import 'package:home_cache/view/auth/widgets/auth_text_form_field.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FormValidator _formValidator = FormValidator();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _emailTEController = TextEditingController();
    final AuthController _controller = Get.put(AuthController());
    return Scaffold(
      appBar: AppBarBack(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Enter Your Email Address To Reset Your Password',
                textAlign: TextAlign.center,
                style: AppTypoGraphy.bold.copyWith(
                  color: AppColors.black,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 20.h),
              AuthTextFormField(
                hintText: 'example@example.com',
                controller: _emailTEController,
                validator: _formValidator.validateEmail,
              ),
              SizedBox(height: 24.h),
              Obx(
                () => ElevatedButton(
                    onPressed: () {
                      _formValidator.validateAndProceed(
                        _formKey,
                        () async {
                          final result = await _controller.forgotPassword(
                              {"email": _emailTEController.text});
                          if (result) {
                            Get.to(() => const VerifyResetPassword(),
                                arguments: {
                                  "email": _emailTEController.text,
                                  "userId": result
                                });
                          }
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: _controller.isLoading.value
                        ? SizedBox(
                            height: 18.h,
                            width: 18.w,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Reset Password',
                            style: AppTypoGraphy.semiBold.copyWith(
                              color: AppColors.white,
                              fontSize: 16.sp,
                            ),
                          )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
