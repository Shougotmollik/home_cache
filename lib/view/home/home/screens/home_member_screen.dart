import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/controller/task_controller.dart';
import 'package:home_cache/controller/user_controller.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';
import 'package:home_cache/view/widget/custom_progress_indicator.dart';

class HomeMemberScreen extends StatefulWidget {
  const HomeMemberScreen({super.key});

  @override
  State<HomeMemberScreen> createState() => _HomeMemberScreenState();
}

class _HomeMemberScreenState extends State<HomeMemberScreen> {
  final UserController userController = Get.find<UserController>();
  final TaskController taskController = Get.find<TaskController>();

  late final String taskId;
  late final String taskTitle;
  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    taskId = args['task_id'];
    taskTitle = args['task_title'];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userController.getHomeMemberData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(
        title: taskTitle,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Assignee',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24.sp,
                color: AppColors.text,
              ),
            ),
            Text('Who do you want to assign this task to?',
                style: AppTypoGraphy.regular),
            Obx(
              () {
                if (userController.isLoading.value) {
                  return const Center(child: CustomProgressIndicator());
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: userController.homeMemberList.length,
                    itemBuilder: (context, index) {
                      final member = userController.homeMemberList[index];
                      return ListTile(
                        onTap: () {
                          var data = {
                            "task_id": taskId,
                            "assign_to": member.id,
                          };
                          taskController.assignNewMember(data);
                          taskController.fetchTaskDetails(taskId);
                          Get.back();
                        },
                        leading: SvgPicture.asset(
                          'assets/icons/account.svg',
                          width: 32.w,
                          height: 32.h,
                          color: AppColors.black,
                        ),
                        title: Text(
                          "${member.profile.firstName} ${member.profile.lastName}",
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black),
                        ),
                        subtitle: Text(
                          "House ${userController.homeMemberList[index].homeData.homeRole}",
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
