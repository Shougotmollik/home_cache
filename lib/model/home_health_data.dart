class HomeHealthModel {
  final double health;
  final int totalTasks;
  final int completedTasks;

  HomeHealthModel({
    required this.health,
    required this.totalTasks,
    required this.completedTasks,
  });

  factory HomeHealthModel.fromJson(Map<String, dynamic> json) {
    return HomeHealthModel(
      health: json['health'] ?? 0,
      totalTasks: json['totalTasks'] ?? 0,
      completedTasks: json['completedTasks'] ?? 0,
    );
  }
}

class MyData {
  final double completed;
  final double pending;

  MyData({
    required this.completed,
    required this.pending,
  });

  factory MyData.fromJson(Map<String, dynamic> json) {
    return MyData(
      completed: json['completed'] ?? 0,
      pending: json['pending'] ?? 0,
    );
  }
}
