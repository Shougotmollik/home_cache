import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:home_cache/config/route/route_names.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/controller/home_member_controller.dart';

class AssignedTaskTab extends StatefulWidget {
  const AssignedTaskTab({super.key});

  @override
  State<AssignedTaskTab> createState() => _AssignedTaskTabState();
}

class _AssignedTaskTabState extends State<AssignedTaskTab> {
  final HomeMemberController homeMemberController =
      Get.put(HomeMemberController());
  String? currentSelection;
  @override
  void initState() {
    super.initState();
    homeMemberController.getAssignedHomeMemberList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Assigned Tasks',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          // SizedBox(height: 8.h),
          // Text(
          //   'Tap a task to mark or assign',
          //   style: TextStyle(
          //     fontSize: 14.sp,
          //     color: Colors.grey[600],
          //   ),
          // ),
          SizedBox(height: 16.h),
          Obx(
            () {
              return Expanded(
                child: ListView.separated(
                  itemCount: homeMemberController.assignedHomeMemberList.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final task =
                        homeMemberController.assignedHomeMemberList[index];

                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteNames.taskDetails, arguments: {
                          'task_id': task.taskId,
                          'task_title': task.title
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Colors.grey[300]!,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.primary, width: 3.w)),
                              child: SvgPicture.asset(
                                'assets/icons/user.svg',
                                width: 24.w,
                                height: 24.w,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          task.title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 4.h,
                                          horizontal: 8.w,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.lightgrey,
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                        ),
                                        child: Text(
                                          task.status,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp,
                                              color: AppColors.primary),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    'Assigned to: ${task.memberName}',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
