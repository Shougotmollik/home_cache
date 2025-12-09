import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart' show AppColors;
import 'package:home_cache/controller/auth_controller.dart';
import 'package:home_cache/controller/user_controller.dart';
import 'package:home_cache/view/home/account/widgets/setting_tile.dart';
import 'package:home_cache/view/widget/text_button_widget.dart';
import '../../../../config/route/route_names.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());
    final AuthController authController = Get.put(AuthController());

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'Account Management',
                style: AppTypoGraphy.bold.copyWith(color: AppColors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),

              // User Info Card
              Obx(() {
                if (userController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (userController.userDataList.isEmpty) {
                  return Center(child: Text("No user data found"));
                }

                final userData = userController.userDataList.first;

                return Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40.r),
                        child: userData.profile?.image != null
                            ? Image.network(
                                userData.profile!.image!,
                                width: 60.w,
                                height: 60.w,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/dot.png',
                                width: 20.w,
                                height: 20.w,
                                fit: BoxFit.cover,
                              ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${userData.profile?.firstName ?? ""} ${userData.profile?.lastName ?? ""}",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              userData.homeData?.homeAddress ??
                                  "No address provided",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.black,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            // Text(
                            //   userData.homeData?.home?.homeRoomId != null
                            //       ? "Home Room ID: ${userData.homeData!.home!.homeRoomId!}"
                            //       : "No home data",
                            //   style: TextStyle(
                            //     fontSize: 14.sp,
                            //     color: AppColors.black,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),

              Divider(color: AppColors.primary),
              SizedBox(height: 12.h),

              // Settings Tiles
              SettingsTile(
                leading: Image.asset(
                  "assets/images/subcription.png",
                  width: 24.w,
                ),
                title: 'Subscription',
                onTap: () {
                  Get.toNamed(RouteNames.subscription);
                },
              ),
              SizedBox(height: 12.h),
              SettingsTile(
                leading: Image.asset("assets/images/bell.png", width: 24.w),
                title: 'Profile Settings',
                onTap: () {
                  Get.toNamed(RouteNames.profileSetting);
                },
              ),
              SizedBox(height: 12.h),
              SettingsTile(
                leading: Image.asset("assets/images/lock.png", width: 24.w),
                title: 'Product Support',
                onTap: () {
                  Get.toNamed(RouteNames.productSupport);
                },
              ),
              SizedBox(height: 12.h),
              SettingsTile(
                leading: Image.asset("assets/images/group.png", width: 24.w),
                title: 'Household Management',
                onTap: () {
                  Get.toNamed(RouteNames.householdManagement);
                },
              ),
              SizedBox(height: 120.h),

              // Log Out Button
              TextWidgetButton(
                text: 'Log Out',
                width: 0.5.sw,
                onPressed: () {
                  authController.logOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
