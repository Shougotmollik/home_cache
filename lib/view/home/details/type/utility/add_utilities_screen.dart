import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/controller/utilities_controller.dart';
import 'package:home_cache/model/utility_component_type.dart';
import 'package:home_cache/model/utility_model.dart';
import 'package:home_cache/view/home/account/productsupport/widgets/text_field_widget.dart';
import 'package:home_cache/view/home/details/widgets/doccument_slider.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';
import 'package:image_picker/image_picker.dart';

class AddUtilitiesScreen extends StatefulWidget {
  const AddUtilitiesScreen({super.key});

  @override
  State<AddUtilitiesScreen> createState() => _AddUtilitiesScreenState();
}

class _AddUtilitiesScreenState extends State<AddUtilitiesScreen> {
  final UtilitiesController utilitiesController =
      Get.put(UtilitiesController());
  // Reactive selected IDs
  final RxString selectedTypeId = ''.obs;
  final RxString selectedRoomId = ''.obs;
  File? _documentFile;

  UtilityComponent? selectedComponent;
  UtilityComponentType? selectedComponentType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Add Utilities',
                        style: AppTypoGraphy.medium
                            .copyWith(color: AppColors.black)),
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
                    final picked = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (picked != null) {
                      setState(() => utilitiesController
                          .selectedImageFile.value = File(picked.path));
                    }
                  },
                  child: Obx(() {
                    if (utilitiesController.selectedImageFile.value != null) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: Image.file(
                              utilitiesController.selectedImageFile.value!,
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
                                utilitiesController.selectedImageFile.value =
                                    null;
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

              Obx(() {
                final list = utilitiesController.utilityComponents;

                if (utilitiesController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (list.isEmpty) {
                  return const Text('No components found');
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Component', style: AppTypoGraphy.semiBold),
                    SizedBox(height: 6.h),
                    DropdownButtonFormField<UtilityComponent>(
                      value: selectedComponent,
                      items: list
                          .map(
                            (e) => DropdownMenuItem<UtilityComponent>(
                              value: e,
                              child: Text(e.name ?? ''),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                          selectedComponent = value;
                          selectedComponentType = null; // reset type
                        });

                        // 🚀 API CALL HERE
                        utilitiesController.getUtilityComponentTypes(value.id!);
                      },
                      decoration: _dec('Select Component'),
                    ),
                    SizedBox(height: 16.h),
                  ],
                );
              }),
              Obx(() {
                final list = utilitiesController.utilityComponentType;

                if (utilitiesController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (list.isEmpty) {
                  return const Text('Select component first');
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Component Type', style: AppTypoGraphy.semiBold),
                    SizedBox(height: 6.h),
                    DropdownButtonFormField<UtilityComponentType>(
                      value: selectedComponentType,
                      items: list
                          .map(
                            (e) => DropdownMenuItem<UtilityComponentType>(
                              value: e,
                              child: Text(e.name ?? ''),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedComponentType = value;
                        });
                      },
                      decoration: _dec('Select Component Type'),
                    ),
                    SizedBox(height: 16.h),
                  ],
                );
              }),

              // TextFieldWidget(
              //   hintText: 'e.g., Refrigerator, Washing Machine',
              //   controller: TextEditingController(),
              // ),

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

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  //! Pick file from storage
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null) {
      final file = File(result.files.single.path!);

      setState(() => _documentFile = file);
      utilitiesController.selectedFile.value = file;

      debugPrint("Picked File: ${file.path}");
    }
  }

  InputDecoration _dec(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.lightgrey,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.grey),
      ),
    );
  }
}
