import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:home_cache/config/route/route_names.dart';
import 'package:home_cache/constants/colors.dart' show AppColors;
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/controller/room_controller.dart';
import 'package:home_cache/utils.dart' as utils;
import 'package:home_cache/view/home/details/room/add_room_item_dialog.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';
import 'package:home_cache/view/widget/custom_progress_indicator.dart';
import 'package:image_picker/image_picker.dart';

class EditRoomDetailsScreen extends StatefulWidget {
  const EditRoomDetailsScreen({super.key});

  @override
  State<EditRoomDetailsScreen> createState() => _EditRoomDetailsScreenState();
}

class _EditRoomDetailsScreenState extends State<EditRoomDetailsScreen> {
  int selectedCategoryIndex = 0;
  File? _selectedImage;
  final RoomController roomController = Get.put(RoomController());
  late String selectedItemId;

  void selectCategory(int index) {
    setState(() {
      selectedCategoryIndex = index;
    });

    final room = roomController.roomDetails.value;

    print("Room: =====>>.$room");

    if (room != null && room.items.isNotEmpty) {
      final itemId = room.items[index].userItemId;

      if (itemId != null && itemId.isNotEmpty) {
        selectedItemId = itemId;

        print("Selected Item ID: $selectedItemId");
        roomController.fetchUserRoomItems(itemId);
      }
    }
  }

  late String roomId;
  late String roomName;
  late String typeId;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments as Map<String, dynamic>?;
    roomId = args?['roomId'] ?? '';
    roomName = args?['roomName'] ?? 'Room';
    typeId = args?['typeId'] ?? '';

    print("Room ID:=========> $roomId");
    print("Room Name: =========>$roomName");
    print("Type ID:===========> $typeId");

    if (roomId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await roomController.fetchRoomDetails(roomId);

        final room = roomController.roomDetails.value;

        if (room != null && room.items.isNotEmpty) {
          selectedItemId = room.items[0].userItemId ?? "";
          if (selectedItemId.isNotEmpty) {
            roomController.fetchUserRoomItems(selectedItemId);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(
        title: roomName,
        titleColor: AppColors.secondary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {
                // Get.toNamed(RouteNames.addNewRoomIteam, arguments: {
                //   'id': roomController.roomDetails.value?.id,
                //   'roomName': roomName,
                //   'selectedItemId': roomController
                //       .roomDetails.value?.items[selectedCategoryIndex].id,
                // });

                showDialog(
                    context: context,
                    builder: (context) => AddRoomItemDialog(
                          roomId: roomId,
                          typeId: typeId,
                        ));
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                '+ Add',
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.surface,
      body: Padding(
        padding: EdgeInsets.all(24.sp),
        child: Obx(() {
          if (roomController.isLoading.value) {
            return const Center(child: CustomProgressIndicator());
          }

          final room = roomController.roomDetails.value;
          if (room == null) {
            return const Center(child: Text("No room details found"));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Room Image
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final image = await utils.pickSingleImage(
                            context: context, source: ImageSource.gallery);
                        setState(() {
                          _selectedImage = image;
                        });
                      },
                      child: Container(
                          width: 320.w,
                          height: 165.w,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(28.r),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: _selectedImage != null
                                ? Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Image.file(
                                        _selectedImage!,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedImage = null;
                                          });
                                        },
                                        child: Container(
                                          width: 20.w,
                                          height: 20.w,
                                          margin: EdgeInsets.only(
                                              top: 4.w, right: 4.w),
                                          decoration: BoxDecoration(
                                            color: Colors.red[400],
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.close,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : (room.image != null && room.image!.isNotEmpty)
                                    ? Image.network(
                                        room.image!,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Center(
                                            child: SvgPicture.asset(
                                              'assets/icons/gallery.svg',
                                              width: 72.w,
                                            ),
                                          );
                                        },
                                      )
                                    : Center(
                                        child: SvgPicture.asset(
                                          'assets/icons/gallery.svg',
                                          width: 72.w,
                                        ),
                                      ),
                          )),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // Category Chips (room items)
                if (room.items.isNotEmpty)
                  Center(
                    child: Wrap(
                      spacing: 18.w,
                      runSpacing: 18.h,
                      children: List.generate(room.items.length, (index) {
                        final isSelected = selectedCategoryIndex == index;
                        return ElevatedButton(
                          onPressed: () => selectCategory(index),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? Color(0xff8CA8AC)
                                : AppColors.lightgrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                          ),
                          child: Text(
                            room.items[index].item,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 12.sp,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                SizedBox(height: 20.h),

                Text(
                  'View All',
                  style: AppTypoGraphy.medium.copyWith(color: AppColors.black),
                ),
                SizedBox(height: 20.h),
                // _buildRoomItemCard(),

                Obx(
                  () => roomController.userRoomItems.isEmpty
                      ? const Center(child: Text('No room items found'))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: roomController.userRoomItems.map((item) {
                            final String cardTitle =
                                item.details['location']?.toString() ??
                                    item.details['room']?.toString() ??
                                    'N/A';

                            final String cardSubTitle =
                                item.details['brand']?.toString() ??
                                    item.details['material']?.toString() ??
                                    item.details['type']?.toString() ??
                                    'N/A';

                            return Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: _buildRoomItemCard(
                                title: cardTitle,
                                subTitle: cardSubTitle,
                                onTap: () {
                                  final selectedIndexText = roomController
                                      .roomDetails
                                      .value!
                                      .items[selectedCategoryIndex]
                                      .item;

                                  Get.toNamed(
                                    RouteNames.updateRoomItem,
                                    arguments: {
                                      "name": selectedIndexText,
                                      "item": item,
                                    },
                                  )?.then((result) {
                                    if (result == true) {
                                      roomController
                                          .fetchUserRoomItems(selectedItemId);
                                    }
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRoomItemCard({
    required String title,
    required String subTitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.all(20.r),
          height: 100.h,
          width: double.infinity,
          decoration: BoxDecoration(
              color: AppColors.lightgrey,
              borderRadius: BorderRadius.circular(12.r)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    subTitle,
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.edit))
            ],
          )),
    );
  }
}
