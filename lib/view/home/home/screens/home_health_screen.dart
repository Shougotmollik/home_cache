import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/controller/home_controller.dart';
import 'package:home_cache/view/home/home/widgets/task_progress_bar.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';
import 'package:home_cache/view/widget/task_list_tile.dart' show TaskListTile;

class HomeHealthScreen extends StatefulWidget {
  const HomeHealthScreen({super.key});

  @override
  State<HomeHealthScreen> createState() => _HomeHealthScreenState();
}

class _HomeHealthScreenState extends State<HomeHealthScreen> {
  bool isOverdueExpanded = true;
  bool isTasksExpanded = true;
  bool isCompleteExpanded = true;

  final HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    homeController.getHomeHealth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(
        title: 'Home Health',
        titleColor: AppColors.black,
      ),
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Obx(
          () {
            if (homeController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final homeData = homeController.homeTaskData.value;

            if (homeData == null) {
              return const Center(child: Text("No data available"));
            }

            final totalTasks = homeData.homeHealth.totalTasks;
            final completedTasks = homeData.homeHealth.completedTasks;
            final overdueTasks = homeData.tasks.overdue;
            final upcomingTasks = homeData.tasks.upcoming;
            final completedTasksList = homeData.tasks.completed;

            return SingleChildScrollView(
              padding: EdgeInsets.all(24.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20.h),
                  Text(
                    'Great Work,',
                    style:
                        AppTypoGraphy.medium.copyWith(color: AppColors.black),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'You’ve completed $completedTasks/$totalTasks tasks this Season!',
                    style: AppTypoGraphy.medium.copyWith(
                      color: AppColors.secondary,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  TaskProgressBar(
                    totalTasks: 100,
                    completedTasks: 6,
                  ),

                  SizedBox(height: 32.h),

                  // Overdue Tasks - Expandable
                  _buildExpandableTaskSection(
                    title: "Overdue Tasks",
                    isExpanded: isOverdueExpanded,
                    toggleExpanded: () {
                      setState(() {
                        isOverdueExpanded = !isOverdueExpanded;
                      });
                    },
                    tasks: overdueTasks,
                    defaultDate: "Overdue",
                  ),

                  SizedBox(height: 12.h),

                  // Upcoming Tasks - Expandable
                  _buildExpandableTaskSection(
                    title: "Tasks",
                    isExpanded: isTasksExpanded,
                    toggleExpanded: () {
                      setState(() {
                        isTasksExpanded = !isTasksExpanded;
                      });
                    },
                    tasks: upcomingTasks,
                    defaultDate: "Pending",
                  ),

                  SizedBox(height: 12.h),

                  // Completed Tasks - Expandable
                  _buildExpandableTaskSection(
                    title: "Complete Tasks",
                    isExpanded: isCompleteExpanded,
                    toggleExpanded: () {
                      setState(() {
                        isCompleteExpanded = !isCompleteExpanded;
                      });
                    },
                    tasks: completedTasksList,
                    defaultDate: "Complete",
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildExpandableTaskSection({
    required String title,
    required bool isExpanded,
    required VoidCallback toggleExpanded,
    required List<dynamic> tasks,
    required String defaultDate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: toggleExpanded,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTypoGraphy.medium.copyWith(
                  color: AppColors.black,
                  fontSize: 20.sp,
                ),
              ),
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: AppColors.secondary,
                size: 24.w,
              ),
            ],
          ),
        ),
        Divider(color: AppColors.lightgrey, thickness: 1.h, height: 6.h),
        if (isExpanded)
          ...tasks.map((task) {
            final taskTitle = task['title'] ?? "No title";
            final taskDate = task['date'] ?? defaultDate;
            return TaskListTile(
              title: taskTitle,
              date: taskDate,
              onTap: () {},
            );
          }).toList(),
      ],
    );
  }
}
