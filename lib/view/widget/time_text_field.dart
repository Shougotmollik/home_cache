import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_cache/constants/colors.dart';

class TimeTextField extends StatefulWidget {
  final String hintText;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime>? onDateSelected;

  const TimeTextField({
    super.key,
    this.hintText = 'mm/dd/yyyy',
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
  });

  @override
  State<TimeTextField> createState() => _TimeTextFieldState();
}

class _TimeTextFieldState extends State<TimeTextField> {
  late DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: _pickDate,
      decoration: InputDecoration(
        hintText: widget.hintText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: true,
        fillColor: AppColors.lightgrey,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.grey, width: 1.0),
        ),
        suffixIcon: Icon(
          Icons.calendar_month_outlined,
          size: 20.w,
          color: AppColors.grey,
        ),
      ),
      controller: TextEditingController(text: _dateText),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(2000, 1, 1);

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? widget.initialDate ?? now,
      firstDate: widget.firstDate ?? today,
      lastDate: widget.lastDate ?? DateTime(now.year + 5),
      builder: (context, child) {
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

      // Pass selected DateTime to parent
      if (widget.onDateSelected != null) {
        widget.onDateSelected!(picked);
      }
    }
  }

  String get _dateText {
    if (_selectedDate == null) return '';
    return '${_selectedDate!.month.toString().padLeft(2, '0')}/'
        '${_selectedDate!.day.toString().padLeft(2, '0')}/'
        '${_selectedDate!.year}';
  }
}
