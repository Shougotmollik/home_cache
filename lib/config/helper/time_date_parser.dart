import 'package:intl/intl.dart';

DateTime? timeDateParser(String? value) {
  if (value == null || value.isEmpty) return null;

  try {
    return DateTime.parse(value);
  } catch (_) {}

  try {
    return DateFormat('dd/MM/yyyy').parse(value);
  } catch (_) {}

  return null;
}
