import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/controller/provider_controller.dart';
import 'package:home_cache/model/provider_model.dart';
import 'package:home_cache/view/widget/heart_beat_animation.dart';

class ProviderListTile extends StatelessWidget {
  final Provider provider;
  final VoidCallback? onTap;

  const ProviderListTile({
    super.key,
    required this.provider,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final int ratingValue = int.tryParse(provider.rating.split(".").first) ?? 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    provider.lastServiceDate ?? "N/A",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            // STARS + HEART
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < ratingValue
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: AppColors.primaryLight,
                      size: 16.sp,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                FollowHeartButton(provider: provider),
              ],
            ),

            SizedBox(width: 6.w),

            // RIGHT INFO BOX
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.black,
                    size: 24.sp,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Info',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FollowHeartButton extends StatefulWidget {
  final Provider provider;

  const FollowHeartButton({
    super.key,
    required this.provider,
  });

  @override
  State<FollowHeartButton> createState() => _FollowHeartButtonState();
}

class _FollowHeartButtonState extends State<FollowHeartButton> {
  late bool _favorite;
  // bool _isProcessing = false;

  final ProviderController _providerController = Get.find<ProviderController>();

  @override
  void initState() {
    super.initState();
    _favorite = widget.provider.isFollowed;
  }

  @override
  Widget build(BuildContext context) {
    return HeartBeatAnimation(
      selected: _favorite,
      selectedChild: Icon(
        Icons.favorite,
        color: Colors.red,
        size: 20.sp,
      ),
      unselectedChild: Icon(
        Icons.favorite_border,
        color: Colors.grey,
        size: 20.sp,
      ),
      duration: const Duration(milliseconds: 220),
      scale: 1.3,
      onChange: _handleFollowToggle,
    );
  }

  Future<void> _handleFollowToggle() async {
    // if (_isProcessing) return;
    // _isProcessing = true;

    // final originalState = _favorite;

    // Optimistic UI update
    if (mounted) {
      setState(() {
        _favorite = !_favorite;
        widget.provider.isFollowed = _favorite;
      });
    }

    try {
      bool serverFollowState = await _providerController.toggleFollowProvider(
        widget.provider.id,
      );

      if (mounted) {
        setState(() {
          _favorite = serverFollowState;
          widget.provider.isFollowed = serverFollowState;
        });
      }
    } catch (e) {
      // if (mounted) {
      //   setState(() {
      //     _favorite = originalState;
      //     widget.provider.isFollowed = originalState;
      //   });
      // }
    } finally {
      // _isProcessing = false;
    }
  }
}
