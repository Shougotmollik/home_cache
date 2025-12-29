import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart' show AppColors;
import 'package:home_cache/view/auth/signup/widgets/custom_elevated_button.dart';
import 'package:home_cache/view/home/account/widgets/account_deletion_dialog.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  String? selectedReason;

  final List<String> reasons = [
    'No longer using the service/platform',
    'Found a better alternative',
    'Privacy concerns',
    'Too many emails/Notifications',
    'Difficulty navigating the platform',
    'Account security concerns',
    'Personal reasons',
    'Others',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(
        title: 'Delete Account',
        titleColor: AppColors.black,
      ),
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "We're sorry to see you go. Select a reason to continue.",
                style: AppTypoGraphy.regular.copyWith(color: AppColors.black),
              ),
              SizedBox(height: 20.h),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: reasons.length,
                itemBuilder: (context, index) {
                  return RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      reasons[index],
                      style: AppTypoGraphy.regular.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    value: reasons[index],
                    groupValue: selectedReason,
                    onChanged: (value) {
                      setState(() {
                        selectedReason = value;
                      });
                    },
                    activeColor: AppColors.primary,
                  );
                },
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomElevatedButton(
            height: 48.h,
            onTap: () {
              if (selectedReason != null) {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AccountDeletionDialog());
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(10),
                    elevation: 0,
                    dismissDirection: DismissDirection.horizontal,
                    padding: EdgeInsets.all(10),
                    content: Text('Please select a reason'),
                  ),
                );
              }
            },
            btnText: 'Delete',
          ),
        ),
      ),
    );
  }
}
