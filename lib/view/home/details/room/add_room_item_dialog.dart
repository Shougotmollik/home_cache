import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/colors.dart' show AppColors;
import 'package:home_cache/constants/data/rooms.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/controller/room_controller.dart';
import 'package:home_cache/view/auth/signup/widgets/custom_elevated_button.dart';
import 'package:home_cache/view/widget/custom_progress_indicator.dart';

import '../../../../config/route/route_names.dart';

class AddRoomItemDialog extends StatefulWidget {
  const AddRoomItemDialog(
      {super.key, required this.roomId, required this.typeId});

  final String roomId;
  final String typeId;

  @override
  State<AddRoomItemDialog> createState() => _AddRoomItemDialogState();
}

class _AddRoomItemDialogState extends State<AddRoomItemDialog> {
  // late String selectedRoom;
  late List<String> availableItems;
  late String selectedItem;
  late String selectedRoomId;
  String? selectedItemId;
  String? selectedItemName;

  final RoomController roomController = Get.find<RoomController>();

  @override
  void initState() {
    super.initState();
    // selectedRoom = rooms.isNotEmpty ? rooms[0].name : '';
    availableItems = rooms.isNotEmpty ? rooms[0].items : [];
    selectedItem = availableItems.isNotEmpty ? availableItems[0] : '';
    selectedRoomId = widget.roomId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      roomController.fetchAllRoom();
      roomController.fetchAvailableRoomItem(roomTypeId: widget.typeId);
      if (roomController.availableRoomItem.isNotEmpty) {
        final firstItem = roomController.availableRoomItem.first;
        setState(() {
          selectedItemId = firstItem.id;
          selectedItemName = firstItem.name;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text(
        'Add an item',
        style: AppTypoGraphy.bold.copyWith(color: AppColors.black),
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        height: 300.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 18.h),
            Text(
              'Type',
              style: AppTypoGraphy.regular.copyWith(color: AppColors.black),
              textAlign: TextAlign.start,
            ),
            Obx(
              () {
                if (roomController.isLoading.value) {
                  return const CustomProgressIndicator();
                }
                selectedItemId ??= roomController.availableRoomItem.first.id;
                selectedItemName ??=
                    roomController.availableRoomItem.first.name;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.lightgrey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: selectedItemId,
                    isExpanded: true,
                    underline: SizedBox(),
                    dropdownColor: Color(0xffA7B8BB),
                    icon: Icon(
                      CupertinoIcons.chevron_down,
                      color: AppColors.secondary,
                      size: 18.sp,
                    ),
                    items: roomController.availableRoomItem.map((value) {
                      return DropdownMenuItem(
                        value: value.id,
                        child: Text(
                          value.name,
                          style: TextStyle(color: AppColors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: (newId) {
                      final selected = roomController.availableRoomItem
                          .firstWhere((item) => item.id == newId);

                      setState(() {
                        selectedItemId = selected.id;
                        selectedItemName = selected.name;
                      });
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            Text(
              'Location',
              style: AppTypoGraphy.regular.copyWith(color: AppColors.black),
              textAlign: TextAlign.start,
            ),
            Obx(
              () {
                if (roomController.isLoading.value) {
                  return const Center(child: CustomProgressIndicator());
                }

                if (roomController.allRooms.isEmpty) {
                  return const Center(child: Text('No rooms found'));
                }

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.lightgrey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: selectedRoomId,
                    isExpanded: true,
                    dropdownColor: Color(0xffA7B8BB),
                    underline: SizedBox(),
                    icon: Icon(
                      CupertinoIcons.chevron_down,
                      color: AppColors.secondary,
                      size: 18.sp,
                    ),
                    items: roomController.allRooms.map((room) {
                      return DropdownMenuItem(
                        value: room.id,
                        child: Text(
                          room.name,
                          style: TextStyle(color: AppColors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: null,
                    // onChanged: (newValue) {
                    //   if (newValue != null) {
                    //     setState(() {
                    //       selectedRoomId = newValue;
                    //     });
                    //   }
                    // },
                  ),
                );
              },
            ),
            SizedBox(height: 70.h),
            Padding(
              padding: EdgeInsets.only(left: 80.w),
              child: CustomElevatedButton(
                onTap: () {
                  Get.toNamed(
                    RouteNames.addNewRoomIteam,
                    arguments: {
                      'selectedRoom': selectedRoomId,
                      'selectedItemId': selectedItemId,
                      "selectedTypeName": selectedItemName
                    },
                  );
                },
                btnText: 'Next',
                icon: Icons.arrow_forward,
              ),
            )
          ],
        ),
      ),
    );
  }
}
