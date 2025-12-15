class MaterialModel {
  final String id;
  final String userMaterialId;
  final String roomId;
  final Map<String, dynamic> details;
  final String image;
  final String imageId;
  final List<MaterialFile> files;
  final UserMaterial userMaterial;
  final Room room;

  MaterialModel({
    required this.id,
    required this.userMaterialId,
    required this.roomId,
    required this.details,
    required this.image,
    required this.imageId,
    required this.files,
    required this.userMaterial,
    required this.room,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'] ?? '',
      userMaterialId: json['user_material_id'] ?? '',
      roomId: json['room_id'] ?? '',
      details: json['details'] ?? {},
      image: json['image'] ?? '',
      imageId: json['image_id'] ?? '',
      files: (json['files'] as List<dynamic>? ?? [])
          .map((e) => MaterialFile.fromJson(e))
          .toList(),
      userMaterial: UserMaterial.fromJson(json['user_material'] ?? {}),
      room: Room.fromJson(json['room'] ?? {}),
    );
  }
}
class MaterialFile {
  final String file;
  final String fileId;
  final DateTime uploadAt;

  MaterialFile({
    required this.file,
    required this.fileId,
    required this.uploadAt,
  });

  factory MaterialFile.fromJson(Map<String, dynamic> json) {
    return MaterialFile(
      file: json['file'] ?? '',
      fileId: json['file_id'] ?? '',
      uploadAt: DateTime.tryParse(json['upload_at'] ?? '') ?? DateTime.now(),
    );
  }
}
class UserMaterial {
  final MaterialInfo material;

  UserMaterial({
    required this.material,
  });

  factory UserMaterial.fromJson(Map<String, dynamic> json) {
    return UserMaterial(
      material: MaterialInfo.fromJson(json['material'] ?? {}),
    );
  }
}

class MaterialInfo {
  final String id;
  final String name;

  MaterialInfo({
    required this.id,
    required this.name,
  });

  factory MaterialInfo.fromJson(Map<String, dynamic> json) {
    return MaterialInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
class Room {
  final String id;
  final String name;

  Room({
    required this.id,
    required this.name,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
