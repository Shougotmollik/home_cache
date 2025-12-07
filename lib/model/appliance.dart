class ApplianceModel {
  final String id;
  final String userApplianceId;
  final String roomId;
  final Map<String, dynamic> details;
  final String image;
  final String imageId;
  final List<ApplianceFile> files;
  final ApplianceUserAppliance userAppliance;
  final ApplianceRoom room;

  ApplianceModel({
    required this.id,
    required this.userApplianceId,
    required this.roomId,
    required this.details,
    required this.image,
    required this.imageId,
    required this.files,
    required this.userAppliance,
    required this.room,
  });

  factory ApplianceModel.fromJson(Map<String, dynamic> json) {
    return ApplianceModel(
      id: json["id"] ?? "",
      userApplianceId: json["user_appliance_id"] ?? "",
      roomId: json["room_id"] ?? "",
      details: json["details"] ?? {},
      image: json["image"] ?? "",
      imageId: json["image_id"] ?? "",
      files: json["files"] != null
          ? List<ApplianceFile>.from(
              json["files"].map((x) => ApplianceFile.fromJson(x)))
          : [],
      userAppliance: ApplianceUserAppliance.fromJson(json["user_appliance"]),
      room: ApplianceRoom.fromJson(json["room"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_appliance_id": userApplianceId,
        "room_id": roomId,
        "details": details,
        "image": image,
        "image_id": imageId,
        "files": List<dynamic>.from(files.map((x) => x.toJson())),
        "user_appliance": userAppliance.toJson(),
        "room": room.toJson(),
      };
}

class ApplianceFile {
  final String file;
  final String fileId;

  ApplianceFile({
    required this.file,
    required this.fileId,
  });

  factory ApplianceFile.fromJson(Map<String, dynamic> json) => ApplianceFile(
        file: json["file"] ?? "",
        fileId: json["file_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "file": file,
        "file_id": fileId,
      };
}

class ApplianceUserAppliance {
  final Appliance appliance;

  ApplianceUserAppliance({required this.appliance});

  factory ApplianceUserAppliance.fromJson(Map<String, dynamic> json) =>
      ApplianceUserAppliance(
        appliance: Appliance.fromJson(json["appliance"]),
      );

  Map<String, dynamic> toJson() => {
        "appliance": appliance.toJson(),
      };
}

class Appliance {
  final String id;
  final String name;

  Appliance({
    required this.id,
    required this.name,
  });

  factory Appliance.fromJson(Map<String, dynamic> json) => Appliance(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class ApplianceRoom {
  final String id;
  final String name;

  ApplianceRoom({
    required this.id,
    required this.name,
  });

  factory ApplianceRoom.fromJson(Map<String, dynamic> json) => ApplianceRoom(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
