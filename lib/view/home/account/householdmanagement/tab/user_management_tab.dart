import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/controller/home_member_controller.dart';
import 'package:home_cache/controller/user_controller.dart';
import 'package:home_cache/view/home/account/productsupport/widgets/text_field_widget.dart';
import 'package:home_cache/view/home/account/widgets/user_management_tile.dart';
import 'package:home_cache/view/widget/custom_progress_indicator.dart';
import 'package:home_cache/view/widget/text_button_widget.dart';

class UserManagementTab extends StatefulWidget {
  const UserManagementTab({super.key});

  @override
  State<UserManagementTab> createState() => _UserManagementTabState();
}

class _UserManagementTabState extends State<UserManagementTab> {
  bool isAddingUser = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  late final UserController userController;
  late final HomeMemberController homeMemberController;

  @override
  void initState() {
    super.initState();

    // Get controllers safely
    userController = Get.find<UserController>();
    homeMemberController = Get.put(HomeMemberController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userController.getUserData();
      userController.getHomeMemberData();
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (userController.userDataList.first.homeData?.homeRole == 'owner')
          _buildOwnerCard()
        else
          _buildResidentCard(context),
        SizedBox(height: 12.h),
        if (isAddingUser) _buildAddUserForm(context) else _buildMemberList(),
      ],
    );
  }

  Widget _buildResidentCard(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 220.w,
          child: Text(
            'Join to get access  HomeCache',
            style: AppTypoGraphy.bold.copyWith(color: AppColors.secondary),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            minimumSize: Size(100.w, 40.h),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  insetPadding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 18.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: SizedBox(
                    height: 200.h,
                    width: 300.w,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 18.h),
                      child: Column(
                        children: [
                          Text(
                            "Join Home",
                            style: AppTypoGraphy.bold
                                .copyWith(color: AppColors.primary),
                          ),
                          SizedBox(height: 16.h),
                          TextFieldWidget(
                            hintText: 'Enter your OTP',
                            controller: otpController,
                          ),
                          SizedBox(height: 24.h),
                          Obx(
                            () => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 50.w),
                              child: TextWidgetButton(
                                text: homeMemberController.isLoading.value
                                    ? 'Joining...'
                                    : 'Submit',
                                onPressed: () {
                                  if (otpController.text.trim().isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please enter OTP'),
                                      ),
                                    );
                                    return;
                                  }
                                  homeMemberController.joinHome({
                                    "home_id": otpController.text.trim(),
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: const Text("Join Now"),
        )
      ],
    );
  }

  Widget _buildOwnerCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 220.w,
          child: Text(
            'Who can see your HomeCache',
            style: AppTypoGraphy.bold.copyWith(color: AppColors.secondary),
          ),
        ),
        IconButton(
          icon: Icon(
            isAddingUser ? Icons.close : Icons.add,
            size: 32.sp,
            color: AppColors.secondary,
          ),
          onPressed: () => setState(() => isAddingUser = !isAddingUser),
        ),
      ],
    );
  }

  Widget _buildAddUserForm(BuildContext context) {
    return Container(
      height: 180.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          SizedBox(height: 16.h),
          TextFieldWidget(
            hintText: 'Email',
            controller: emailController,
          ),
          SizedBox(height: 24.h),
          Obx(
            () => Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.w),
              child: TextWidgetButton(
                text: homeMemberController.isLoading.value
                    ? 'Sending...'
                    : 'Send Invite',
                onPressed: () async {
                  if (emailController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter an email'),
                      ),
                    );
                    return;
                  }

                  await homeMemberController.inviteHomeMember({
                    "email": emailController.text.trim(),
                  });

                  setState(() => isAddingUser = false);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '"${emailController.text}" invite sent successfully',
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberList() {
    return Obx(() {
      if (userController.isLoading.value) {
        return const Center(child: CustomProgressIndicator());
      }

      if (userController.homeMemberList.isEmpty) {
        return const Center(child: Text('No members found'));
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: userController.homeMemberList.length,
        itemBuilder: (context, index) {
          final user = userController.homeMemberList[index];
          final role = user.homeData.homeRole.isNotEmpty
              ? 'House ${user.homeData.homeRole[0].toUpperCase()}${user.homeData.homeRole.substring(1)}'
              : 'House Member';

          return Dismissible(
            key: ValueKey(user.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) async {
              // final removedUser = user;
              // final removedIndex = index;
              // // userController.homeMemberList.removeAt(index);

              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     backgroundColor: Colors.green,
              //     duration: const Duration(seconds: 3),
              //     content: Text('${removedUser.profile.firstName} removed'),
              //     action: SnackBarAction(
              //       label: 'Undo',
              //       onPressed: () {
              //         userController.homeMemberList
              //             .insert(removedIndex, removedUser);
              //       },
              //     ),
              //   ),
              // );
              await homeMemberController.removeHomeMember();
              await userController.getHomeMemberData();
            },
            child: UserManagementTile(
              onTap: () {},
              fullName: '${user.profile.firstName} ${user.profile.lastName}',
              role: role,
            ),
          );
        },
      );
    });
  }
}
