import 'dart:io';

import 'package:file_picker/file_picker.dart';
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
import 'package:intl/intl.dart';

class UpdateUtilitiesScreen extends StatefulWidget {
  const UpdateUtilitiesScreen({super.key});

  @override
  State<UpdateUtilitiesScreen> createState() => _UpdateUtilitiesScreenState();
}

class _UpdateUtilitiesScreenState extends State<UpdateUtilitiesScreen> {
  final UtilitiesController utilitiesController =
      Get.find<UtilitiesController>();

  File? _documentFile;
  DateTime? selectedLastServiceDate;

  final TextEditingController lastServiceController = TextEditingController();
  final TextEditingController noteTextController = TextEditingController();
  Rx<UtilityComponent?> selectedComponent = Rx<UtilityComponent?>(null);
  Rx<UtilityComponentType?> selectedComponentType =
      Rx<UtilityComponentType?>(null);

  // bool isLoadingUtility = true;
  String? existingImageUrl;
  List<dynamic> existingFiles = [];
  late final String utilityId;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    utilityId = args['id'];

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final data = await utilitiesController.getUtilitySingleDetails(utilityId);
      if (data != null) {
        existingImageUrl = data.image;
        existingFiles = data.files ?? [];
        noteTextController.text = data.details.notes ?? '';
        final lastService = data.details.lastService;
        if (lastService != null && lastService.isNotEmpty) {
          selectedLastServiceDate = DateFormat('MM/dd/yyyy').parse(lastService);
          lastServiceController.text = lastService;
        }
        final componentName = data.userUtility.utilityType.name;
        final comp = utilitiesController.utilityComponents
            .firstWhereOrNull((c) => c.name == componentName);
        if (comp != null) {
          selectedComponent.value = comp;

          await utilitiesController.getUtilityComponentTypes(comp.id);

          final typeId = data.utilityItemId;
          final type = utilitiesController.utilityComponentType
              .firstWhereOrNull((t) => t.id == typeId);
          if (type != null) selectedComponentType.value = type;
        }

        // setState(() {
        //   isLoadingUtility = false;
        // });
      }
    });
  }

  @override
  void dispose() {
    lastServiceController.dispose();
    noteTextController.dispose();
    super.dispose();
  }

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
              _buildHeader(),
              SizedBox(height: 16.h),
              _buildImageUpload(),
              SizedBox(height: 16.h),
              _buildComponentDropdown(),
              _buildComponentTypeDropdown(),
              _buildLastServiceField(),
              SizedBox(height: 16.h),
              _buildNotesField(),
              SizedBox(height: 20.h),
              _buildDocumentsSection(),
              SizedBox(height: 56.h),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------- HEADER --------------------
  Widget _buildHeader() {
    return Align(
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Utilities Details',
              style: AppTypoGraphy.medium.copyWith(color: AppColors.black)),
          SizedBox(width: 6.w),
          IconButton(
            onPressed: () async {
              if (selectedComponent.value == null ||
                  selectedComponentType.value == null) {
                // AppSnackbar.show(
                //   message: "Please select component and component type",
                //   type: SnackType.error,
                // );
                return;
              }

              var data = {
                "utility_item_id": selectedComponentType.value!.id,
                "details": {
                  "last_service": selectedLastServiceDate?.toIso8601String(),
                  "notes": noteTextController.text
                }
              };

              // TODO: Call updateUtility API here
              // await utilitiesController.updateUtility(utilityId, data);
            },
            icon: Image.asset("assets/icons/save_ic.png"),
          ),
        ],
      ),
    );
  }

  // -------------------- IMAGE UPLOAD --------------------
  Widget _buildImageUpload() {
    return Center(
      child: GestureDetector(
        onTap: () async {
          final picked =
              await ImagePicker().pickImage(source: ImageSource.camera);
          if (picked != null) {
            utilitiesController.selectedImageFile.value = File(picked.path);
          }
        },
        child: Obx(() {
          if (utilitiesController.selectedImageFile.value != null) {
            return _buildImageStack(
                File(utilitiesController.selectedImageFile.value!.path));
          } else if (existingImageUrl != null && existingImageUrl!.isNotEmpty) {
            return _buildNetworkImage(existingImageUrl!);
          } else {
            return _buildImagePlaceholder();
          }
        }),
      ),
    );
  }

  Widget _buildImageStack(File file) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Image.file(
            file,
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
              utilitiesController.selectedImageFile.value = null;
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(4.w),
              child: Icon(Icons.close, color: Colors.white, size: 16.sp),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNetworkImage(String url) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Image.network(
            url,
            height: 120.h,
            width: 120.w,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 120.h,
                width: 120.w,
                decoration: BoxDecoration(
                  color: AppColors.lightgrey,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return _buildImagePlaceholder();
            },
          ),
        ),
        Positioned(
          top: 8.h,
          right: 8.w,
          child: GestureDetector(
            onTap: () async {
              final picked =
                  await ImagePicker().pickImage(source: ImageSource.camera);
              if (picked != null) {
                utilitiesController.selectedImageFile.value = File(picked.path);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(4.w),
              child: Icon(Icons.edit, color: Colors.white, size: 16.sp),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
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
            offset: const Offset(0, 4),
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
            style: AppTypoGraphy.regular
                .copyWith(color: AppColors.black, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  // -------------------- COMPONENT DROPDOWN --------------------
  Widget _buildComponentDropdown() {
    return Obx(() {
      final list = utilitiesController.utilityComponents;

      if (list.isEmpty) return const Text('No components found');

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Component', style: AppTypoGraphy.semiBold),
          SizedBox(height: 6.h),
          DropdownButtonFormField<UtilityComponent>(
            value: selectedComponent.value,
            items: list
                .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              selectedComponent.value = value;
              selectedComponentType.value = null;
              utilitiesController.getUtilityComponentTypes(value.id);
            },
            decoration: _dec('Select Component'),
          ),
          SizedBox(height: 16.h),
        ],
      );
    });
  }

  // -------------------- COMPONENT TYPE DROPDOWN --------------------
  Widget _buildComponentTypeDropdown() {
    return Obx(() {
      final list = utilitiesController.utilityComponentType;

      if (selectedComponent.value == null) {
        return _buildDisabledDropdown('Select component first');
      }

      if (list.isEmpty) {
        return _buildDisabledDropdown(
            'No types available for selected component');
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Component Type', style: AppTypoGraphy.semiBold),
          SizedBox(height: 6.h),
          DropdownButtonFormField<UtilityComponentType>(
            value: selectedComponentType.value,
            items: list
                .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                .toList(),
            onChanged: (value) => selectedComponentType.value = value,
            decoration: _dec('Select Component Type'),
          ),
          SizedBox(height: 16.h),
        ],
      );
    });
  }

  Widget _buildDisabledDropdown(String message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Component Type', style: AppTypoGraphy.semiBold),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.lightgrey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(message,
              style: AppTypoGraphy.regular
                  .copyWith(color: AppColors.grey, fontSize: 14.sp)),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  // -------------------- LAST SERVICE --------------------
  Widget _buildLastServiceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Last Service Date',
            style: AppTypoGraphy.semiBold.copyWith(color: AppColors.black)),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedLastServiceDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );

            if (pickedDate != null) {
              selectedLastServiceDate = pickedDate;
              lastServiceController.text =
                  DateFormat('MM/dd/yyyy').format(pickedDate);
            }
          },
          child: AbsorbPointer(
            child: TextFieldWidget(
                controller: lastServiceController,
                hintText: 'Enter Last Service Date'),
          ),
        ),
      ],
    );
  }

  // -------------------- NOTES --------------------
  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Notes',
            style: AppTypoGraphy.semiBold.copyWith(color: AppColors.black)),
        TextFieldWidget(
            hintText: 'Additional details about the utility',
            controller: noteTextController),
      ],
    );
  }

  // -------------------- DOCUMENTS --------------------
  Widget _buildDocumentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Documents',
                style: AppTypoGraphy.semiBold.copyWith(color: AppColors.black)),
            SizedBox(width: 6.w),
            Container(
              height: 24.h,
              width: 24.h,
              decoration: BoxDecoration(
                  color: AppColors.primary, shape: BoxShape.circle),
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
        DocumentSlider(
          documents: [
            ...existingFiles.map((file) => {
                  'title': file['name'] ?? file['title'] ?? 'Document',
                  'path': file['url'] ?? file['path'] ?? '',
                  'iconPath': 'assets/images/document.png',
                  'date': file['created_at'] ?? file['date'] ?? '',
                }),
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
    );
  }

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
