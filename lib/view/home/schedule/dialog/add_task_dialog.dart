import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_cache/constants/app_typo_graphy.dart';
import 'package:home_cache/constants/colors.dart';
import 'package:home_cache/controller/task_controller.dart';
import 'package:home_cache/view/home/schedule/screens/schedule_screen.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(Task) onTaskAdded;

  const AddTaskDialog({
    super.key,
    required this.onTaskAdded,
  });

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

final TaskController _taskController = Get.put(TaskController());

class _AddTaskDialogState extends State<AddTaskDialog> {
  DateTime? _selectedDate;
  bool _repeats = false;
  String? _selectedFrequency;
  String? _selectedAssignee;
  bool _isEditingTaskName = false;

  final List<String> _frequencies = [
    'Weekly',
    'Biweekly',
    'Monthly',
    'Every Spring',
    'Every Summer',
    'Every Fall',
    'Every Winter',
    'Annually',
    'Biannually',
  ];

  final TextEditingController _taskNameController = TextEditingController();
  final List<Map<String, String>> _assignees = [
    {'name': 'Jess Soyak', 'role': 'House Owner'},
    {'name': 'Vanessa Alvarez', 'role': 'House Resident'},
    {'name': 'Ahsan Bari', 'role': 'House Resident'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _taskNameController.text = 'New Task';
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    super.dispose();
  }

  String get _dateText {
    if (_selectedDate == null) return 'Select date';
    return '${_selectedDate!.month.toString().padLeft(2, '0')}/'
        '${_selectedDate!.day.toString().padLeft(2, '0')}/'
        '${_selectedDate!.year}';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: today,
      lastDate: DateTime(now.year + 5),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  void _saveTask() {
    // if (_taskNameController.text.isEmpty || _selectedDate == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Please fill all required fields')),
    //   );
    //   return;
    // }

    // final newTask = Task(
    //   id: DateTime.now().millisecondsSinceEpoch.toString(),
    //   title: _taskNameController.text,
    //   date: _selectedDate!,
    //   // iconPath: 'assets/icons/task_default.svg',
    //   iconPath: '',
    //   assignedTo: _selectedAssignee ?? _assignees.first['name']!,
    //   repeats: _repeats,
    //   frequency: _selectedFrequency,
    // );

    final newTask = {
      "title": _taskNameController.text,
      "description": " ",
      "initial_date": _selectedDate!.toIso8601String(),
      "recurrence_type": "none"
    };

    _taskController.createTask(newTask);

    // widget.onTaskAdded(newTask);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightgrey,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: _isEditingTaskName
                      ? TextField(
                          controller: _taskNameController,
                          autofocus: true,
                          style:
                              AppTypoGraphy.regular.copyWith(fontSize: 20.sp),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onSubmitted: (_) {
                            setState(() => _isEditingTaskName = false);
                          },
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                            setState(() => _isEditingTaskName = false);
                          },
                        )
                      : GestureDetector(
                          onTap: () =>
                              setState(() => _isEditingTaskName = true),
                          child: Text(
                            _taskNameController.text,
                            style:
                                AppTypoGraphy.regular.copyWith(fontSize: 20.sp),
                          ),
                        ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _isEditingTaskName = true),
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Icon(
                      Icons.edit,
                      size: 18.h,
                      color: AppColors.primary,
                    ),
                    // child: SvgPicture.asset(
                    //   'assets/icons/edit.svg',
                    //   width: 16.w,
                    //   color: AppColors.primary,
                    // ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),
            Divider(color: Colors.grey[400], thickness: 1, height: 1),
            SizedBox(height: 16.h),

            // Date Picker
            TextField(
              readOnly: true,
              onTap: _pickDate,
              decoration: InputDecoration(
                labelText: 'Date*',
                hintText: 'mm/dd/yyyy',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                filled: true,
                fillColor: AppColors.lightgrey,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.r),
                  borderSide: BorderSide(color: AppColors.primary, width: 1.0),
                ),
                suffixIcon: Icon(Icons.calendar_month_outlined,
                    size: 20.w, color: AppColors.primary),
              ),
              controller: TextEditingController(text: _dateText),
            ),

            SizedBox(height: 20.h),

            // Assignee Selection
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assignee',
                  style: AppTypoGraphy.regular.copyWith(fontSize: 16.sp),
                ),
                SizedBox(height: 8.h),
                DropdownButtonFormField<String>(
                  initialValue: _selectedAssignee,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.lightgrey,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.r),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  dropdownColor: Color(0xffA7B8BB),
                  items: _assignees.map((assignee) {
                    return DropdownMenuItem(
                      value: assignee['name'],
                      child: Text('${assignee['name']} (${assignee['role']})'),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _selectedAssignee = value),
                  hint: Text('Select assignee'),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            // Repeats Toggle
            Row(
              children: [
                Checkbox(
                  value: _repeats,
                  activeColor: AppColors.primary,
                  onChanged: (bool? value) {
                    setState(() {
                      _repeats = value ?? false;
                      if (!_repeats) _selectedFrequency = null;
                    });
                  },
                ),
                Text(
                  'Repeats',
                  style: AppTypoGraphy.regular.copyWith(fontSize: 16.sp),
                ),
              ],
            ),

            // Frequency Selection (conditional)
            if (_repeats) ...[
              SizedBox(height: 8.h),
              DropdownButtonFormField<String>(
                initialValue: _selectedFrequency,
                decoration: InputDecoration(
                  labelText: 'Frequency',
                  filled: true,
                  fillColor: AppColors.lightgrey,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.r),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
                items: _frequencies.map((freq) {
                  return DropdownMenuItem(
                    value: freq,
                    child: Text(freq),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedFrequency = value),
                hint: Text('Select frequency'),
              ),
            ],

            SizedBox(height: 40.h),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'CANCEL',
                    style: AppTypoGraphy.regular
                        .copyWith(color: AppColors.primary),
                  ),
                ),
                SizedBox(width: 16.w),
                Obx(
                  () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    onPressed: _saveTask,
                    child: Text(
                      _taskController.isLoading.value ? 'Saving...' : 'SAVE',
                      style:
                          AppTypoGraphy.regular.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
