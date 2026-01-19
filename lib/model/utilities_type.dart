class UtilityTypeData {
  final String id;
  final UtilityType utilityType;

  UtilityTypeData({
    required this.id,
    required this.utilityType,
  });

  factory UtilityTypeData.fromJson(Map<String, dynamic> json) {
    return UtilityTypeData(
      id: json['id'] ?? '',
      utilityType: UtilityType.fromJson(json['utility_type'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'utility_type': utilityType.toJson(),
    };
  }
}

class UtilityType {
  final String name;

  UtilityType({
    required this.name,
  });

  factory UtilityType.fromJson(Map<String, dynamic> json) {
    return UtilityType(
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
