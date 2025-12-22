class ScheduleModel {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime? initialDate;
  final dynamic assignments;
  final bool isLinked;

  ScheduleModel({
    required this.id,
    required this.title,
    required this.createdAt,
    this.assignments,
    required this.isLinked,
    this.initialDate,

  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      initialDate: DateTime.parse(json['initial_date']),
      assignments: json['assignments'],
      isLinked: json['is_linked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'created_at': createdAt.toIso8601String(),
        'initial_date': initialDate?.toIso8601String(),
        'assignments': assignments,
        'is_linked': isLinked,
      };
}
