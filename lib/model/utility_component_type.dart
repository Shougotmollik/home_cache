class UtilityComponentType {
  final String id;
  final String typeUtilityId;
  final String name;

  UtilityComponentType({
    required this.id,
    required this.typeUtilityId,
    required this.name,
  });

  factory UtilityComponentType.fromJson(Map<String, dynamic> json) {
    return UtilityComponentType(
      id: json['id'] as String,
      typeUtilityId: json['type_utility_id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type_utility_id': typeUtilityId,
      'name': name,
    };
  }
}
