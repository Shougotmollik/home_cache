import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/controller/paint_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart' show AppColors;
import 'package:home_cache/view/auth/signup/widgets/custom_elevated_button.dart';
import 'package:home_cache/view/home/account/productsupport/widgets/text_field_widget.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';
import 'package:intl/intl.dart';

class AddPaintItemScreen extends StatefulWidget {
  const AddPaintItemScreen({super.key});

  @override
  State<AddPaintItemScreen> createState() => _AddPaintItemScreenState();
}

class _AddPaintItemScreenState extends State<AddPaintItemScreen> {
  final TextEditingController brandController = TextEditingController();
  final TextEditingController brandLineController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController finishController = TextEditingController();
  final TextEditingController roomTEController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController lastPaintController = TextEditingController();

  // final RoomController roomController = Get.put(RoomController());

  final PaintController paintController = Get.put(PaintController());

  late String roomId;
  late String itemId;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    roomId = args?['room_id'] ?? '';
    itemId = args?['item_id'] ?? '';
    print("Room ID: =========>>>$roomId");
    print("Item ID: =========>>>$itemId");
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
                "room_id": roomId,
                "item_id": itemId
              };

              print("Form Data:====>>> $formData");
              await paintController.addNewPaintItem(formData);
            },
            btnText: paintController.isLoading.value ? 'Saving...' : 'Save',
            height: 48.h,
          ),
        ),
      ),
    );
  }
}
