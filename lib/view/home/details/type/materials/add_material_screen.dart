import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/controller/material_controller.dart';
import 'package:home_cache/utils.dart' as utils;
import 'package:home_cache/view/home/account/productsupport/widgets/text_field_widget.dart';
import 'package:home_cache/view/home/details/widgets/doccument_slider.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';
import 'package:home_cache/view/widget/time_text_field.dart';
import 'package:image_picker/image_picker.dart';

class AddMaterialScreen extends StatefulWidget {
  const AddMaterialScreen({super.key});

  @override
  State<AddMaterialScreen> createState() => _AddMaterialScreenState();
}

class _AddMaterialScreenState extends State<AddMaterialScreen> {
  final MaterialController controller = Get.put(MaterialController());

  final TextEditingController _notesController = TextEditingController();

  File? _imageFile;
  File? _documentFile;
  String? selectedType;
  String? selectedMaterial;

  // IDs passed from previous screen
  late String materialId;
  late String viewTypeId;
  late String roomId;
  late String typeName;
  late String roomName;

  @override
  void initState() {
    super.initState();
    // Receive IDs using Get.arguments
    final args = Get.arguments as Map<String, String>?;

    materialId = args?['material_id'] ?? '';
    viewTypeId = args?['view_type_id'] ?? '';
    roomId = args?['room_id'] ?? '';
    typeName = args?['type_name'] ?? '';
    roomName = args?['room_name'] ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (materialId.isNotEmpty) {
        controller.getTypeMaterialOption(materialId);
      }
    });

    print('material ID: ++++>>$materialId');
    print('View Type ID: ++++>>$viewTypeId');
    print('Room ID: ++++>>$roomId');
    print('Type Name: ++++>>$typeName');
    print('Room Name: ++++>>$roomName');
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
                          "material_id": materialId,
                          "view_type_id": viewTypeId,
                          "room_id": roomId,
                          "details": {
                            "Name": typeName,
                            "location": roomName,
                            "notes": _notesController.text.trim(),
                            "type": selectedType,
                            "material": selectedMaterial
                          }
                        };

                        print('Add Appliance Data: ++++>>$data');
                        controller.addNewMaterial(data);
                      },
                      icon: Image.asset("assets/icons/save_ic.png")),
                ],
              ),
            ),

            SizedBox(height: 16.h),

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
                              controller.selectedImageFile.value = null;
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
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
                            color: Colors.black.withOpacity(0.1),
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

            // ----- Name Field -----
            Text(
              'Name',
              style: AppTypoGraphy.semiBold.copyWith(color: AppColors.black),
            ),
            SizedBox(height: 6.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.lightgrey,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.grey,
                  width: 1.5.w,
                ),
              ),
              child: Text(
                typeName,
                style: AppTypoGraphy.regular.copyWith(
                  color: AppColors.black,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // ----- Location Field -----
            Text(
              'Location',
              style: AppTypoGraphy.semiBold.copyWith(color: AppColors.black),
            ),
            SizedBox(height: 6.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.lightgrey,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.grey,
                  width: 1.5.w,
                ),
              ),
              child: Text(
                roomName,
                style: AppTypoGraphy.regular.copyWith(
                  color: AppColors.black,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // ----- Type Dropdown -----
            Obx(() {
              final types = controller.typeMaterialOption.value?.type ?? [];
              if (types.isEmpty) return SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Type',
                    style:
                        AppTypoGraphy.semiBold.copyWith(color: AppColors.black),
                  ),
                  SizedBox(height: 6.h),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    items: types
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => selectedType = value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Select type',
                      filled: true,
                      fillColor: AppColors.lightgrey,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide:
                              BorderSide(color: AppColors.grey, width: 1.w)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: AppColors.grey,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: AppColors.grey,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              );
            }),

            // ----- Material Dropdown -----
            Obx(() {
              final materials =
                  controller.typeMaterialOption.value?.material ?? [];
              if (materials.isEmpty) return SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Material',
                    style:
                        AppTypoGraphy.semiBold.copyWith(color: AppColors.black),
                  ),
                  SizedBox(height: 6.h),
                  DropdownButtonFormField<String>(
                    value: selectedMaterial,
                    items: materials
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => selectedMaterial = value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Select material',
                      filled: true,
                      fillColor: AppColors.lightgrey,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide:
                              BorderSide(color: AppColors.grey, width: 1.w)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: AppColors.grey,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: AppColors.grey,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              );
            }),

            Text(
              'Last Service Date',
              style: AppTypoGraphy.semiBold.copyWith(color: AppColors.black),
            ),
            SizedBox(height: 6.h),

            TimeTextField(),
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

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
