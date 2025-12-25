class TaskNotification {
  final String taskId;
  final String title;
  final String description;
  final DateTime date;
  final String userType;
  final String createdBy;
  final DateTime? lastCompletedDate;
  final String assignTo;
  final String taskAssignId;
  final bool isOverdue;

  TaskNotification({
    required this.taskId,
    required this.title,
    required this.description,
    required this.date,
    required this.userType,
    required this.createdBy,
    this.lastCompletedDate,
    required this.assignTo,
    required this.taskAssignId,
    required this.isOverdue,
  });

  factory TaskNotification.fromJson(Map<String, dynamic> json) {
    return TaskNotification(
      taskId: json['task_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date']),
      userType: json['user_type'] as String,
      createdBy: json['created_by'] as String,
      lastCompletedDate: json['last_completed_date'] != null
          ? DateTime.parse(json['last_completed_date'])
          : null,
      assignTo: json['assign_to'] as String,
      taskAssignId: json['task_assign_id'] as String,
      isOverdue: json['is_overdue'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task_id': taskId,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'user_type': userType,
      'created_by': createdBy,
      'last_completed_date': lastCompletedDate?.toIso8601String(),
      'assign_to': assignTo,
      'task_assign_id': taskAssignId,
      'is_overdue': isOverdue,
    };
  }
}
