// Data Wrapper
class TaskDetailsModel {
  final TaskData taskData;
  final LastServiceBy? lastServiceBy;
  final PresentAssignTo? presentAssignTo;

  TaskDetailsModel({
    required this.taskData,
    this.lastServiceBy,
    this.presentAssignTo,
  });

  factory TaskDetailsModel.fromJson(Map<String, dynamic> json) {
    return TaskDetailsModel(
      taskData: TaskData.fromJson(json['task_data']),
      lastServiceBy: json['last_service_by'] != null
          ? LastServiceBy.fromJson(json['last_service_by'])
          : null,
      presentAssignTo: json['present_assign_to'] != null
          ? PresentAssignTo.fromJson(json['present_assign_to'])
          : null,
    );
  }
}

// Task Model
class TaskData {
  final String id;
  final String createdBy;
  final String title;
  final String description;
  final DateTime initialDate;
  final String recurrenceType;

  TaskData({
    required this.id,
    required this.createdBy,
    required this.title,
    required this.description,
    required this.initialDate,
    required this.recurrenceType,
  });

  factory TaskData.fromJson(Map<String, dynamic> json) {
    return TaskData(
      id: json['id'],
      createdBy: json['created_by'],
      title: json['title'],
      description: json['description'],
      initialDate: DateTime.parse(json['initial_date']),
      recurrenceType: json['recurrence_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_by': createdBy,
      'title': title,
      'description': description,
      'initial_date': initialDate.toIso8601String(),
      'recurrence_type': recurrenceType,
    };
  }
}

// Last Service Model
class LastServiceBy {
  final String name;
  final DateTime date;
  final String userType;
  final String userId;
  final double? avgRating;
  final String userRole;

  LastServiceBy({
    required this.name,
    required this.date,
    required this.userType,
    required this.userId,
    required this.userRole,
    this.avgRating,
  });

  factory LastServiceBy.fromJson(Map<String, dynamic> json) {
    return LastServiceBy(
      name: json['name'],
      date: DateTime.parse(json['date']),
      userType: json['user_type'],
      userId: json['user_id'],
      avgRating: json['avg_rating']?.toDouble(),
      userRole: json['user_role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': date.toIso8601String(),
      'user_type': userType,
      'user_id': userId,
      'avg_rating': avgRating,
      'user_role': userRole,
    };
  }
}

// Present Assignment Model
class PresentAssignTo {
  final DateTime date;
  final String taskAssignId;
  final Assignee assignee;

  PresentAssignTo({
    required this.date,
    required this.taskAssignId,
    required this.assignee,
  });

  factory PresentAssignTo.fromJson(Map<String, dynamic> json) {
    return PresentAssignTo(
      date: DateTime.parse(json['date']),
      taskAssignId: json['task_assign_id'],
      assignee: Assignee.fromJson(json['assignee']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'task_assign_id': taskAssignId,
      'assignee': assignee.toJson(),
    };
  }
}

// Assignee Model
class Assignee {
  final String name;
  final String assigneeId;
  final String userType;
  final String userRole;

  Assignee({
    required this.name,
    required this.assigneeId,
    required this.userType,
    required this.userRole,
  });

  factory Assignee.fromJson(Map<String, dynamic> json) {
    return Assignee(
      name: json['name'],
      assigneeId: json['assignee_id'],
      userType: json['user_type'],
      userRole: json['user_role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'assignee_id': assigneeId,
      'user_type': userType,
      'user_role': userRole,
    };
  }
}
