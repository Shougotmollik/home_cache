import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/controller/material_controller.dart';
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
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _shutoffController = TextEditingController();

  File? _documentFile;
  File? _imageFile;

  String? selectedType;
  String? selectedMaterial;
  DateTime? lastServiceDate;
  DateTime? lastFilledDate;

  late String materialId;
  late String viewTypeId;
  late String roomId;
  late String typeName;
  late String roomName;

  final ImagePicker _picker = ImagePicker();

  final Map<String, List<String>> componentFields = {
    "Foundation": ["type", "material", "date", "notes"],
    "Framing": ["type", "material", "date", "notes"],
    "Roofing": ["type", "material", "date", "notes"],
    "Siding": ["type", "material", "date", "notes"],
    "Windows": ["type", "material", "date", "notes"],
    "Doors": ["type", "material", "date", "notes"],
    "Garage Door": ["type", "material", "date", "notes"],
    "Insulation": ["type", "material", "date", "notes"],
    "Drywall": ["type", "material", "date", "notes"],
    "Flooring": ["type", "material", "date", "notes"],
    "Trim": ["type", "material", "date", "notes"],
    "Decking": ["type", "material", "date", "notes"],
    "Fencing": ["material", "date", "notes"],
    "Driveway": ["material", "date", "notes"],
    "Patio": ["type", "material", "date", "notes"],
    "Water Softener": ["type", "brand", "last_filled_date", "notes"],
    "Plumbing": ["pipe_material", "shutoff_location", "date", "notes"],
  };

  @override
  void initState() {
    super.initState();

    final args = Get.arguments as Map<String, String>?;

    materialId = args?['material_id'] ?? '';
    viewTypeId = args?['view_type_id'] ?? '';
    roomId = args?['room_id'] ?? '';
    typeName = args?['type_name'] ?? '';
    roomName = args?['room_name'] ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getTypeMaterialOption(materialId);
    });
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

  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  void onSave() {
    controller.addNewMaterial({
      "material_id": materialId,
      "view_type_id": viewTypeId,
      "room_id": roomId,
      "details": {
        "name": typeName,
        "location": roomName,
        "type": selectedType,
        "material": selectedMaterial,
        "brand": _brandController.text.trim(),
        "shutoff_location": _shutoffController.text.trim(),
        "last_service_date": lastServiceDate?.toIso8601String(),
        "last_filled_date": lastFilledDate?.toIso8601String(),
        "notes": _notesController.text.trim(),
      }
    });
  }

  Widget buildDynamicFields() {
    final fields = componentFields[typeName] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: fields.map((f) {
        switch (f) {
          case "type":
            return Obx(() {
              final list = controller.typeMaterialOption.value?.type ?? [];
              if (list.isEmpty) return const SizedBox();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Type', style: AppTypoGraphy.semiBold),
                  SizedBox(height: 6.h),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    items: list
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedType = v),
                    decoration: _dec('Select type'),
                  ),
                  SizedBox(height: 16.h),
                ],
              );
            });

          case "material":
            return Obx(() {
              final list = controller.typeMaterialOption.value?.material ?? [];
              if (list.isEmpty) return const SizedBox();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Material', style: AppTypoGraphy.semiBold),
                  SizedBox(height: 6.h),
                  DropdownButtonFormField<String>(
                    value: selectedMaterial,
                    items: list
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedMaterial = v),
                    decoration: _dec('Select material'),
                  ),
                  SizedBox(height: 16.h),
                ],
              );
            });

          case "brand":
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Brand', style: AppTypoGraphy.semiBold),
                SizedBox(height: 6.h),
                TextFieldWidget(
                  controller: _brandController,
                  hintText: 'Brand',
                ),
                SizedBox(height: 16.h),
              ],
            );

          case "pipe_material":
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pipe Material', style: AppTypoGraphy.semiBold),
                SizedBox(height: 6.h),
                TextFieldWidget(
                  controller: _brandController,
                  hintText: 'PEX, PVC, Copper',
                ),
                SizedBox(height: 16.h),
              ],
            );

          case "shutoff_location":
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Shutoff Location', style: AppTypoGraphy.semiBold),
                SizedBox(height: 6.h),
                TextFieldWidget(
                  controller: _shutoffController,
                  hintText: 'Under sink, basement',
                ),
              ],
            );

          case "date":
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Last Service Date', style: AppTypoGraphy.semiBold),
                SizedBox(height: 6.h),
                TimeTextField(
                  onDateSelected: (d) => lastServiceDate = d,
                ),
                SizedBox(height: 16.h),
              ],
            );

          case "last_filled_date":
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Last Filled Date', style: AppTypoGraphy.semiBold),
                SizedBox(height: 6.h),
                TimeTextField(
                  onDateSelected: (d) => lastFilledDate = d,
                ),
                SizedBox(height: 16.h),
              ],
            );

          case "notes":
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Notes', style: AppTypoGraphy.semiBold),
                SizedBox(height: 6.h),
                TextFieldWidget(
                  controller: _notesController,
                  hintText: 'Additional details',
                ),
                SizedBox(height: 16.h),
              ],
            );

          default:
            return const SizedBox();
        }
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<void> pickFile() async {
      final result = await FilePicker.platform.pickFiles();
      if (result != null) {
        _documentFile = File(result.files.single.path!);
        setState(() {});
      }
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBarBack(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          children: [
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Add $typeName', style: AppTypoGraphy.medium),
                IconButton(
                  onPressed: onSave,
                  icon: Image.asset("assets/icons/save_ic.png"),
                )
              ],
            ),

            SizedBox(height: 16.h),

            // Image Upload
            GestureDetector(
              onTap: pickImage,
              child: _imageFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Image.file(
                        _imageFile!,
                        height: 120.h,
                        width: 120.w,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      height: 120.h,
                      width: 120.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/camera.png', height: 40.h),
                          SizedBox(height: 6.h),
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Take A Photo To Upload Image',
                              textAlign: TextAlign.center,
                              style: AppTypoGraphy.regular.copyWith(
                                fontSize: 14.sp
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
            ),

            SizedBox(height: 20.h),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name", style: AppTypoGraphy.semiBold),
                SizedBox(height: 6.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.lightgrey,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.grey, width: 1.5.w),
                  ),
                  child: Text(typeName, style: AppTypoGraphy.regular),
                ),
                SizedBox(height: 16.h),
                Text("Location", style: AppTypoGraphy.semiBold),
                SizedBox(height: 6.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.lightgrey,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.grey, width: 1.5.w),
                  ),
                  child: Text(roomName, style: AppTypoGraphy.regular),
                ),
                SizedBox(height: 16.h),
              ],
            ),

            //!Dynamic Fields
            buildDynamicFields(),

            SizedBox(height: 12.h),

            // Documents
            Row(
              spacing: 8.w,
              children: [
                Text('Documents', style: AppTypoGraphy.semiBold),
                GestureDetector(
                  onTap: pickFile,
                  child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 16.sp,
                      )),
                )
              ],
            ),

            DocumentSlider(
              documents: _documentFile == null
                  ? []
                  : [
                      {
                        'title': _documentFile!.path.split('/').last,
                        'path': _documentFile!.path,
                        'iconPath': 'assets/images/document.png',
                        'date': '',
                      }
                    ],
            ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
