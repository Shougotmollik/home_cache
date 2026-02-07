import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/config/route/route_names.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/controller/notification_controller.dart';
import 'package:home_cache/view/home/notification/widgets/notification_app_bar.dart';
import 'package:home_cache/view/home/notification/widgets/notification_tile.dart';
import 'package:home_cache/view/widget/text_button_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController notificationController =
        Get.put(NotificationController());
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: NotificationAppBar(),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                  color: AppColors.lightgrey.withAlpha(122),
                  borderRadius: BorderRadius.circular(16.r)),
              child: Obx(
                () => ListView.separated(
                  padding: EdgeInsets.only(bottom: 125.h),
                  itemBuilder: (context, index) {
                    final notification =
                        notificationController.taskNotificationList[index];
                    return NotificationTile(
                      title: notification.title,
                      description: notification.description,
                      onMarkDone: () async {
                        var data = {
                          "task_assign_id": notification.taskAssignId,
                          "task_id": notification.taskId,
                          "task_status": "completed"
                        };
                        await notificationController.markAsDone(data);
                      },
                      onDismiss: () async {
                        var data = {
                          "task_assign_id": notification.taskAssignId,
                          "task_id": notification.taskId,
                          "task_status": "ignored"
                        };
                        await notificationController.markAsDone(data);
                      },
                      onTap: () {
                        Get.toNamed(
                          RouteNames.taskDetails,
                          arguments: {
                            'task_id': notification.taskId,
                            'task_title': notification.title
                          },
                        );
                      },
                    );
                  },
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemCount: notificationController.taskNotificationList.length,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Positioned(
            bottom: 12.h,
            left: 0,
            right: 0,
            child: _buildNotificationFooterSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationFooterSection() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10.h),
          Text(
            'Looking For Older Tasks?',
            style: AppTypoGraphy.bold.copyWith(
              color: AppColors.black,
              fontSize: 24.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.w),
            child: TextWidgetButton(
              text: 'View Home Health Dash',
              onPressed: () {
                Get.back();
              },
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
