import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/controller/room_controller.dart';
import 'package:home_cache/model/room_type.dart';
import 'package:home_cache/view/auth/signup/widgets/custom_elevated_button.dart';
import '../../../../config/route/route_names.dart';

class AddRoomDialog extends StatefulWidget {
  const AddRoomDialog({super.key});

  @override
  State<AddRoomDialog> createState() => _AddRoomDialogState();
}

class _AddRoomDialogState extends State<AddRoomDialog> {
  final TextEditingController nameController = TextEditingController();
  final RoomController roomController = Get.put(RoomController());

  RoomTypeModel? selectedRoom;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      roomController.fetchRoomType();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text(
        'Add a room',
        style: AppTypoGraphy.bold.copyWith(color: AppColors.black),
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        height: 300.h,
        child: Obx(() {
          if (roomController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (roomController.roomType.isEmpty) {
            return const Center(child: Text("No room types found"));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 18.h),
              Text('Type',
                  style:
                      AppTypoGraphy.regular.copyWith(color: AppColors.black)),

              // DROPDOWN
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightgrey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<dynamic>(
                  value: selectedRoom,
                  isExpanded: true,
                  underline: const SizedBox(),
                  dropdownColor: const Color(0xffA7B8BB),
                  icon: Icon(
                    CupertinoIcons.chevron_down,
                    color: AppColors.secondary,
                    size: 18.sp,
                  ),
                  items: roomController.roomType.map((room) {
                    return DropdownMenuItem<dynamic>(
                      value: room,
                      child: Text(
                        room.type,
                        style: const TextStyle(color: AppColors.black),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedRoom = newValue;
                      print('Selected room:============> ${newValue}');
                    });
                  },
                ),
              ),

              SizedBox(height: 16.h),
              Text('Name (optional)',
                  style:
                      AppTypoGraphy.regular.copyWith(color: AppColors.black)),
              SizedBox(height: 6.h),

              // NAME FIELD
              SizedBox(
                height: 48.h,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter room name',
                    hintStyle: TextStyle(color: AppColors.black.withAlpha(200)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                          color: Colors.grey.withAlpha(122), width: 1.w),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey, width: 1.5.w),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
              ),

              const Spacer(),

              // NEXT BUTTON centered
              Center(
                child: CustomElevatedButton(
                  onTap: () {
                    if (selectedRoom != null) {
                      Get.back();
                      Get.toNamed(
                        RouteNames.addRoom,
                        arguments: {
                          'id': selectedRoom!.id,
                          'type': selectedRoom!.type,
                          'name': nameController.text.trim(),
                        },
                      );
                    }
                  },
                  btnText: 'Next',
                  width: 100.w,
                  height: 42.h,
                  icon: Icons.arrow_forward,
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
