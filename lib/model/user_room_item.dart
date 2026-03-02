class UserRoomItemResponse {
  final bool success;
  final String message;
  final int statusCode;
  final List<UserRoomItem> data;

  UserRoomItemResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory UserRoomItemResponse.fromJson(Map<String, dynamic> json) {
    return UserRoomItemResponse(
      success: json['success'],
      message: json['message'],
      statusCode: json['status_code'],
      data: (json['data'] as List)
          .map((item) => UserRoomItem.fromJson(item))
          .toList(),
    );
  }
}

class UserRoomItem {
  final String id;
  final String userRoomItemId;
  final String? image;
  final String? imageId;
  // Dynamic Map handles all item types (Paint, Tile, Lighting, etc.)
  final Map<String, dynamic> details;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  UserRoomItem({
    required this.id,
    required this.userRoomItemId,
    this.image,
    this.imageId,
    required this.details,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory UserRoomItem.fromJson(Map<String, dynamic> json) {
    return UserRoomItem(
      id: json['id']?.toString() ?? '',
      userRoomItemId: json['user_room_item_id']?.toString() ?? '',
      image: json['image'],
      imageId: json['image_id'],
      // Logic: If details exists, use it. If not, use empty map {}.
      details: (json['details'] is Map)
          ? Map<String, dynamic>.from(json['details'])
          : {},
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }
}

class Details {
  final String type;
  final String brand;
  final String color;
  final String finish;
  final String location;
  final String brandLine;
  final String lastPainted;

  Details({
    required this.type,
    required this.brand,
    required this.color,
    required this.finish,
    required this.location,
    required this.brandLine,
    required this.lastPainted,
  });

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      type: json['type'],
      brand: json['brand'],
      color: json['color'],
      finish: json['finish'],
      location: json['location'],
      brandLine: json['brand_line'],
      lastPainted: json['last_painted'],
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'brand': brand,
        'color': color,
        'finish': finish,
        'location': location,
        'brand_line': brandLine,
        'last_painted': lastPainted,
      };
}
