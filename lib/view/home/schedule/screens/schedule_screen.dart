import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:home_cache/config/route/route_names.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/controller/schedule_controller.dart';  
import 'package:home_cache/view/widget/custom_progress_indicator.dart';
import 'package:intl/intl.dart';

import '../dialog/add_task_dialog.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final List<Task> _tasks = [];
  final ScheduleController _scheduleController = Get.find<ScheduleController>();

  String? assignToId;

  @override
  void initState() {
    _scheduleController.fetchAllSchedule();
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    assignToId = args?['assign_to_id'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          'Schedule',
          style: AppTypoGraphy.bold.copyWith(color: AppColors.black),
        ),
        centerTitle: false,
        backgroundColor: AppColors.surface,
        automaticallyImplyLeading: false,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.black),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: _buildActionButtons(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Upcoming Tasks',
                style: AppTypoGraphy.bold.copyWith(color: AppColors.black),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 12.h),
              Obx(
                () {
                  if (_scheduleController.isLoading.value) {
                    return const Center(child: CustomProgressIndicator());
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _scheduleController.schedule.length,
                    itemBuilder: (context, index) {
                      final task = _scheduleController.schedule[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('MMMM d, yyyy')
                                .format(task.initialDate!),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '• ${task.title}',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: () {
                                  if (assignToId != null &&
                                      assignToId!.isNotEmpty) {
                                    var data = {
                                      'task_id': task.id,
                                      'assign_to': assignToId
                                    };
                                    _scheduleController.assignNewProvider(data);
                                  } else {
                                    Get.toNamed(RouteNames.homeMember,
                                        arguments: {
                                          'task_id': task.id,
                                          'task_title': task.title
                                        });
                                    setState(() {
                                      task.isLinked = !task.isLinked;
                                    });
                                  }
                                },
                                child: SvgPicture.asset(
                                  task.isLinked
                                      ? 'assets/icons/link.svg'
                                      : 'assets/icons/add.svg',
                                  width: 18.w,
                                  height: 18.h,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 12.h);
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30.w,
          height: 30.w,
          padding: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(122),
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SvgPicture.asset(
            'assets/icons/download.svg',
            width: 16,
            height: 16,
            color: AppColors.primary,
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: () => _showAddTaskDialog(context),
          child: Container(
            width: 30.w,
            height: 30.w,
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(122),
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SvgPicture.asset(
              'assets/icons/add.svg',
              width: 10.w,
              height: 10.w,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildTaskList() {
  //   if (_taskController.tasks.isEmpty) {
  //     return Center(
  //       child: Text(
  //         'No tasks scheduled',
  //         style: AppTypoGraphy.regular.copyWith(color: Colors.grey),
  //       ),
  //     );
  //   }

  //   return Column(
  //     children: _tasks.map((task) {
  //       return TaskTileWidget(
  //         date: _formatDate(task.date),
  //         taskName: "${_taskController.tasks.indexOf(task) + 1}. ${task.title}",
  //         iconPath: task.iconPath,
  //         assignedTo: task.assignedTo,
  //         onDelete: () => _deleteTask(task.id),
  //       );
  //     }).toList(),
  //   );
  // }

  void _showAddTaskDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
      ),
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddTaskDialog(
          onTaskAdded: (newTask) {
            setState(() {
              _tasks.add(newTask);
            });
          },
        ),
      ),
    );
  }

  void _deleteTask(String taskId) {
    setState(() {
      _tasks.removeWhere((task) => task.id == taskId);
    });
  }

  String _formatDate(DateTime date) {
    return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
  }

  String _getMonthName(int month) {
    return const [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ][month - 1];
  }
}

class Task {
  final String id;
  final String title;
  final DateTime date;
  final String iconPath;
  final String assignedTo;
  final bool repeats;
  final String? frequency;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.date,
    required this.iconPath,
    required this.assignedTo,
    this.repeats = false,
    this.frequency,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isCompleted = false,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Helper method to format date
  String get formattedDate {
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'iconPath': iconPath,
      'assignedTo': assignedTo,
      'repeats': repeats,
      'frequency': frequency,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  // Create from Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      iconPath: map['iconPath'],
      assignedTo: map['assignedTo'],
      repeats: map['repeats'] ?? false,
      frequency: map['frequency'],
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  // Copy with method for immutability
  Task copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? iconPath,
    String? assignedTo,
    bool? repeats,
    String? frequency,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      iconPath: iconPath ?? this.iconPath,
      assignedTo: assignedTo ?? this.assignedTo,
      repeats: repeats ?? this.repeats,
      frequency: frequency ?? this.frequency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
