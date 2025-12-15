class MaterialType {
  final String id;
  final String typeId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  MaterialType({
    required this.id,
    required this.typeId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory MaterialType.fromJson(Map<String, dynamic> json) {
    return MaterialType(
      id: json['id'] as String,
      typeId: json['type_id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type_id': typeId,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
