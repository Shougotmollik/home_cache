import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart' show AppColors;
import 'package:home_cache/controller/room_controller.dart';
import 'package:home_cache/model/user_room_item.dart';
import 'package:home_cache/model/room_field_model.dart'; // Ensure this is imported
import 'package:home_cache/view/auth/signup/widgets/custom_elevated_button.dart';
import 'package:home_cache/view/home/account/productsupport/widgets/text_field_widget.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';

class UpdateRoomItemScreen extends StatefulWidget {
  const UpdateRoomItemScreen({super.key});

  @override
  State<UpdateRoomItemScreen> createState() => _UpdateRoomItemScreenState();
}

class _UpdateRoomItemScreenState extends State<UpdateRoomItemScreen> {
  final RoomController roomController = Get.find<RoomController>();
  final Map<String, TextEditingController> _dynamicControllers = {};

  // late String itemId;
  late UserRoomItem itemData;
  late String selectedTypeName;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    selectedTypeName = args['name'] ?? '';
    itemData = args['item'];

    itemData.details.forEach((key, value) {
      _dynamicControllers[key] = TextEditingController(text: value);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      roomController.fetchRoomFields(selectedTypeName);
    });
  }

  @override
  void dispose() {
    _dynamicControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      roomController.selectedFile.value = File(picked.path);
    }
  }

  Future<void> _selectDate(BuildContext context, String fieldKey) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dynamicControllers[fieldKey]?.text =
            picked.toIso8601String().split('T')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBarBack(
          title: "Update $selectedTypeName", titleColor: AppColors.secondary),
      body: SafeArea(
        child: Obx(() {
          if (roomController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final roomFieldData = roomController.roomFieldsData.value;
          if (roomFieldData == null) {
            return const Center(child: Text("No Field Definitions Found"));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(),
                SizedBox(height: 24.h),

                // Dynamically build fields based on API definition
                ...roomFieldData.fields
                    .map((field) => _buildDynamicField(field))
                    .toList(),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildDynamicField(Field field) {
    // Ensure controller exists (if API returns a field not in the item details)
    if (!_dynamicControllers.containsKey(field.field)) {
      _dynamicControllers[field.field] = TextEditingController();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.field.replaceAll('_', ' ').capitalizeFirst!,
            style: AppTypoGraphy.semiBold.copyWith(color: AppColors.black),
          ),
          SizedBox(height: 6.h),
          if (field.type == 'select')
            _buildDropdown(field)
          else if (field.type == 'date')
            _buildDateField(field)
          else
            TextFieldWidget(
              controller: _dynamicControllers[field.field]!,
              hintText: 'Enter ${field.field.replaceAll('_', ' ')}',
            ),
        ],
      ),
    );
  }

  Widget _buildDropdown(Field field) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: field.values!.contains(_dynamicControllers[field.field]!.text)
              ? _dynamicControllers[field.field]!.text
              : null,
          hint: Text("Select ${field.field}"),
          items: field.values
              ?.map((val) => DropdownMenuItem(value: val, child: Text(val)))
              .toList(),
          onChanged: (val) =>
              setState(() => _dynamicControllers[field.field]!.text = val!),
        ),
      ),
    );
  }

  Widget _buildDateField(Field field) {
    return GestureDetector(
      onTap: () => _selectDate(context, field.field),
      child: AbsorbPointer(
        child: TextFieldWidget(
          controller: _dynamicControllers[field.field]!,
          hintText: 'Select Date',
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Center(
      child: GestureDetector(
        onTap: _showPickerOptions,
        child: Obx(() {
          bool hasNewFile = roomController.selectedFile.value != null;

          return Container(
            height: 120.h,
            width: 120.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: hasNewFile
                  ? Image.file(roomController.selectedFile.value!,
                      fit: BoxFit.cover)
                  : (itemData.image != null && itemData.image!.isNotEmpty)
                      ? Image.network(itemData.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _imagePlaceholder())
                      : _imagePlaceholder(),
            ),
          );
        }),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.camera_alt, size: 32.h),
      Text('Update Image',
          style: AppTypoGraphy.regular.copyWith(fontSize: 12.sp))
    ]);
  }

  void _showPickerOptions() {
    Get.bottomSheet(Container(
      color: Colors.white,
      child: Wrap(children: [
        ListTile(
            leading: Icon(Icons.photo),
            title: Text('Gallery'),
            onTap: () => {pickImage(ImageSource.gallery), Get.back()}),
        ListTile(
            leading: Icon(Icons.camera),
            title: Text('Camera'),
            onTap: () => {pickImage(ImageSource.camera), Get.back()}),
      ]),
    ));
  }

  Widget _buildBottomBar() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: CustomElevatedButton(
          onTap: () async {
            Map<String, dynamic> payload = {};
            _dynamicControllers.forEach((key, controller) {
              payload[key] = controller.text;
            });

            bool success =
                await roomController.updateUserRoomItem(payload, itemData.id);
            if (success) {
              Get.back(result: true);
            }
          },
          btnText: 'Update Item',
          height: 48.h,
        ),
      ),
    );
  }
}
