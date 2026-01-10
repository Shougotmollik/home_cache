import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/controller/room_controller.dart';
import 'package:home_cache/view/widget/custom_progress_indicator.dart';
import 'package:home_cache/view/widget/text_button_widget.dart';
import '../../../../../config/route/route_names.dart';

class PaintDialog extends StatelessWidget {
  PaintDialog({
    super.key,
    required this.selectedItemId,
  });

  // Controllers
  final RoomController roomController = Get.put(RoomController());

  // Reactive selected IDs
  final String? selectedItemId;
  final RxString selectedRoomId = ''.obs;

  // Delay fetching after first frame to avoid build issues
  void fetchAppliances() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
        'Add A Paint',
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
                'Type',
                style: AppTypoGraphy.regular.copyWith(color: AppColors.black),
              ),
              SizedBox(height: 6.h),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.lightgrey, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Paint',
                    style: TextStyle(
                        color: AppColors.black, fontWeight: FontWeight.w500),
                  )),
              SizedBox(height: 16.h),
              Text(
                'Location',
                style: AppTypoGraphy.regular.copyWith(color: AppColors.black),
              ),
              SizedBox(height: 6.h),
              Obx(() {
                if (roomController.isLoading.value) {
                  return Center(
                      child: SizedBox(
                          height: 42.h, child: CustomProgressIndicator()));
                }
                if (roomController.allRooms.isEmpty) {
                  return const Center(child: Text("There is no room"));
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
                        value: value.id,
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
                    Get.toNamed(
                      RouteNames.addPaintItemScreen,
                      arguments: {
                        'room_id': selectedRoomId.value,
                        'item_id': selectedItemId
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
