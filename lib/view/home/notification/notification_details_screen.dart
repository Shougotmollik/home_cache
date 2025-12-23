import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/controller/provider_controller.dart';
import 'package:home_cache/controller/task_controller.dart';
import 'package:home_cache/view/home/details/widgets/provider_list_tile.dart';
import 'package:home_cache/view/home/notification/screens/home_member_screen.dart';
import 'package:home_cache/view/home/schedule/widgets/assigned_person_tile.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';

class NotificationDetailsScreen extends StatefulWidget {
  const NotificationDetailsScreen({super.key});

  @override
  State<NotificationDetailsScreen> createState() =>
      _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
  bool _isNameVisible = false;
  bool _isNotificationSettingsVisible = false;

  Person? _selectedPerson;

  final TaskController taskController = Get.put(TaskController());
  final ProviderController providerController = Get.find<ProviderController>();

  @override
  void initState() {
    super.initState();
    final id = Get.arguments as String;

    // Delay fetching until after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      taskController.fetchTaskDetails(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(),
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Obx(() {
          if (taskController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = taskController.taskDetails.value;
          if (data == null) {
            return const Center(child: Text("No data found"));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(24.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// Title
                Text(
                  // data.title,
                  "Notification",
                  style: AppTypoGraphy.bold.copyWith(color: AppColors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),

                /// Schedule Status
                _buildScheduleSection(),

                SizedBox(height: 24.h),

                /// Quick Actions
                _buildQuickActions(),

                SizedBox(height: 24.h),

                /// Last Service
                // _buildLastServiceSection(data.),

                SizedBox(height: 20.h),

                /// Assigned To
                _buildAssignedSection(),

                SizedBox(height: 48.h),

                /// Notification Settings
                _buildNotificationSettings(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildScheduleSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Schedule',
              style: AppTypoGraphy.bold.copyWith(color: AppColors.black),
            ),
            Container(
              height: 40.h,
              width: 40.h,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: Colors.white, size: 20.sp),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Text('No schedule currently linked.'),
      ],
    );
  }

  Widget _buildQuickActions() {
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
          onTap: () {
            showDatePicker(
              context: context,
              firstDate: DateTime(1995),
              lastDate: DateTime(2050),
            );
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

  Widget _buildLastServiceSection(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Details',
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20.h),
        Text('Last Service On', style: AppTypoGraphy.regular),
        SizedBox(height: 5.h),
        Text(data["lastServiceDate"], style: AppTypoGraphy.semiBold),
        SizedBox(height: 20.h),
        Text('Last Service By', style: AppTypoGraphy.regular),
      ],
    );
  }

  Widget _buildAssignedSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isNameVisible = !_isNameVisible;
            });
          },
          child: Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person,
                        size: 20.sp, color: AppColors.primaryLight),
                    SizedBox(width: 8.w),
                    Text('Assigned To',
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                Row(
                  children: [
                    if (_isNameVisible && _selectedPerson != null)
                      Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Text(
                          _selectedPerson!.name,
                          style: TextStyle(
                              color: AppColors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    Icon(
                      _isNameVisible
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: AppColors.primary,
                      size: 24.sp,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Divider(color: Colors.grey),
        if (_isNameVisible)
          AssignedPersonTile(
            name: _selectedPerson?.name ?? 'Select a person',
            role: _selectedPerson?.role ?? '',
            onEdit: () async {
              final selected = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonSelectionPage(
                    currentSelection: _selectedPerson,
                    people: [
                      Person(name: 'Vanessa Alvarez', role: 'House Resident'),
                      Person(name: 'Jess Soyak', role: 'House Owner'),
                      Person(name: 'Ahsan Bari', role: 'House Resident'),
                    ],
                  ),
                ),
              );
              if (selected != null) {
                setState(() {
                  _selectedPerson = selected;
                });
              }
            },
          ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isNotificationSettingsVisible = !_isNotificationSettingsVisible;
            });
          },
          behavior: HitTestBehavior.translucent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.notifications,
                      color: AppColors.primaryLight, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text('Notification Settings',
                      style: TextStyle(
                          color: AppColors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              Icon(
                _isNotificationSettingsVisible
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down,
                color: AppColors.primary,
                size: 24.sp,
              ),
            ],
          ),
        ),
        const Divider(color: Colors.grey),
        if (_isNotificationSettingsVisible)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("🔔 Daily reminders"),
                Text("🔔 Push notifications"),
              ],
            ),
          ),
      ],
    );
  }
}

/// Person Model
