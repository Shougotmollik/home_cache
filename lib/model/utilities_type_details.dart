class UtilityTypeDetails {
  final String id;
  final UtilityItem utilityItem;
  final UtilityDetails details;

  UtilityTypeDetails({
    required this.id,
    required this.utilityItem,
    required this.details,
  });

  factory UtilityTypeDetails.fromJson(Map<String, dynamic> json) {
    return UtilityTypeDetails(
      id: json['id'] as String? ?? '',
      utilityItem: json['utility_item'] is Map<String, dynamic>
          ? UtilityItem.fromJson(json['utility_item'])
          : UtilityItem(name: ''),
      details: UtilityDetails.fromDynamic(json['details']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'utility_item': utilityItem.toJson(),
      // 'details': details.toJson(),
    };
  }
}

class UtilityItem {
  final String name;

  UtilityItem({required this.name});

  factory UtilityItem.fromJson(Map<String, dynamic> json) {
    return UtilityItem(
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}

class UtilityDetails {
  final DateTime? lastServiceDate;
  final String? notes;

  UtilityDetails({this.lastServiceDate, this.notes});

  factory UtilityDetails.fromDynamic(dynamic value) {
    if (value is Map<String, dynamic>) {
      return UtilityDetails(
        lastServiceDate: _parseApiDate(value['last_service']),
        notes: value['notes'] as String?,
      );
    }
    return UtilityDetails();
  }

  static DateTime? _parseApiDate(dynamic value) {
    if (value == null) return null;

    // MM/DD/YYYY
    if (value is String && value.contains('/')) {
      final parts = value.split('/');
      if (parts.length == 3) {
        final month = int.tryParse(parts[0]);
        final day = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);
        if (month != null && day != null && year != null) {
          return DateTime(year, month, day);
        }
      }
    }

    // ISO string
    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }
}
