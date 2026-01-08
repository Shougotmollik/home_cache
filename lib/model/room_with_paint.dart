
class RoomWithPaint {
  final String id;
  final String name;
  final String itemId;
  final String roomType;
  final int number;

  RoomWithPaint({
    required this.id,
    required this.name,
    required this.itemId,
    required this.roomType,
    required this.number,
  });

  factory RoomWithPaint.fromJson(Map<String, dynamic> json) {
    return RoomWithPaint(
      id: json['id'] as String,
      name: json['name'] as String,
      itemId: json['item_id'] as String,
      roomType: json['room_type'] as String,
      number: json['number'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'item_id': itemId,
      'room_type': roomType,
      'number': number,
    };
  }
}
