import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/controller/room_controller.dart';
import 'package:home_cache/view/home/details/room/add_room_dialog.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';
import 'package:home_cache/view/widget/custom_progress_indicator.dart';
import '../../../../config/route/route_names.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  int selectedIndex = -1;

  final RoomController roomController = Get.put(RoomController());

  @override
  void initState() {
    super.initState();
    roomController.fetchAllRoom();
  }

  Widget _buildTile(
    BuildContext context,
    String title,
    String imageUrl,
    int index,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        onTap();
      },
      child: Container(
        margin: EdgeInsets.all(8.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.lightgrey,
          border: Border.all(
            color: selectedIndex == index
                ? AppColors.primary
                : AppColors.lightgrey,
            width: selectedIndex == index ? 2.w : 1.w,
          ),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withAlpha(60),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    height: 50.h,
                    width: 62.w,
                    fit: BoxFit.contain,
                  )
                : Icon(Icons.meeting_room, size: 52.h, color: AppColors.black),
            SizedBox(height: 12.h),
            Text(
              title,
              style: AppTypoGraphy.medium.copyWith(
                color: AppColors.black,
                fontSize: 16.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(
        title: 'View By Room',
        titleColor: AppColors.secondary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const AddRoomDialog(),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
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
      body: SafeArea(
        child: Obx(
          () {
            if (roomController.isLoading.value) {
              return const Center(child: CustomProgressIndicator());
            }

            if (roomController.allRooms.isEmpty) {
              return Center(
                  child: Text(
                "No rooms you added yet",
                style: AppTypoGraphy.semiBold,
              ));
            }

            return GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.h,
                crossAxisSpacing: 8.w,
                childAspectRatio: 1,
              ),
              itemCount: roomController.allRooms.length,
              itemBuilder: (context, index) {
                final room = roomController.allRooms[index];
                return _buildTile(
                  context,
                  room.roomName,
                  room.type.image,
                  index,
                  () {
                    Get.toNamed(
                      RouteNames.editRoomDetails,
                      arguments: {
                        'roomName': room.roomName,
                        'roomType': room.type.type,
                        'roomId': room.id,
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
