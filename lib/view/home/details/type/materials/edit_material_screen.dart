import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/controller/material_controller.dart';
import 'package:home_cache/utils.dart' as utils;
import 'package:home_cache/view/home/details/widgets/doccument_slider.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';
import 'package:image_picker/image_picker.dart';

class EditMaterialScreen extends StatefulWidget {
  const EditMaterialScreen({super.key});

  @override
  State<EditMaterialScreen> createState() => _EditMaterialScreenState();
}

class _EditMaterialScreenState extends State<EditMaterialScreen> {
  final MaterialController controller = Get.put(MaterialController());

  File? _newImageFile;
  File? _newDocumentFile;

  String? selectedType;
  String? selectedMaterial;

  late String materialDetailsId;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments as Map<String, dynamic>;
    materialDetailsId = args['id'];
    print("material id ======>$materialDetailsId");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getMaterialDetails(materialDetailsId);
    });
  }

  // ================= IMAGE PICK =================
  Future<void> pickFromCamera() async {
    final file = await utils.pickSingleImage(
      context: context,
      source: ImageSource.camera,
    );

    if (file != null) {
      setState(() => _newImageFile = file);
      controller.selectedImageFile.value = file;
    }
  }

  // ================= FILE PICK =================
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null) {
      final file = File(result.files.single.path!);
      setState(() => _newDocumentFile = file);
      controller.selectedFile.value = file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBarBack(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.materialDetails.value;
        if (data == null) {
          return const Center(child: Text("No data found"));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
  
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Edit ${data.userMaterial.material.name}',
                      style:
                          AppTypoGraphy.medium.copyWith(color: AppColors.black),
                    ),
                    IconButton(
                      onPressed: () {
                        final payload = {
                          "details": {
                            "notes": controller.notesController.text.trim(),
                            "type": selectedType,
                            "material": selectedMaterial,
                          }
                        };

                        // controller.updateMaterial(
                        //   materialDetailsId,
                        //   payload,
                        // );
                      },
                      icon: Image.asset("assets/icons/save_ic.png"),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // ================= IMAGE =================
              Center(
                child: GestureDetector(
                  onTap: pickFromCamera,
                  child: _buildImage(data.image),
                ),
              ),

              SizedBox(height: 20.h),

              // ================= NOTES =================
              Text(
                'Notes',
                style: AppTypoGraphy.semiBold.copyWith(color: AppColors.black),
              ),
              SizedBox(height: 6.h),
              TextField(
                controller: controller.notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.lightgrey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // ================= TYPE =================
              _dropdownSection(
                title: 'Type',
                value: selectedType,
                items: controller.typeMaterialOption.value?.type ?? [],
                onChanged: (v) => setState(() => selectedType = v),
              ),

              // ================= MATERIAL =================
              _dropdownSection(
                title: 'Material',
                value: selectedMaterial,
                items: controller.typeMaterialOption.value?.material ?? [],
                onChanged: (v) => setState(() => selectedMaterial = v),
              ),

              SizedBox(height: 16.h),

              // ================= DOCUMENTS =================
              Row(
                children: [
                  Text(
                    'Documents',
                    style:
                        AppTypoGraphy.semiBold.copyWith(color: AppColors.black),
                  ),
                  IconButton(
                    onPressed: pickFile,
                    icon: Icon(Icons.add, color: AppColors.primary),
                  ),
                ],
              ),

              DocumentSlider(
                documents: [
                  ...data.files.map(
                    (e) => {
                      'title': e.fileId.split('/').last,
                      'path': e.file,
                      'iconPath': 'assets/images/document.png',
                      'date': e.uploadAt.toString(),
                    },
                  ),
                  if (_newDocumentFile != null)
                    {
                      'title': _newDocumentFile!.path.split('/').last,
                      'path': _newDocumentFile!.path,
                      'iconPath': 'assets/images/document.png',
                      'date': '',
                    }
                ],
              ),

              SizedBox(height: 32.h),
            ],
          ),
        );
      }),
    );
  }

  // ================= IMAGE BUILDER =================
  Widget _buildImage(String imageUrl) {
    if (_newImageFile != null) {
      return _imagePreview(Image.file(_newImageFile!));
    }

    if (imageUrl.isNotEmpty) {
      return _imagePreview(
        Image.network(imageUrl, fit: BoxFit.cover),
      );
    }

    return _emptyImageBox();
  }

  Widget _imagePreview(Widget image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: SizedBox(
        height: 120.h,
        width: 120.w,
        child: image,
      ),
    );
  }

  Widget _emptyImageBox() {
    return Container(
      height: 120.h,
      width: 120.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: const Icon(Icons.camera_alt),
    );
  }

  Widget _dropdownSection({
    required String title,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: AppTypoGraphy.semiBold.copyWith(color: AppColors.black)),
        SizedBox(height: 6.h),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map(
                (e) => DropdownMenuItem(value: e, child: Text(e)),
              )
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.lightgrey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
