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
      id: json['id'] as String? ?? '', // fallback if null
      utilityItem: json['utility_item'] != null
          ? UtilityItem.fromJson(json['utility_item'])
          : UtilityItem(name: ''), // fallback empty
      details: json['details'] != null
          ? UtilityDetails.fromJson(json['details'])
          : UtilityDetails(), // empty fallback
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'utility_item': utilityItem.toJson(),
      'details': details.toJson(),
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
    return {
      'name': name,
    };
  }
}

class UtilityDetails {
  final DateTime? lastServiceDate;
  final String? notes;

  UtilityDetails({this.lastServiceDate, this.notes});

  factory UtilityDetails.fromJson(Map<String, dynamic>? json) {
    if (json == null) return UtilityDetails(); // safe fallback

    return UtilityDetails(
      lastServiceDate: json['last_service'] != null
          ? DateTime.tryParse(json['last_service'])
          : null,
      notes: json['notes'] as String?, // allow null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'last_service': lastServiceDate?.toIso8601String(),
      'notes': notes,
    };
  }
}
