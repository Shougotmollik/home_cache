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
import 'package:home_cache/view/widget/custom_progress_indicator.dart';
import 'package:home_cache/view/widget/time_text_field.dart';
import 'package:image_picker/image_picker.dart';

class EditMaterialScreen extends StatefulWidget {
  const EditMaterialScreen({super.key});

  @override
  State<EditMaterialScreen> createState() => _EditMaterialScreenState();
}

class _EditMaterialScreenState extends State<EditMaterialScreen> {
  final MaterialController controller = Get.put(MaterialController());

  File? _documentFile;
  File? _imageFile;

  String? selectedType;
  String? selectedMaterial;
  DateTime? lastServiceDate;
  DateTime? lastFilledDate;

  late String materialId;
  late String roomId;
  late String typeName;
  late String roomName;

  // Edit mode flag
  bool isEditMode = false;
  bool isDataFetched = false;

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

  // Fallback options if API doesn't provide them
  final Map<String, List<String>> fallbackTypeOptions = {
    "Doors": ["Swing", "Sliding", "Folding", "Revolving"],
    "Windows": ["Casement", "Double Hung", "Sliding", "Awning"],
    "Roofing": ["Asphalt Shingles", "Metal", "Tile", "Flat"],
  };

  final Map<String, List<String>> fallbackMaterialOptions = {
    "Doors": ["Wood", "Metal", "Glass", "Fiberglass"],
    "Windows": ["Vinyl", "Wood", "Aluminum", "Fiberglass"],
    "Roofing": ["Asphalt", "Metal", "Clay", "Concrete"],
  };

  @override
  void initState() {
    super.initState();

    final args = Get.arguments as Map<String, String>?;

    materialId = args?['id'] ?? '';
    typeName = args?['type_name'] ?? '';
    roomName = args?['room_name'] ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchMaterialDetails();
    });
  }

  // Fetch material details
  Future<void> fetchMaterialDetails() async {
    final details = await controller.getMaterialDetails(materialId);

    if (details != null) {
      setState(() {
        // Populate fields with fetched data
        selectedType = details.details.type;
        selectedMaterial = details.details.material;
        lastServiceDate = details.details.lastServiceDate;
        lastFilledDate = details.details.lastFieldDate;

        // Update typeName and roomName from fetched data
        typeName = details.userMaterial.material.name;
        roomName = details.room.name;

        // Set the fetched data flag
        isDataFetched = true;
      });

      // Fetch type material options using the correct material type ID
      await controller.getTypeMaterialOption(details.userMaterial.material.id);
    }
  }

  InputDecoration _dec(String hint, {bool enabled = true}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: enabled ? AppColors.lightgrey : Colors.grey.shade200,
      enabled: enabled,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.grey),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  Future<void> pickImage() async {
    if (!isEditMode) return; // Only allow in edit mode

    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  void toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;
    });
  }

  // void onSave() {
  //   if (!isEditMode) return;

  //   controller.addNewMaterial({
  //     "material_id": materialId,
  //     "view_type_id": viewTypeId,
  //     "room_id": roomId,
  //     "details": {
  //       "name": typeName,
  //       "location": roomName,
  //       "type": selectedType,
  //       "material": selectedMaterial,
  //       "brand": controller.brandController.text.trim(),
  //       "shutoff_location": controller.shutoffLocationController.text.trim(),
  //       "last_service_date": lastServiceDate?.toIso8601String(),
  //       "last_filled_date": lastFilledDate?.toIso8601String(),
  //       "notes": controller.notesController.text.trim(),
  //     }
  //   });
  // }

  void toggleEditModeAndSave() {
    if (!isEditMode) {
      final materialId = controller.materialDetails.value?.id;
      print("Material ID: ============> $materialId");
      var data = {
        "details": {
          "name": typeName,
          "location": roomName,
          "type": selectedType,
          "material": selectedMaterial,
          "brand": controller.brandController.text.trim(),
          "shutoff_location": controller.shutoffLocationController.text.trim(),
          "last_service_date": lastServiceDate?.toIso8601String(),
          "last_filled_date": lastFilledDate?.toIso8601String(),
          "notes": controller.notesController.text.trim(),
        }
      };

      controller.updateMaterialDetails(materialId!, data);
    }
  }

  Widget buildDynamicFields() {
    final fields = componentFields[typeName] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: fields.map((f) {
        switch (f) {
          case "type":
            return Obx(() {
              var list = controller.typeMaterialOption.value?.type ?? [];
              if (list.isEmpty) {
                list = fallbackTypeOptions[typeName] ?? [];
              }

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
                    onChanged: isEditMode
                        ? (v) => setState(() => selectedType = v)
                        : null,
                    decoration: _dec('Select type', enabled: isEditMode),
                  ),
                  SizedBox(height: 16.h),
                ],
              );
            });

          case "material":
            return Obx(() {
              // Try to get from API first, fallback to hardcoded options
              var list = controller.typeMaterialOption.value?.material ?? [];
              if (list.isEmpty) {
                list = fallbackMaterialOptions[typeName] ?? [];
              }

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
                    onChanged: isEditMode
                        ? (v) => setState(() => selectedMaterial = v)
                        : null,
                    decoration: _dec('Select material', enabled: isEditMode),
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
                  controller: controller.brandController,
                  hintText: 'Brand',
                  isReadable: isEditMode,
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
                  controller: controller.pipeMaterialController,
                  hintText: 'PEX, PVC, Copper',
                  isReadable: isEditMode,
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
                  controller: controller.shutoffLocationController,
                  hintText: 'Under sink, basement',
                  isReadable: isEditMode,
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
                  initialDate: lastServiceDate,
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
                  initialDate: lastFilledDate,
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
                  controller: controller.notesController,
                  hintText: 'Additional details',
                  isReadable: isEditMode,
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
      if (!isEditMode) return; // Only allow in edit mode

      final result = await FilePicker.platform.pickFiles();
      if (result != null) {
        _documentFile = File(result.files.single.path!);
        setState(() {});
      }
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBarBack(),
      body: Obx(() {
        if (controller.isLoading.value && !isDataFetched) {
          return Center(
            child: CustomProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            children: [
              // Title with Edit and Save buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$typeName Details', style: AppTypoGraphy.medium),

                  GestureDetector(
                    onTap: toggleEditModeAndSave,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Image.asset(
                        isEditMode
                            ? 'assets/icons/save_ic.png'
                            : 'assets/images/pen.png',
                        height: 24.h,
                        color: AppColors.black,
                      ),
                    ),
                  ),

                  // // Edit Button
                  // IconButton(
                  //   onPressed: toggleEditMode,
                  //   icon: Icon(
                  //     isEditMode ? Icons.cancel : Icons.edit,
                  //     color: isEditMode ? Colors.red : AppColors.primary,
                  //   ),
                  //   tooltip: isEditMode ? 'Cancel' : 'Edit',
                  // ),

                  // // Save Button
                  // IconButton(
                  //   onPressed: isEditMode ? onSave : null,
                  //   icon: Image.asset(
                  //     "assets/icons/save_ic.png",
                  //     color: isEditMode ? AppColors.primary : Colors.grey,
                  //   ),
                  //   tooltip: 'Save',
                  // ),
                ],
              ),

              SizedBox(height: 16.h),

              // Image Upload
              GestureDetector(
                onTap: isEditMode ? pickImage : null,
                child: Obx(() {
                  final imageUrl = controller.materialDetails.value?.image;

                  // Show uploaded image first
                  if (_imageFile != null) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Image.file(
                        _imageFile!,
                        height: 120.h,
                        width: 120.w,
                        fit: BoxFit.cover,
                      ),
                    );
                  }

                  // Show fetched image
                  if (imageUrl != null && imageUrl.isNotEmpty) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Image.network(
                        imageUrl,
                        height: 120.h,
                        width: 120.w,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildImagePlaceholder();
                        },
                      ),
                    );
                  }

                  // Show placeholder
                  return _buildImagePlaceholder();
                }),
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
                  if (isEditMode)
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

              Obx(() {
                final fetchedFiles =
                    controller.materialDetails.value?.files ?? [];
                final documents = [
                  // Fetched documents
                  ...fetchedFiles.map((file) => {
                        'title': file.file.split('/').last,
                        'path': file.file,
                        'iconPath': 'assets/images/document.png',
                        'date': file.uploadAt.toString().split(' ')[0],
                      }),
                  // Newly added document
                  if (_documentFile != null)
                    {
                      'title': _documentFile!.path.split('/').last,
                      'path': _documentFile!.path,
                      'iconPath': 'assets/images/document.png',
                      'date': '',
                    }
                ];

                return DocumentSlider(documents: documents);
              }),

              SizedBox(height: 40.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
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
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              isEditMode ? 'Take A Photo To Upload Image' : 'No Image',
              textAlign: TextAlign.center,
              style: AppTypoGraphy.regular.copyWith(fontSize: 14.sp),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Don't dispose controllers here as they're managed by GetX
    super.dispose();
  }
}
