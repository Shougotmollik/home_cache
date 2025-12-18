class MaterialDetailsModel {
  final String id;
  final String userMaterialId;
  final String roomId;
  final MaterialDetails details;
  final String image;
  final String imageId;
  final List<MaterialFile> files;
  final UserMaterial userMaterial;
  final Room room;

  MaterialDetailsModel({
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

  factory MaterialDetailsModel.fromJson(Map<String, dynamic> json) {
    return MaterialDetailsModel(
      id: json['id'],
      userMaterialId: json['user_material_id'],
      roomId: json['room_id'],
      details: MaterialDetails.fromJson(json['details'] ?? {}),
      image: json['image'] ?? '',
      imageId: json['image_id'] ?? '',
      files: (json['files'] as List? ?? [])
          .map((e) => MaterialFile.fromJson(e))
          .toList(),
      userMaterial: UserMaterial.fromJson(json['user_material']),
      room: Room.fromJson(json['room']),
    );
  }
}

class MaterialDetails {
  final String note;
  final String? type;
  final String? brand;
  final String? material;
  final String? shutoffLocation;
  final DateTime? lastServiceDate;
  final DateTime? lastFieldDate;

  MaterialDetails({
    required this.note,
    this.type,
    this.brand,
    this.material,
    this.shutoffLocation,
    this.lastServiceDate,
    this.lastFieldDate,
  });

  factory MaterialDetails.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? value) {
      if (value == null || value.isEmpty) return null;
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null; // ignore invalid date formats
      }
    }

    return MaterialDetails(
      note: json['note'] ?? '',
      type: json['type'],
      brand: json['brand'],
      material: json['material'],
      shutoffLocation: json['shutoff_locaton'], // backend typo
      lastServiceDate: parseDate(json['last_date_service']),
      lastFieldDate: parseDate(json['last_field_date:']), // backend typo
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
      file: json['file'],
      fileId: json['file_id'],
      uploadAt: DateTime.parse(json['upload_at']),
    );
  }
}

class UserMaterial {
  final MaterialInfo material;

  UserMaterial({required this.material});

  factory UserMaterial.fromJson(Map<String, dynamic> json) {
    return UserMaterial(
      material: MaterialInfo.fromJson(json['material']),
    );
  }
}

class MaterialInfo {
  final String id;
  final String name;

  MaterialInfo({required this.id, required this.name});

  factory MaterialInfo.fromJson(Map<String, dynamic> json) {
    return MaterialInfo(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Room {
  final String id;
  final String name;

  Room({required this.id, required this.name});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
    );
  }
}
