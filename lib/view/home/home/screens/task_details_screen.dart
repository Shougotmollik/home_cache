import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:home_cache/config/route/route_names.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/controller/task_controller.dart';
import 'package:home_cache/controller/user_controller.dart';
import 'package:home_cache/model/task_details_model.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';
import 'package:home_cache/view/widget/custom_progress_indicator.dart';
import 'package:intl/intl.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final TaskController taskController = Get.put(TaskController());
  final UserController userController = Get.find<UserController>();
  late final String taskId;
  late final String taskTitle;

  @override
  void initState() {
    final arg = Get.arguments as Map<String, dynamic>;
    taskId = arg['task_id'];
    taskTitle = arg['task_title'];
    print("Task ID:=========>>>> $taskId");
    print("Task Title:=========>>>> $taskTitle");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      taskController.fetchTaskDetails(taskId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(
        title: taskTitle,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
        child: Obx(
          () {
            final taskDetails = taskController.taskDetails.value;
            if (taskDetails == null) {
              return const Center(child: CustomProgressIndicator());
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Schedule",
                        style: AppTypoGraphy.bold
                            .copyWith(color: AppColors.black)),
                    (taskDetails.presentAssignTo?.assignee.userType ==
                                    'provider' &&
                                userController.userDataList.first.id ==
                                    taskDetails.taskData.createdBy) ||
                            (taskDetails.presentAssignTo?.assignee.userType ==
                                    'user' &&
                                userController.userDataList.first.id ==
                                    taskDetails
                                        .presentAssignTo?.assignee.assigneeId)
                        ? GestureDetector(
                            onTap: () {
                              var data = {
                                "task_assign_id":
                                    taskDetails.presentAssignTo?.taskAssignId,
                                "task_id": taskDetails.taskData.id,
                                "task_status": "completed"
                              };
                              taskController.markTaskComplete(data);
                            },
                            child: Container(
                              height: 40.h,
                              width: 40.h,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(Icons.check,
                                    color: Colors.white, size: 20.sp),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (taskDetails.presentAssignTo?.date == null &&
                        taskDetails.taskData.initialDate == null)
                      Text(
                        'No schedule currently linked.',
                        style: AppTypoGraphy.regular,
                      )
                    else
                      Text(
                        "Date: ${DateFormat("MMM dd, yyyy").format(
                          taskDetails.presentAssignTo?.date ??
                              taskDetails.taskData.initialDate,
                        )}",
                        style: AppTypoGraphy.regular,
                      ),
                  ],
                ),
                SizedBox(
                  height: 32.h,
                ),
                _buildQuickActions(taskDetails),
                SizedBox(height: 48.h),
                Text('Details', style: AppTypoGraphy.bold),
                SizedBox(height: 18.h),
                Text('Last Service On', style: AppTypoGraphy.regular),
                SizedBox(height: 8.h),
                Text(
                  taskDetails.lastServiceBy != null
                      ? DateFormat("MMM dd, yyyy")
                          .format(taskDetails.lastServiceBy!.date)
                      : "No Service Data Found",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: 20.h),
                Text('Last Service By', style: AppTypoGraphy.regular),
                SizedBox(height: 8.h),
                if (taskDetails.lastServiceBy == null)
                  const Center(child: Text("No data found"))
                else if (taskDetails.lastServiceBy?.userType == 'provider')
                  _buildProviderServiceCard(taskDetails)
                else
                  _buildHouseMemberServiceCard(taskDetails),
                SizedBox(height: 12.h),
                Row(
                  spacing: 8.w,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/account.svg',
                      width: 18.w,
                      height: 18.h,
                      color: AppColors.primary,
                    ),
                    Text('Assigned To', style: AppTypoGraphy.regular),
                  ],
                ),
                Divider(color: AppColors.black, thickness: 1.h, height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          taskDetails.presentAssignTo?.assignee.name ?? "N/A",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                        Text(
                          taskDetails.presentAssignTo?.assignee.userRole ??
                              "N/A",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    taskController.taskDetails.value?.taskData.createdBy ==
                            userController.userDataList.first.id
                        ? IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.mode_edit_outlined,
                              color: AppColors.primary,
                            ))
                        : SizedBox()
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProviderServiceCard(TaskDetailsModel taskDetails) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteNames.providerDetails,
            arguments: taskDetails.lastServiceBy!.userId);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        taskDetails.lastServiceBy!.name,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < taskDetails.lastServiceBy!.avgRating!
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: AppColors.primaryLight,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    taskDetails.lastServiceBy!.userRole,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black38,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Done: ${DateFormat("dd-MM-yyyy").format(taskDetails.lastServiceBy!.date)}",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 6.w),

            // RIGHT INFO BOX
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.black,
                    size: 24.sp,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Info',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHouseMemberServiceCard(TaskDetailsModel taskDetails) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 4.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.lightgrey,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(taskDetails.lastServiceBy!.name,
                style: AppTypoGraphy.semiBold),
            Text(
              "House ${taskDetails.lastServiceBy!.userRole}",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black38,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              "Done: ${DateFormat("dd-MM-yyyy").format(taskDetails.lastServiceBy!.date)}",
              style: AppTypoGraphy.regular,
            )
          ],
        ));
  }

  Widget _buildQuickActions(TaskDetailsModel taskDetails) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _quickActionTile(
          title: "Link Meeting",
          asset: "assets/images/link.png",
          onTap: () {},
        ),
        _quickActionTile(
          title: "Schedule Now",
          asset: "assets/images/calender.png",
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime(DateTime.now().year + 5),
            );
            if (pickedDate != null) {
              print("Picked Date: =======>${pickedDate.toIso8601String()}");

              await taskController.changeScheduleDate(
                  taskDetails.taskData.id, pickedDate.toIso8601String());

              await taskController.fetchTaskDetails(taskDetails.taskData.id);
            }
          },
        ),
      ],
    );
  }

  Widget _quickActionTile({
    required String title,
    required String asset,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 128.w,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.lightgrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Image.asset(asset, height: 48.h, fit: BoxFit.contain),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.black.withAlpha(200),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
