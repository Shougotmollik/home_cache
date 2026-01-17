class UtilityComponent {
  final String id;
  final String typeId;
  final String name;

  UtilityComponent({
    required this.id,
    required this.typeId,
    required this.name,
  });

  factory UtilityComponent.fromJson(Map<String, dynamic> json) {
    return UtilityComponent(
      id: json['id'] ?? '',
      typeId: json['type_id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type_id': typeId,
      'name': name,
    };
  }
}
