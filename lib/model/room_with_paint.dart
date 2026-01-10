class RoomWithPaint {
  final List<UserRoom> userRooms;
  final String itemId;

  RoomWithPaint({
    required this.userRooms,
    required this.itemId,
  });

  factory RoomWithPaint.fromJson(Map<String, dynamic> json) {
    return RoomWithPaint(
      userRooms: (json['user_rooms'] as List)
          .map((e) => UserRoom.fromJson(e))
          .toList(),
      itemId: json['item_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_rooms': userRooms.map((e) => e.toJson()).toList(),
      'item_id': itemId,
    };
  }
}

// User room model
class UserRoom {
  final String id;
  final String name;
  final String roomType;
  final int number;

  UserRoom({
    required this.id,
    required this.name,
    required this.roomType,
    required this.number,
  });

  factory UserRoom.fromJson(Map<String, dynamic> json) {
    return UserRoom(
      id: json['id'],
      name: json['name'],
      roomType: json['room_type'],
      number: json['number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'room_type': roomType,
      'number': number,
    };
  }
}
