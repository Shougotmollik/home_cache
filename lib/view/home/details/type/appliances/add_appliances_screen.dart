import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/controller/appliance_controller.dart';
import 'package:home_cache/utils.dart' as utils;
import 'package:home_cache/view/home/account/productsupport/widgets/text_field_widget.dart';
import 'package:home_cache/view/home/details/widgets/doccument_slider.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';
import 'package:image_picker/image_picker.dart';

class AddAppliancesScreen extends StatefulWidget {
  const AddAppliancesScreen({super.key});

  @override
  State<AddAppliancesScreen> createState() => _AddAppliancesScreenState();
}

class _AddAppliancesScreenState extends State<AddAppliancesScreen> {
  final ApplianceController controller = Get.put(ApplianceController());
  bool isPastExpanded = false;

  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  File? _imageFile;
  File? _documentFile;

  // IDs passed from previous screen
  late String applianceId;
  late String viewTypeId;
  late String roomId;
  late String typeName;

  @override
  void initState() {
    super.initState();

    // Receive IDs using Get.arguments
    final args = Get.arguments as Map<String, String>?;

    applianceId = args?['appliance_id'] ?? '';
    viewTypeId = args?['view_type_id'] ?? '';
    roomId = args?['room_id'] ?? '';
    typeName = args?['type_name'] ?? '';

    print('Appliance ID: ++++>>$applianceId');
    print('View Type ID: ++++>>$viewTypeId');
    print('Room ID: ++++>>$roomId');
  }

  @override
  Widget build(BuildContext context) {
    //! Pick image from camera
    Future<void> pickFromCamera() async {
      final file = await utils.pickSingleImage(
        context: context,
        source: ImageSource.camera,
      );

      if (file != null) {
        setState(() => _imageFile = file);
        controller.selectedImageFile.value = file;
      }
    }

    //! Pick file from storage
    Future<void> pickFile() async {
      final result = await FilePicker.platform.pickFiles(type: FileType.any);

      if (result != null) {
        final file = File(result.files.single.path!);

        setState(() => _documentFile = file);
        controller.selectedFile.value = file;

        debugPrint("Picked File: ${file.path}");
      }
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBarBack(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Add $typeName',
                      style: AppTypoGraphy.medium
                          .copyWith(color: AppColors.black)),
                  SizedBox(width: 6.w),
                  IconButton(
                      onPressed: () {
                        var data = {
                          "appliance_id": applianceId,
                          "view_type_id": viewTypeId,
                          "room_id": roomId,
                          "details": {
                            "type": _typeController.text.trim(),
                            "location": _locationController.text.trim(),
                            "notes": _notesController.text.trim()
                          }
                        };

                        print('Add Appliance Data: ++++>>$data');
                        controller.addNewAppliance(data);
                      },
                      icon: Image.asset("assets/icons/save_ic.png")),
                ],
              ),
            ),

            // ----- Image Upload Box -----
            Center(
              child: GestureDetector(
                onTap: () async {
                  await pickFromCamera();
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
                              controller.selectedImageFile.value =
                                  null; // Remove image
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
              controller: _typeController,
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
                controller: _locationController),

            SizedBox(height: 16.h),

            // ----- Notes Field -----
            Text(
              'Notes',
              style: AppTypoGraphy.semiBold.copyWith(color: AppColors.black),
            ),
            TextFieldWidget(
                hintText: 'Additional details about the appliance',
                controller: _notesController),
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
                  style:
                      AppTypoGraphy.semiBold.copyWith(color: AppColors.black),
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
                      pickFile();
                    },
                    padding: EdgeInsets.zero,
                    splashRadius: 20.r,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // ----- Document Slider -----
            DocumentSlider(
              documents: [
                if (_documentFile != null)
                  {
                    'title': _documentFile!.path.split('/').last,
                    'path': _documentFile!.path,
                    'iconPath': 'assets/images/document.png',
                    'date': '',
                  },
              ],
            ),
          ],
        ),
      ),
    );
  }
}
