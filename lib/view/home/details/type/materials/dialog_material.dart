import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/controller/material_controller.dart';
import 'package:home_cache/controller/room_controller.dart';
import 'package:home_cache/view/widget/custom_progress_indicator.dart';
import 'package:home_cache/view/widget/text_button_widget.dart';
import '../../../../../config/route/route_names.dart';

class DialogMaterial extends StatelessWidget {
  DialogMaterial({super.key, required this.materialTypeId});

  final String materialTypeId;

  // Controllers
  final MaterialController materialController = Get.put(MaterialController());
  final RoomController roomController = Get.put(RoomController());

  // Reactive selected IDs
  final RxString selectedTypeId = ''.obs;
  final RxString selectedRoomId = ''.obs;

  // Delay fetching after first frame to avoid build issues
  void fetchAppliances() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Appliance Type ID in Dialog: $materialTypeId');
      materialController.getMaterialTypes(materialTypeId);
      roomController.fetchAllRoom();
    });
  }

  @override
  Widget build(BuildContext context) {
    fetchAppliances();
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text(
        'Add A Material',
        style: AppTypoGraphy.bold.copyWith(color: AppColors.black),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 18.h),
              Text(
                'Name',
                style: AppTypoGraphy.regular.copyWith(color: AppColors.black),
              ),
              SizedBox(height: 6.h),
              Obx(() {
                if (materialController.materialTypeList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Set default value if empty
                selectedTypeId.value = selectedTypeId.value.isEmpty
                    ? materialController.materialTypeList.first.id
                    : selectedTypeId.value;

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.lightgrey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: selectedTypeId.value,
                    isExpanded: true,
                    underline: const SizedBox(),
                    icon: Icon(
                      CupertinoIcons.chevron_down,
                      color: AppColors.secondary,
                      size: 18.sp,
                    ),
                    items: materialController.materialTypeList.map((value) {
                      return DropdownMenuItem<String>(
                        value: value.id, // Use ID
                        child: Text(value.name,
                            style: const TextStyle(color: AppColors.black)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) selectedTypeId.value = newValue;
                    },
                  ),
                );
              }),
              SizedBox(height: 16.h),
              Text(
                'Location',
                style: AppTypoGraphy.regular.copyWith(color: AppColors.black),
              ),
              SizedBox(height: 6.h),
              Obx(() {
                if (roomController.isLoading.value) {
                  return const Center(
                      child: SizedBox(
                          height: 40,
                          width: 30,
                          child: CustomProgressIndicator()));
                }

                if (roomController.allRooms.isEmpty) {
                  return const Center(child: Text('No rooms found'));
                }

                // Set default value if empty
                selectedRoomId.value = selectedRoomId.value.isEmpty
                    ? roomController.allRooms.first.id
                    : selectedRoomId.value;

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.lightgrey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: selectedRoomId.value,
                    isExpanded: true,
                    underline: const SizedBox(),
                    icon: Icon(
                      CupertinoIcons.chevron_down,
                      color: AppColors.secondary,
                      size: 18.sp,
                    ),
                    items: roomController.allRooms.map((value) {
                      return DropdownMenuItem<String>(
                        value: value.id, // Use ID
                        child: Text(value.name,
                            style: const TextStyle(color: AppColors.black)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) selectedRoomId.value = newValue;
                    },
                  ),
                );
              }),
              // const Spacer(),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: TextWidgetButton(
                  text: '→  Next',
                  onPressed: () {
                    // if (selectedTypeId.value.isEmpty ||
                    //     selectedRoomId.value.isEmpty) {
                    //   Get.snackbar('Error', 'Please select type and location');
                    //   return;
                    // }

                    Get.toNamed(
                      RouteNames.addMaterial,
                      arguments: {
                        'material_id': selectedTypeId.value,
                        'view_type_id': materialTypeId,
                        'room_id': selectedRoomId.value,
                        'type_name': materialController.materialTypeList
                            .firstWhere(
                                (type) => type.id == selectedTypeId.value)
                            .name,
                        'room_name': roomController.allRooms
                            .firstWhere(
                                (room) => room.id == selectedRoomId.value)
                            .name
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
