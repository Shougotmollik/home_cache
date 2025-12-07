class ApplianceDetailsModel {
  final String? id;
  final String? userApplianceId;
  final String? roomId;
  final Details? details;
  final String? image;
  final String? imageId;
  final List<ApplianceFile>? files;
  final UserAppliance? userAppliance;
  final Room? room;

  ApplianceDetailsModel({
    this.id,
    this.userApplianceId,
    this.roomId,
    this.details,
    this.image,
    this.imageId,
    this.files,
    this.userAppliance,
    this.room,
  });

  factory ApplianceDetailsModel.fromJson(Map<String, dynamic> json) {
    return ApplianceDetailsModel(
      id: json['id'],
      userApplianceId: json['user_appliance_id'],
      roomId: json['room_id'],
      details:
          json['details'] != null ? Details.fromJson(json['details']) : null,
      image: json['image'],
      imageId: json['image_id'],
      files: json['files'] != null
          ? (json['files'] as List)
              .map((e) => ApplianceFile.fromJson(e))
              .toList()
          : [],
      userAppliance: json['user_appliance'] != null
          ? UserAppliance.fromJson(json['user_appliance'])
          : null,
      room: json['room'] != null ? Room.fromJson(json['room']) : null,
    );
  }
}

class Details {
  final String? brand;
  final String? model;
  final int? warrantyYears;
  final String? notes;

  Details({this.brand, this.model, this.warrantyYears, this.notes});

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      brand: json['brand'],
      model: json['model'],
      warrantyYears: json['warranty_years'],
      notes: json['notes'],
    );
  }
}

class ApplianceFile {
  final String? file;
  final String? fileId;
  final String? updatedAt;

  ApplianceFile({this.file, this.fileId, this.updatedAt});

  factory ApplianceFile.fromJson(Map<String, dynamic> json) {
    return ApplianceFile(
      file: json['file'],
      fileId: json['file_id'],
      updatedAt: json['updated_at'],
    );
  }
}

class UserAppliance {
  final Appliance? appliance;

  UserAppliance({this.appliance});

  factory UserAppliance.fromJson(Map<String, dynamic> json) {
    return UserAppliance(
      appliance: json['appliance'] != null
          ? Appliance.fromJson(json['appliance'])
          : null,
    );
  }
}

class Appliance {
  final String? id;
  final String? name;

  Appliance({this.id, this.name});

  factory Appliance.fromJson(Map<String, dynamic> json) {
    return Appliance(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Room {
  final String? id;
  final String? name;

  Room({this.id, this.name});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
    );
  }
}
