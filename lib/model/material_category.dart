class MaterialCategory {
  final int amount;
  final String material;
  final String materialId;
  final String id;

  MaterialCategory({
    required this.amount,
    required this.material,
    required this.materialId,
    required this.id,
  });

  factory MaterialCategory.fromJson(Map<String, dynamic> json) {
    return MaterialCategory(
      amount: json['amount'] as int,
      material: json['material'] as String,
      materialId: json['material_id'] as String,
      id: json['id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'material': material,
      'material_id': materialId,
      'id': id,
    };
  }
}
