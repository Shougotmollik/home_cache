import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/controller/utilities_controller.dart';
import 'package:home_cache/view/home/account/productsupport/widgets/text_field_widget.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';

class AddUtilitiesScreen extends StatefulWidget {
  const AddUtilitiesScreen({super.key});

  @override
  State<AddUtilitiesScreen> createState() => _AddUtilitiesScreenState();
}

class _AddUtilitiesScreenState extends State<AddUtilitiesScreen> {
  final UtilitiesController controller = Get.put(UtilitiesController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Add Utilities',
                    style:
                        AppTypoGraphy.medium.copyWith(color: AppColors.black)),
                SizedBox(width: 6.w),
                IconButton(
                    onPressed: () {},
                    icon: Image.asset("assets/icons/save_ic.png")),
              ],
            ),
          ),

          // ----- Image Upload Box -----
          Center(
            child: GestureDetector(
              onTap: () async {
                // await pickFromCamera();
              },
              child: Obx(() {
                if (controller.selectedImageFile.value != null) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Image.file(
                          controller.selectedImageFile.value!,
                          height: 120.h,
                          width: 120.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: GestureDetector(
                          onTap: () {
                            // Remove image
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(4.w),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container(
                    height: 120.h,
                    width: 120.w,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/camera.png',
                          height: 32.h,
                          width: 32.w,
                          color: AppColors.black,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Take A Photo To Upload Image',
                          textAlign: TextAlign.center,
                          style: AppTypoGraphy.regular.copyWith(
                            color: AppColors.black,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),
            ),
          ),

          SizedBox(height: 16.h),

          // ----- Type Field -----
          Text(
            'Type',
            style: AppTypoGraphy.semiBold.copyWith(color: AppColors.black),
          ),
          SizedBox(height: 6.h),
          TextFieldWidget(
            hintText: 'e.g., Refrigerator, Washing Machine',
            controller: TextEditingController(),
          ),

          SizedBox(height: 16.h),

          // ----- Location Field -----
          Text(
            'Location',
            style: AppTypoGraphy.semiBold.copyWith(color: AppColors.black),
          ),
          SizedBox(height: 6.h),
          TextFieldWidget(
              hintText: 'e.g., Kitchen, Laundry Room',
              controller: TextEditingController()),

          SizedBox(height: 16.h),

          // ----- Notes Field -----
          Text(
            'Notes',
            style: AppTypoGraphy.semiBold.copyWith(color: AppColors.black),
          ),
          TextFieldWidget(
              hintText: 'Additional details about the appliance',
              controller: TextEditingController()),
          SizedBox(height: 16.h),

          // // ----- Past Appointments -----
          // if (isPastExpanded) ...[
          //   PastAppointmentsTile(date: "June 18, 2025", status: "AC Check"),
          //   PastAppointmentsTile(date: "May 05, 2025", status: "AC Check"),
          // ],
          SizedBox(height: 20.h),

          // ----- Documents Section -----
          Row(
            children: [
              Text(
                'Documents',
                style: AppTypoGraphy.semiBold.copyWith(color: AppColors.black),
              ),
              SizedBox(width: 6.w),
              Container(
                height: 24.h,
                width: 24.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.add, color: Colors.white, size: 18.sp),
                  onPressed: () {
                    // pickFile();
                  },
                  padding: EdgeInsets.zero,
                  splashRadius: 20.r,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // ----- Document Slider -----
        ],
      ),
    );
  }
}
