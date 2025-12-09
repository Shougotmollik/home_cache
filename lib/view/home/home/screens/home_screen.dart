import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/controller/home_controller.dart';
import 'package:home_cache/controller/task_controller.dart';
import 'package:home_cache/view/home/home/widgets/home_health_pie_chart.dart';
import 'package:home_cache/view/widget/custom_progress_indicator.dart';
import 'package:home_cache/view/widget/task_list_tile.dart';
import 'package:intl/intl.dart';

import '../../../../config/route/route_names.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskController _taskController = Get.find<TaskController>();
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.lightgrey.withAlpha(200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(120),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  GestureDetector(
                      onTap: () => Get.toNamed(RouteNames.homeHealth),
                      child: Obx(() {
                        return HomeHealthPieChart(
                          completedValue: homeController
                                  .homeHealthData.value?.completedTasks ??
                              0,
                          remainingValue: 100 -
                              (homeController
                                      .homeHealthData.value?.completedTasks ??
                                  0),
                        );
                      })),
                  _buildHealthTitleSection(
                    completedTasks:
                        homeController.homeHealthData.value?.completedTasks ??
                            0,
                    totalTasks:
                        homeController.homeHealthData.value?.totalTasks ?? 0,
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),

            // Tasks Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Tasks',
                      style: AppTypoGraphy.medium.copyWith(
                        color: AppColors.black,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Toggle Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _taskController.selectOption(0),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _taskController.selectedIndex.value == 0
                                      ? AppColors.primary
                                      : AppColors.lightgrey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Upcoming',
                              style: TextStyle(
                                color: _taskController.selectedIndex.value == 0
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _taskController.selectOption(1),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _taskController.selectedIndex.value == 1
                                      ? AppColors.primary
                                      : AppColors.lightgrey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Overdue',
                              style: TextStyle(
                                color: _taskController.selectedIndex.value == 1
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // Task List
                    Obx(
                      () {
                        if (_taskController.isLoading.value) {
                          return Center(
                              child: SizedBox(
                                  height: 25.h,
                                  width: 18.w,
                                  child: CustomProgressIndicator()));
                        }
                        if (_taskController.tasks.isEmpty) {
                          return const Center(child: Text("No tasks found"));
                        } else {
                          return Column(
                            children: _taskController.tasks
                                .map((task) => TaskListTile(
                                      title: task.title,
                                      date: DateFormat('MMMM d, yyyy')
                                          .format(task.initialDate),
                                      onTap: () => Get.toNamed(
                                        RouteNames.notificationDetails,
                                        arguments: task.id,
                                      ),
                                    ))
                                .toList(),
                          );
                        }
                      },
                    )
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthTitleSection({
    required double completedTasks,
    required double totalTasks,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Great Work!',
            style: AppTypoGraphy.medium.copyWith(
              color: AppColors.black,
              fontSize: 24.sp,
            ),
          ),
          Text(
            'You\'ve completed ${completedTasks.toInt()}/${totalTasks.toInt()} tasks this Season!',
            style: AppTypoGraphy.medium.copyWith(
              color: AppColors.secondary,
              fontSize: 18.sp,
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hi Jess,',
              style: AppTypoGraphy.medium.copyWith(
                  color: AppColors.black,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              'Welcome Back',
              style: AppTypoGraphy.regular.copyWith(
                  color: AppColors.black.withAlpha(200),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Get.toNamed(RouteNames.notifications);
          },
          child: Container(
            height: 32.h,
            width: 48.w,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(5.w),
            child: SvgPicture.asset(
              "assets/icons/bell.svg",
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
