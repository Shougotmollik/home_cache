import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/controller/provider_controller.dart';
import 'package:home_cache/view/home/details/widgets/doccument_slider.dart';
import 'package:home_cache/view/home/details/widgets/past_appoinment_tile.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';
import 'package:home_cache/view/widget/scheduled_appointment_tile.dart';
import '../../../../config/route/route_names.dart';

class ProviderDetailsScreen extends StatefulWidget {
  const ProviderDetailsScreen({super.key});

  @override
  State<ProviderDetailsScreen> createState() => _ProviderDetailsScreenState();
}

class _ProviderDetailsScreenState extends State<ProviderDetailsScreen>
    with SingleTickerProviderStateMixin {
  bool isPastExpanded = false;
  final ProviderController providerController = Get.put(ProviderController());
  late String providerId;

  @override
  void initState() {
    super.initState();
    
    // Handle both String and Map arguments
    final args = Get.arguments;
    if (args is Map<String, String>) {
      providerId = args['id'] ?? '';
    } else if (args is String) {
      providerId = args;
    } else {
      providerId = '';
      print("⚠️ Invalid arguments type: ${args.runtimeType}");
    }
    
    print("Provider ID:=======Details Screen=======> $providerId");
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (providerId.isNotEmpty) {
        providerController.fetchProviderDetails(providerId);
      } else {
        print("❌ Provider ID is empty!");
      }
    });
  }

  Widget _buildStars(double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) => Icon(
          index < rating
              ? Icons.star
              : (index < rating + 0.5 ? Icons.star_half : Icons.star_border),
          color: AppColors.primaryLight,
          size: 30.sp,
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: AppTypoGraphy.semiBold.copyWith(color: AppColors.black)),
        Divider(color: AppColors.black, thickness: 1.h, height: 12.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBarBack(),
      body: SafeArea(
        child: Obx(() {
          final provider = providerController.selectedProvider.value;
          final isLoading = providerController.isLoading.value;

          if (isLoading) {
            return const Center(
                child: SpinKitPouringHourGlassRefined(
              color: AppColors.primary,
              duration: Duration(seconds: 2),
            ));
          }

          if (provider == null) {
            return const Center(child: Text("No provider found"));
          }

          // Documents - Fixed to use proper Document model
          final docs = provider.documents.isNotEmpty
              ? provider.documents
                  .map((doc) => {
                        'iconPath': 'assets/images/document.png',
                        'title': doc.fileName,
                        'date': 'Uploaded',
                      })
                  .toList()
              : [
                  {
                    'iconPath': 'assets/images/document.png',
                    'title': 'No documents',
                    'date': '',
                  }
                ];

          return SingleChildScrollView(
            padding: EdgeInsets.all(24.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Provider Info
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Column(
                      children: [
                        Text(
                          provider.type,
                          style: AppTypoGraphy.regular.copyWith(
                            color: AppColors.black,
                            fontSize: 16.sp,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          provider.name,
                          style: AppTypoGraphy.bold
                              .copyWith(color: AppColors.primary),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12.h),
                        _buildStars(double.tryParse(provider.rating) ?? 0),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        print('Edit');
                        print(
                            "is passing from details screen ====>$providerId");
                        Get.toNamed(
                          RouteNames.updateProvider,
                          arguments: providerId,
                        );
                      },
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: AppColors.lightgrey,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.edit,
                            size: 18.w,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Contact Info
                _sectionTitle('Contact Information'),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(provider.name,
                          style:
                              AppTypoGraphy.regular.copyWith(fontSize: 20.sp)),
                      SizedBox(height: 4.h),
                      Text(provider.mobile,
                          style:
                              AppTypoGraphy.regular.copyWith(fontSize: 20.sp)),
                      SizedBox(height: 4.h),
                      Text(
                        provider.webUrl,
                        style: AppTypoGraphy.regular.copyWith(
                          fontSize: 20.sp,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // Scheduled Appointments - NOW SHOWS REAL DATA FROM API
                _sectionTitle('Scheduled Appointments'),
                Obx(() {
                  final nextAppts = providerController.nextAppointments;

                  if (nextAppts.isEmpty) {
                    return const ScheduledAppointmentTile(
                      title: "No data",
                      subtitle: "No scheduled appointments",
                    );
                  }

                  // Show all next appointments from API
                  return Column(
                    children: nextAppts.map((appt) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: ScheduledAppointmentTile(
                          title: appt.title,
                          subtitle: "${appt.formattedDate} at ${appt.formattedTime}",
                        ),
                      );
                    }).toList(),
                  );
                }),
                SizedBox(height: 20.h),

                // Past Appointments with animation - NOW SHOWS REAL DATA FROM API
                GestureDetector(
                  onTap: () => setState(() {
                    isPastExpanded = !isPastExpanded;
                    print("📂 Past appointments expanded: $isPastExpanded");
                    print("📂 Last appointments count: ${providerController.lastAppointments.length}");
                  }),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Past Appointments',
                          style: AppTypoGraphy.semiBold
                              .copyWith(color: AppColors.black)),
                      Icon(
                        isPastExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: AppColors.secondary,
                        size: 24.w,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Obx(() {
                    final lastAppts = providerController.lastAppointments;
                    
                    print("🔍 UI: Rendering past appointments, count: ${lastAppts.length}");

                    if (lastAppts.isEmpty) {
                      return const PastAppointmentsTile(
                        date: 'No data',
                        status: 'No history available',
                      );
                    }

                    // Show all past appointments from API
                    return Column(
                      children: lastAppts.map((appt) {
                        print("🔍 UI: Rendering appointment - ${appt.title} on ${appt.formattedDate}");
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: PastAppointmentsTile(
                            date: appt.formattedDate,
                            status: appt.title,
                          ),
                        );
                      }).toList(),
                    );
                  }),
                  crossFadeState: isPastExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
                SizedBox(height: 20.h),

                // Documents
                _sectionTitle('Documents'),
                DocumentSlider(documents: docs),
              ],
            ),
          );
        }),
      ),
    );
  }
}