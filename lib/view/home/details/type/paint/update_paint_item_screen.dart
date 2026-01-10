import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/controller/paint_controller.dart';
import 'package:home_cache/model/paint_item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart' show AppColors;
import 'package:home_cache/view/auth/signup/widgets/custom_elevated_button.dart';
import 'package:home_cache/view/home/account/productsupport/widgets/text_field_widget.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';
import 'package:intl/intl.dart';

class UpdatePaintItemScreen extends StatefulWidget {
  const UpdatePaintItemScreen({super.key});

  @override
  State<UpdatePaintItemScreen> createState() => _UpdatePaintItemScreenState();
}

class _UpdatePaintItemScreenState extends State<UpdatePaintItemScreen> {
  late final TextEditingController brandController = TextEditingController();
  late final TextEditingController brandLineController =
      TextEditingController();
  late final TextEditingController typeController = TextEditingController();
  late final TextEditingController colorController = TextEditingController();
  late final TextEditingController locationController = TextEditingController();
  late final TextEditingController finishController = TextEditingController();
  late final TextEditingController roomTEController = TextEditingController();
  late final TextEditingController lastPaintController =
      TextEditingController();

  final PaintController paintController = Get.put(PaintController());

  // late String roomId;
  // late String itemId;

  late PaintItem paintItem;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    paintItem = args?['paintItem'];

    // prefill fields
    brandController.text = paintItem.details.brand;
    brandLineController.text = paintItem.details.brandLine;
    typeController.text = paintItem.details.type;
    colorController.text = paintItem.details.color;
    finishController.text = paintItem.details.finish;
    roomTEController.text = paintItem.details.location;
    lastPaintController.text = paintItem.details.lastPainted!.toIso8601String();
  }

// Pick image from gallery or camera
  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: source, imageQuality: 80);
    if (image != null) {
      paintController.selectedFile.value = File(image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBarBack(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      SafeArea(
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(16),
                          child: Wrap(
                            children: [
                              ListTile(
                                leading: Icon(Icons.photo_library),
                                title: Text('Gallery'),
                                onTap: () {
                                  pickImage(ImageSource.gallery);
                                  Get.back();
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.camera_alt),
                                title: Text('Camera'),
                                onTap: () {
                                  pickImage(ImageSource.camera);
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Obx(
                    () => paintController.selectedFile.value == null
                        ? Container(
                            height: 120.h,
                            width: 120.w,
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(35),
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
                                  'Pick an Image',
                                  textAlign: TextAlign.center,
                                  style: AppTypoGraphy.regular.copyWith(
                                    color: AppColors.black,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: Image.file(
                              paintController.selectedFile.value!,
                              height: 120.h,
                              width: 120.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Brand
              Text('Brand',
                  style:
                      AppTypoGraphy.semiBold.copyWith(color: AppColors.black)),
              SizedBox(height: 6.h),
              TextFieldWidget(
                  controller: brandController, hintText: 'Enter brand name'),
              SizedBox(height: 16.h),

              // Brand Line
              Text('Brand Line',
                  style:
                      AppTypoGraphy.semiBold.copyWith(color: AppColors.black)),
              SizedBox(height: 6.h),
              TextFieldWidget(
                  controller: brandLineController,
                  hintText: 'Enter brand line'),
              SizedBox(height: 16.h),

              // Type
              Text('Type',
                  style:
                      AppTypoGraphy.semiBold.copyWith(color: AppColors.black)),
              SizedBox(height: 6.h),
              TextFieldWidget(
                  controller: typeController, hintText: 'Enter type'),
              SizedBox(height: 16.h),

              // Color
              Text('Color',
                  style:
                      AppTypoGraphy.semiBold.copyWith(color: AppColors.black)),
              SizedBox(height: 6.h),
              TextFieldWidget(
                  controller: colorController, hintText: 'Enter color'),
              SizedBox(height: 16.h),

              // Finish
              Text('Finish',
                  style:
                      AppTypoGraphy.semiBold.copyWith(color: AppColors.black)),
              SizedBox(height: 6.h),
              TextFieldWidget(
                  controller: finishController, hintText: 'Enter finish'),
              SizedBox(height: 16.h),

              // Room
              Text('Room',
                  style:
                      AppTypoGraphy.semiBold.copyWith(color: AppColors.black)),
              SizedBox(height: 6.h),
              TextFieldWidget(
                  controller: roomTEController, hintText: 'Enter room name'),
              SizedBox(height: 16.h),

              // Location
              Text('Location',
                  style:
                      AppTypoGraphy.semiBold.copyWith(color: AppColors.black)),
              SizedBox(height: 6.h),
              TextFieldWidget(
                  controller: locationController, hintText: 'Enter location'),
              SizedBox(height: 16.h),

              // Last Painted
              Text('Last Painted',
                  style:
                      AppTypoGraphy.semiBold.copyWith(color: AppColors.black)),
              SizedBox(height: 6.h),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    lastPaintController.text =
                        DateFormat('MM/dd/yyyy').format(pickedDate);
                  }
                },
                child: AbsorbPointer(
                  child: TextFieldWidget(
                      controller: lastPaintController,
                      hintText: 'Enter last painted date'),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.h),
          child: CustomElevatedButton(
            onTap: () async {
              Map<String, dynamic> formData = {
                "type": typeController.text,
                "location": locationController.text,
                "brand": brandController.text,
                "brand_line": brandLineController.text,
                "color": colorController.text,
                "finish": finishController.text,
                "last_painted": lastPaintController.text,
                "room_name": roomTEController.text,
                // "room_id": roomId,
                // "item_id": itemId
              };

              // print("Form Data:====>>> $formData");
              await paintController.updatePaintItemDetails(
                  formData, paintItem.id);
            },
            btnText: paintController.isLoading.value ? 'Updating...' : 'Update',
            height: 48.h,
          ),
        ),
      ),
    );
  }
}
