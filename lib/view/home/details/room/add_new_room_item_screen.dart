import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart' show AppColors;
import 'package:home_cache/controller/room_controller.dart';
import 'package:home_cache/model/room_field_model.dart';
import 'package:home_cache/view/auth/signup/widgets/custom_elevated_button.dart';
import 'package:home_cache/view/home/account/productsupport/widgets/text_field_widget.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';

class AddNewRoomItemScreen extends StatefulWidget {
  const AddNewRoomItemScreen({super.key});

  @override
  State<AddNewRoomItemScreen> createState() => _AddNewRoomItemScreenState();
}

class _AddNewRoomItemScreenState extends State<AddNewRoomItemScreen> {
  final RoomController roomController = Get.find<RoomController>();

  // This Map replaces all static TextEditingControllers
  final Map<String, TextEditingController> _dynamicControllers = {};

  late String roomId;
  late String selectedItemId;
  late String itemName;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;

    // Map keys from your Debug Arguments log
    roomId = args?['selectedRoom'] ?? '';
    selectedItemId = args?['selectedItemId'] ?? '';
    itemName = args?['selectedTypeName'] ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      roomController.fetchRoomFields(itemName);
    });
  }

  @override
  void dispose() {
    _dynamicControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: source, imageQuality: 80);
    if (image != null) {
      roomController.selectedFile.value = File(image.path);
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
        // Format as YYYY-MM-DD
        _dynamicControllers[fieldKey]?.text =
            picked.toIso8601String().split('T')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBarBack(),
      body: SafeArea(
        child: Obx(() {
          if (roomController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final roomFieldData = roomController.roomFieldsData.value;
          if (roomFieldData == null) {
            return const Center(child: Text("No Data"));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageHeader(),
                SizedBox(height: 24.h),

                // Loops through API fields and builds the UI
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
    // Initialize a controller for this field if it doesn't exist yet
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
          value: _dynamicControllers[field.field]!.text.isEmpty
              ? null
              : _dynamicControllers[field.field]!.text,
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

  Widget _buildImageHeader() {
    return Center(
      child: GestureDetector(
        onTap: () => _showPickerOptions(),
        child: Obx(() => roomController.selectedFile.value == null
            ? _imagePlaceholder()
            : ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.file(roomController.selectedFile.value!,
                    height: 120.h, width: 120.w, fit: BoxFit.cover),
              )),
      ),
    );
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

  Widget _imagePlaceholder() {
    return Container(
      height: 120.h,
      width: 120.w,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.camera_alt, size: 32.h),
        Text('Pick Image',
            style: AppTypoGraphy.regular.copyWith(fontSize: 12.sp))
      ]),
    );
  }

  Widget _buildBottomBar() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: CustomElevatedButton(
          onTap: () {
            // COLLECT DYNAMIC DATA
            Map<String, dynamic> submissionData = {
              "room_id": roomId,
              "item_id": selectedItemId,
            };

            // Add all fields from the controllers map
            _dynamicControllers.forEach((key, controller) {
              submissionData[key] = controller.text;
            });

            roomController.addUserRoomItem(submissionData);
          },
          btnText: 'Save',
          height: 48.h,
        ),
      ),
    );
  }
}
