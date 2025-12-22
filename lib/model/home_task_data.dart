

class HomeTaskHealth {
  final Tasks tasks;
  final HomeHealth homeHealth;
  final MyData myData;

  HomeTaskHealth({
    required this.tasks,
    required this.homeHealth,
    required this.myData,
  });

  factory HomeTaskHealth.fromJson(Map<String, dynamic> json) {
    return HomeTaskHealth(
      tasks: Tasks.fromJson(json['tasks'] ?? {}),
      homeHealth: HomeHealth.fromJson(json['home_health'] ?? {}),
      myData: MyData.fromJson(json['my_data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'tasks': tasks.toJson(),
        'home_health': homeHealth.toJson(),
        'my_data': myData.toJson(),
      };
}

class Tasks {
  final Season season;
  final List<dynamic> overdue;
  final List<dynamic> upcoming;
  final List<dynamic> completed;

  Tasks({
    required this.season,
    required this.overdue,
    required this.upcoming,
    required this.completed,
  });

  factory Tasks.fromJson(Map<String, dynamic> json) {
    return Tasks(
      season: Season.fromJson(json['season'] ?? {}),
      overdue: json['overdue'] ?? [],
      upcoming: json['upcoming'] ?? [],
      completed: json['completed'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'season': season.toJson(),
        'overdue': overdue,
        'upcoming': upcoming,
        'completed': completed,
      };
}

class Season {
  final DateTime start;
  final DateTime end;

  Season({
    required this.start,
    required this.end,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      start: DateTime.parse(json['start'] ?? DateTime.now().toIso8601String()),
      end: DateTime.parse(json['end'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
      };
}

class HomeHealth {
  final int health;
  final int totalTasks;
  final int completedTasks;

  HomeHealth({
    required this.health,
    required this.totalTasks,
    required this.completedTasks,
  });

  factory HomeHealth.fromJson(Map<String, dynamic> json) {
    return HomeHealth(
      health: json['health'] ?? 0,
      totalTasks: json['totalTasks'] ?? 0,
      completedTasks: json['completedTasks'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'health': health,
        'totalTasks': totalTasks,
        'completedTasks': completedTasks,
      };
}

class MyData {
  final int completed;
  final int pending;

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

  Map<String, dynamic> toJson() => {
        'completed': completed,
        'pending': pending,
      };
}
