class TypeMaterialOption {
  final String id;
  final String typeMaterialId;
  final List<String> type;
  final List<String> material;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  TypeMaterialOption({
    required this.id,
    required this.typeMaterialId,
    required this.type,
    required this.material,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory TypeMaterialOption.fromJson(Map<String, dynamic> json) {
    return TypeMaterialOption(
      id: json['id'] ?? '',
      typeMaterialId: json['type_material_id'] ?? '',
      type: json['type'] != null ? List<String>.from(json['type']) : [],
      material:
          json['material'] != null ? List<String>.from(json['material']) : [],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }
}
