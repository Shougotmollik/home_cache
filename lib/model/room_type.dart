class RoomTypeModel {
  final String id;
  final String type;
  final String image;
  final String imageId;

  RoomTypeModel({
    required this.id,
    required this.type,
    required this.image,
    required this.imageId,
  });

  factory RoomTypeModel.fromJson(Map<String, dynamic> json) {
    return RoomTypeModel(
      id: json['id']?.toString() ?? '',
      type: json['type'] ?? '',
      image: json['image'] ?? '',
      imageId: json['image_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'image': image,
      'image_id': imageId,
    };
  }

  @override
  String toString() {
    return 'RoomTypeModel{id: $id, type: $type, image: $image, imageId: $imageId}';
  }
}
