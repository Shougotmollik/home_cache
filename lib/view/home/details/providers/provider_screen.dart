import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/controller/provider_controller.dart';
import 'package:home_cache/view/home/chat/widgets/faq_search_bar_widget.dart';
import 'package:home_cache/view/home/details/providers/filter_dialog.dart';
import 'package:home_cache/view/home/details/widgets/provider_list_tile.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';
import '../../../../config/route/route_names.dart';

class ProviderScreen extends StatelessWidget {
  const ProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProviderController controller = Get.put(ProviderController());

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBarBack(
        title: 'Providers',
        titleColor: AppColors.secondary,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: TextButton(
              onPressed: () => Get.toNamed(RouteNames.addProvider),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 4.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                '+ Add',
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// --- Search ---
              Text(
                'Search Providers',
                style: AppTypoGraphy.bold.copyWith(
                  color: AppColors.black,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 6.h),
              FaqSearchBarWidget(
                hintText: 'Search providers by name or service',
                onChanged: controller.onSearchChanged,
              ),
              SizedBox(height: 24.h),

              /// --- Section Header ---
              Row(
                children: [
                  Text(
                    'Your Providers',
                    style: AppTypoGraphy.bold.copyWith(
                      color: AppColors.black,
                      fontSize: 20.sp,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const FilterDialog(),
                      );
                    },
                    child: SvgPicture.asset(
                      'assets/icons/filter.svg',
                      width: 24.w,
                      height: 24.h,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              /// --- Provider List ---
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                        child: SpinKitPouringHourGlassRefined(
                      color: AppColors.primary,
                      duration: Duration(seconds: 2),
                    ));
                  }
                  if (controller.errorMessage.isNotEmpty) {
                    return Center(child: Text(controller.errorMessage.value));
                  }
                  if (controller.filteredAllProviders.isEmpty) {
                    return const Center(child: Text('No providers found.'));
                  }
                  return ListView.builder(
                    itemCount: controller.filteredAllProviders.length,
                    itemBuilder: (context, index) {
                      final provider = controller.filteredAllProviders[index];
                      debugPrint("=============> Provider $provider");
                      return ProviderListTile(
                        provider: provider,
                        onTap: () => Get.toNamed(RouteNames.providerDetails,
                            arguments: provider.id),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
