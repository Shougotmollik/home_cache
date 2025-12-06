class ApplianceCategory {
  final int amount;
  final String appliance;
  final String applianceId;
  final String id;

  ApplianceCategory({
    required this.amount,
    required this.appliance,
    required this.applianceId,
    required this.id,
  });

  factory ApplianceCategory.fromJson(Map<String, dynamic> json) {
    return ApplianceCategory(
      amount: json['amount'],
      appliance: json['appliance'],
      applianceId: json['appliance_id'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'appliance': appliance,
      'appliance_id': applianceId,
      'id': id,
    };
  }
}