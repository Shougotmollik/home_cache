class ApplianceType {
  final String id;
  final String typeId;
  final String name;
  final String updatedAt;
  final String createdAt;
  final String? deletedAt;

  ApplianceType({
    required this.id,
    required this.typeId,
    required this.name,
    required this.updatedAt,
    required this.createdAt,
    this.deletedAt,
  });

  factory ApplianceType.fromJson(Map<String, dynamic> json) {
    return ApplianceType(
      id: json['id'],
      typeId: json['type_id'],
      name: json['name'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type_id': typeId,
      'name': name,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'deleted_at': deletedAt,
    };
  }
}
