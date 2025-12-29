import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/controller/home_member_controller.dart';
import 'package:intl/intl.dart';

class RecentActivityTab extends StatefulWidget {
  const RecentActivityTab({super.key});

  @override
  State<RecentActivityTab> createState() => _RecentActivityTabState();
}

class _RecentActivityTabState extends State<RecentActivityTab> {
  // // Example activity list (replace with API data later)
  // final List<Map<String, String>> activities = const [
  //   {
  //     'title': 'New User Joined',
  //     'subtitle': 'Ahsan was invited',
  //     'time': '8 hours ago',
  //     'icon': 'assets/images/dot.png',
  //   },
  //   {
  //     'title': 'Task Completed',
  //     'subtitle': 'Vacuuming finished by Thomas',
  //     'time': '12 hours ago',
  //     'icon': 'assets/images/dot.png',
  //   },
  //   {
  //     'title': 'Service Updated',
  //     'subtitle': 'Housekeeping schedule changed',
  //     'time': '1 day ago',
  //     'icon': 'assets/images/dot.png',
  //   },
  // ];

  final HomeMemberController homeMemberController =
      Get.put(HomeMemberController());

  @override
  void initState() {
    super.initState();
    homeMemberController.getHomeMemberRecentActivity();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: homeMemberController.activitiesList.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final activity = homeMemberController.activitiesList[index];
        // if (homeMemberController.isLoading.value) {
        //   return const Center(child: CustomProgressIndicator());
        // }
        if (homeMemberController.activitiesList.isEmpty) {
          return const Center(child: Text("No recent activity found"));
        }
        return ActivityTile(
          title: activity.title,
          subtitle: activity.message,
          time: DateFormat.yMMMd()
              .format(DateTime.parse(activity.createdAt.toString())),
          iconPath: 'assets/images/dot.png',
        );
      },
    );
  }
}

class ActivityTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final String iconPath;

  const ActivityTile({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.iconPath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            iconPath,
            height: 20.h,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.black,
                  ),
                ),
                Divider(
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
