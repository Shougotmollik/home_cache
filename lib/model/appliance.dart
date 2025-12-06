class Appliance {
  final String id;
  final String userApplianceId;
  final String roomId;
  final Details details;
  final String? image;
  final String? imageId;
  final List<ApplianceFile> files;

  Appliance({
    required this.id,
    required this.userApplianceId,
    required this.roomId,
    required this.details,
    this.image,
    this.imageId,
    required this.files,
  });

  factory Appliance.fromJson(Map<String, dynamic> json) {
    return Appliance(
      id: json['id'] ?? "",
      userApplianceId: json['user_appliance_id'] ?? "",
      roomId: json['room_id'] ?? "",
      details: Details.fromJson(json['details'] ?? {}),
      image: json['image'],
      imageId: json['image_id'],
      files: (json['files'] != null)
          ? (json['files'] as List)
              .map((x) => ApplianceFile.fromJson(x))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_appliance_id': userApplianceId,
      'room_id': roomId,
      'details': details.toJson(),
      'image': image,
      'image_id': imageId,
      'files': files.map((x) => x.toJson()).toList(),
    };
  }
}

class Details {
  final String? brand; // nullable
  final String? model; // nullable
  final int? warrantyYears; // nullable

  Details({
    this.brand,
    this.model,
    this.warrantyYears,
  });

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      brand: json['brand'],
      model: json['model'],
      warrantyYears: json['warranty_years'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'model': model,
      'warranty_years': warrantyYears,
    };
  }
}

class ApplianceFile {
  final String? file;
  final String? fileId;

  ApplianceFile({
    required this.file,
    required this.fileId,
  });

  factory ApplianceFile.fromJson(Map<String, dynamic> json) {
    return ApplianceFile(
      file: json['file'] ?? "",
      fileId: json['file_id'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'file': file,
      'file_id': fileId,
    };
  }
}
