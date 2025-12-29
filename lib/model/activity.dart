class Activity {
  final String id;
  final String title;
  final String message;
  final String homeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Activity({
    required this.id,
    required this.title,
    required this.message,
    required this.homeId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      homeId: json['home_id'] as String,
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
      'title': title,
      'message': message,
      'home_id': homeId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
