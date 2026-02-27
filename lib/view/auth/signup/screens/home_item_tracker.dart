import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/colors.dart' show AppColors;
import 'package:home_cache/constants/data/rooms.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/controller/auth_controller.dart';
import 'package:home_cache/view/auth/signup/widgets/custom_elevated_button.dart';
import 'package:home_cache/view/widget/appbar_back_widget.dart';
import 'package:home_cache/view/widget/text_button_widget_light.dart';
import '../../../../config/route/route_names.dart';

class TrackListScreen extends StatefulWidget {
  const TrackListScreen({super.key});

  @override
  _TrackListScreenState createState() => _TrackListScreenState();
}

class _TrackListScreenState extends State<TrackListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<String> _suggestions = [];
  List<String> _selectedItems = [];

  void _updateSuggestions(String query) {
    setState(() {
      if (query.isEmpty) {
        _suggestions = [];
        return;
      }
      List<String> matches = [];
      for (var room in rooms) {
        if (room.name.toLowerCase().contains(query.toLowerCase())) {
          matches.add(room.name);
        }
        matches.addAll(
          room.items.where(
            (item) => item.toLowerCase().contains(query.toLowerCase()),
          ),
        );
      }

      _suggestions = matches.toSet().toList()
        ..removeWhere(_selectedItems.contains)
        ..sort();
    });
  }

  void _onSuggestionTap(String value) {
    setState(() {
      if (!_selectedItems.contains(value)) {
        _selectedItems.add(value);
        _searchController.clear();
        _suggestions = [];
        _focusNode.requestFocus(); // Keep keyboard open for next search
      }
    });
  }

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarBack(),
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'List Anything You Want To Keep Track Of',
                style: AppTypoGraphy.bold.copyWith(
                  color: AppColors.secondary,
                  fontSize: 26.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Text(
                  'We Included Some Things To Help You Get Started',
                  style: AppTypoGraphy.medium.copyWith(color: AppColors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24.h),

              // --- INLINE CHIP SEARCH BAR START ---
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.border, width: 1.w),
                ),
                child: Wrap(
                  spacing: 8.w,
                  runSpacing: 4.h,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Render current tags
                    ..._selectedItems.map((item) => Chip(
                          side: BorderSide(color: AppColors.border, width: 1.w),
                          label: Text(item, style: TextStyle(fontSize: 13.sp)),
                          onDeleted: () {
                            setState(() => _selectedItems.remove(item));
                          },
                          backgroundColor: AppColors.lightgrey,
                          deleteIcon: Icon(
                            Icons.close,
                            size: 14.sp,
                            color: AppColors.secondary,
                          ),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                        )),
                    // The Input field that follows the chips
                    IntrinsicWidth(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: 80.w),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          onChanged: _updateSuggestions,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (value) {
                            final trimmerValue = value.trim();
                            if (trimmerValue.isNotEmpty) {
                              if (!_selectedItems.contains(trimmerValue)) {
                                setState(() {
                                  _selectedItems.add(trimmerValue);
                                  _searchController.clear();
                                  _suggestions = [];
                                });
                              }
                            } else {
                              _searchController.clear();
                            }
                            _focusNode
                                .requestFocus(); // Keep keyboard open for next search
                          },
                          decoration: InputDecoration(
                            hintText:
                                _selectedItems.isEmpty ? 'Search items...' : '',
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                          ),
                          style: TextStyle(fontSize: 15.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // --- INLINE CHIP SEARCH BAR END ---

              SizedBox(height: 8.h),

              // SUGGESTIONS LIST (Vertical dropdown feel)
              if (_suggestions.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(top: 4.h),
                  constraints: BoxConstraints(maxHeight: 200.h),
                  decoration: BoxDecoration(
                    color: AppColors.lightgrey,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _suggestions.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1.w,
                      color: AppColors.border,
                    ),
                    itemBuilder: (context, index) {
                      final suggestion = _suggestions[index];
                      return ListTile(
                        dense: true,
                        title: Text(suggestion,
                            style: TextStyle(
                                fontSize: 15.sp, color: AppColors.text)),
                        onTap: () => _onSuggestionTap(suggestion),
                      );
                    },
                  ),
                ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 60.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButtonWidgetLight(
              text: 'Skip',
              onPressed: () => Get.toNamed(RouteNames.finishUtility),
            ),
            Obx(
              () => CustomElevatedButton(
                width: 128.w,
                onTap: () {
                  if (_selectedItems.isEmpty) {
                    Get.snackbar('Error', 'Please select at least one item');
                    return;
                  }
                  authController.updateWantToTrack(_selectedItems);
                  authController.submitHomeData();
                },
                btnText: authController.isLoading.value ? 'Loading' : 'Confirm',
                icon: Icons.check,
              ),
            )
          ],
        ),
      ),
    );
  }
}
