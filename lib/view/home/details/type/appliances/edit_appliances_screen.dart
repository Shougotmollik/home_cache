import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart' show AppColors;
import 'package:home_cache/controller/appliance_controller.dart';
import 'package:home_cache/utils.dart' as utils;
import 'package:home_cache/view/home/account/productsupport/widgets/text_field_widget.dart';
import 'package:home_cache/view/home/details/widgets/doccument_slider.dart';
import 'package:home_cache/view/home/details/widgets/past_appoinment_tile.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';
import 'package:image_picker/image_picker.dart';

class EditAppliancesScreen extends StatefulWidget {
  const EditAppliancesScreen({super.key});

  @override
  State<EditAppliancesScreen> createState() => _EditAppliancesScreenState();
}

class _EditAppliancesScreenState extends State<EditAppliancesScreen> {
  bool isPastExpanded = false;
  late String id;

  final ApplianceController controller = Get.put(ApplianceController());
  bool isEditable = true;
  File? _imageFile;
  File? _documentFile;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    id = args['id'];
    debugPrint('Received Appliance ID: $id');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getApplianceDetails(id);
    });
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

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.single.path!);

        setState(() => _documentFile = file);
        controller.selectedFile.value = file;

        debugPrint("Picked File: ${file.path}");
      }
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBarBack(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.sp),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final appliance = controller.applianceDetails.value;
            if (appliance == null) {
              return Center(
                child: Text(
                  "No appliance details found.",
                  style: AppTypoGraphy.semiBold,
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        appliance.userAppliance?.appliance?.name ?? 'Appliance',
                        style:
                            AppTypoGraphy.bold.copyWith(color: AppColors.black),
                      ),
                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: () {
                          if (!isEditable) {
                            var data = {
                              "appliance_id":
                                  "6f77742d-628f-4d10-abb3-6aff9cf1329b",
                              "room_id": "bf6c26e4-7a20-47a5-ad7c-cde12862567c",
                              "details": {
                                "notes": controller.notesController.text,
                              },
                            };

                            controller.updateApplianceDetails(id, data);
                          }

                          // Toggle edit mode
                          setState(() {
                            isEditable = !isEditable;
                          });
                        },
                        child: Image.asset(
                          !isEditable
                              ? 'assets/icons/save_ic.png'
                              : 'assets/images/pen.png',
                          height: 24.h,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // Image Section
                Stack(
                  children: [
                    GestureDetector(
                      onTap: !isEditable
                          ? () {
                              pickFromCamera();
                            }
                          : null,
                      child: Center(
                        child: controller.selectedImageFile.value != null
                            ? Container(
                                height: 120.h,
                                width: 120.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: Colors.grey[300],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Image.file(
                                    controller.selectedImageFile.value!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : (controller.applianceDetails.value?.image !=
                                        null &&
                                    controller.applianceDetails.value!.image!
                                        .isNotEmpty)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: Image.network(
                                      controller.applianceDetails.value!.image!,
                                      height: 120.h,
                                      width: 120.w,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          height: 120.h,
                                          width: 120.w,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          child: Icon(
                                            Icons.image,
                                            size: 40.sp,
                                            color: Colors.grey[600],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Container(
                                    height: 120.h,
                                    width: 120.w,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Icon(
                                      Icons.image,
                                      size: 40.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                      ),
                    ),
                    // Remove button for selected image
                    if (controller.selectedImageFile.value != null)
                      Positioned(
                        top: 10.h,
                        right: 110.w,
                        child: GestureDetector(
                          onTap: () {
                            controller.selectedImageFile.value = null;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Type field
                Text(
                  'Type',
                  style:
                      AppTypoGraphy.semiBold.copyWith(color: AppColors.black),
                ),
                SizedBox(height: 6.h),
                TextFieldWidget(
                  controller: controller.typeController,
                  hintText: 'Type',
                  isReadable: true,
                ),
                SizedBox(height: 16.h),

                // Location field
                Text(
                  'Location',
                  style:
                      AppTypoGraphy.semiBold.copyWith(color: AppColors.black),
                ),
                SizedBox(height: 6.h),
                TextFieldWidget(
                  controller: controller.locationController,
                  hintText: 'Location',
                  isReadable: true,
                ),
                SizedBox(height: 16.h),

                // Notes field
                Text(
                  'Notes',
                  style:
                      AppTypoGraphy.semiBold.copyWith(color: AppColors.black),
                ),
                TextFieldWidget(
                  controller: controller.notesController,
                  hintText: 'Notes',
                  isReadable: isEditable,
                ),
                SizedBox(height: 16.h),

                // Past appointments
                if (isPastExpanded) ...[
                  PastAppointmentsTile(
                      date: "June 18, 2025", status: "AC Check"),
                  PastAppointmentsTile(
                      date: "May 05, 2025", status: "AC Check"),
                ],
                SizedBox(height: 20.h),

                // Documents Section
                Row(
                  children: [
                    Text(
                      'Documents',
                      style: AppTypoGraphy.semiBold
                          .copyWith(color: AppColors.black),
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
                        onPressed: pickFile,
                        padding: EdgeInsets.zero,
                        splashRadius: 20.r,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                Obx(() {
                  final List<Map<String, String>> allFiles = [];

                  if (controller.selectedFile.value != null) {
                    allFiles.add({
                      'file':
                          controller.selectedFile.value!.path.split('/').last,
                      'fileId': '',
                      'updatedAt': DateTime.now().toString(),
                    });
                  }

                  if (appliance.files != null) {
                    allFiles.addAll(appliance.files!
                        .map((e) => {
                              'file': e.file?.split('/').last ?? '',
                              'fileId': e.fileId ?? '',
                              'updatedAt': e.updatedAt ?? '',
                            })
                        .toList());
                  }

                  return DocumentSlider(documents: allFiles);
                }),
              ],
            );
          }),
        ),
      ),
    );
  }
}
