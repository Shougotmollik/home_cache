import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/controller/view_by_type_controller.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';
import 'package:home_cache/view/widget/custom_progress_indicator.dart';
import '../../../../config/route/route_names.dart';

class ViewByTypeScreen extends StatefulWidget {
  const ViewByTypeScreen({super.key});

  @override
  State<ViewByTypeScreen> createState() => _ViewByTypeScreenState();
}

class _ViewByTypeScreenState extends State<ViewByTypeScreen> {
  int selectedIndex = -1;

  final ViewByTypeController controller = Get.put(ViewByTypeController());

  @override
  void initState() {
    super.initState();
    controller.getViewByType();
  }

  /// Handle tile taps with navigation
  void onTileTap(int index) {
    switch (index) {
      case 0:
        Get.toNamed(RouteNames.appliances, arguments: {
          "id": controller.typeList[index].id,
          "type": controller.typeList[index].type,
        });
        break;
      case 1:
        Get.toNamed(RouteNames.utility, arguments: {
          "id": controller.typeList[index].id,
          "type": controller.typeList[index].type,
        });
        break;
      case 2:
        Get.toNamed(RouteNames.paintScreen, arguments: {
          "id": controller.typeList[index].id,
          "type": controller.typeList[index].type,
        });
        break;
      case 3:
      default:
        Get.toNamed(RouteNames.material, arguments: {
          "id": controller.typeList[index].id,
          "type": controller.typeList[index].type,
        });
    }
  }

  /// Build grid tile
  Widget _buildTile(
    BuildContext context,
    String title,
    String imageUrl,
    int index,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() => selectedIndex = index);
        onTap();
      },
      child: Container(
        margin: EdgeInsets.all(8.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.lightgrey,
          border: Border.all(
            color: selectedIndex == index
                ? AppColors.primaryLight
                : AppColors.lightgrey,
            width: selectedIndex == index ? 2.w : 1.w,
          ),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              imageUrl,
              height: 52.h,
              width: 52.w,
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.broken_image, size: 40, color: Colors.grey),
            ),
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
        title: 'View By Type',
        titleColor: AppColors.secondary,
      ),
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Obx(() {
            if (controller.isLoading.value) {
              return Padding(
                padding: EdgeInsets.only(top: 100.h),
                child: const Center(child: CustomProgressIndicator()),
              );
            }

            if (controller.typeList.isEmpty) {
              return Padding(
                padding: EdgeInsets.only(top: 100.h),
                child: const Center(child: Text("No data found")),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40.h),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.h,
                    crossAxisSpacing: 8.w,
                    childAspectRatio: 1,
                  ),
                  itemCount: controller.typeList.length,
                  itemBuilder: (context, index) {
                    final item = controller.typeList[index];

                    return _buildTile(
                      context,
                      item.type,
                      item.image,
                      index,
                      () => onTileTap(index),
                    );
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
