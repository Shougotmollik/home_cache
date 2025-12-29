import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_cache/constants/colors.dart';

class TaskTileWidget extends StatefulWidget {
  final String date;
  final String taskName;
  final String iconPath;
  final String assignedTo;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const TaskTileWidget({
    super.key,
    required this.date,
    required this.taskName,
    required this.iconPath,
    required this.assignedTo,
    this.onDelete,
    this.onEdit,
  });

  @override
  State<TaskTileWidget> createState() => _TaskTileWidgetState();
}

class _TaskTileWidgetState extends State<TaskTileWidget> {
  bool _isLinked = false; // track toggle state

  void _toggleIcon() {
    setState(() {
      _isLinked = !_isLinked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.date,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const Spacer(),
            if (widget.onDelete != null)
              // IconButton(
              //   icon: SvgPicture.asset(
              //     'assets/icons/delete.svg',
              //     width: 18.w,
              //     height: 18.h,
              //     color: AppColors.error,
              //   ),
              //   onPressed: widget.onDelete,
              //   padding: EdgeInsets.zero,
              //   constraints: const BoxConstraints(),
              // ),
              if (widget.onEdit != null) ...[
                SizedBox(width: 8.w),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 18.h,
                    color: AppColors.primary,
                  ),
                  // icon: SvgPicture.asset(
                  //   'assets/icons/edit.svg',
                  //   width: 18.w,
                  //   height: 18.h,
                  //   color: AppColors.primary,
                  // ),
                  onPressed: widget.onEdit,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Expanded(
              child: Text(
                '• ${widget.taskName}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ),
            SvgPicture.asset(
              widget.iconPath,
              width: 18.w,
              height: 18.h,
              color: AppColors.primary,
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: () {
                if (!_isLinked) {
                  setState(() {
                    _isLinked = true;
                  });
                }
              },
              child: SvgPicture.asset(
                _isLinked ? 'assets/icons/link.svg' : 'assets/icons/add.svg',
                width: 18.w,
                height: 18.h,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            SvgPicture.asset(
              'assets/icons/account.svg',
              width: 14.w,
              height: 14.h,
              color: AppColors.grey,
            ),
            SizedBox(width: 4.w),
            Text(
              widget.assignedTo,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        const Divider(
          color: Colors.grey,
          thickness: 0.5,
          height: 1,
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
