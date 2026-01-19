class UtilitySingleDataDetails {
  final String id;
  final String userUtilityId;
  final String utilityItemId;
  final UtilityDetail details;
  final String image;
  final String imageId;
  final List<dynamic> files;
  final DateTime updatedAt;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final UserUtility userUtility;

  UtilitySingleDataDetails({
    required this.id,
    required this.userUtilityId,
    required this.utilityItemId,
    required this.details,
    required this.image,
    required this.imageId,
    required this.files,
    required this.updatedAt,
    required this.createdAt,
    this.deletedAt,
    required this.userUtility,
  });

  factory UtilitySingleDataDetails.fromJson(Map<String, dynamic> json) {
    return UtilitySingleDataDetails(
      id: json['id'] as String,
      userUtilityId: json['user_utility_id'] as String,
      utilityItemId: json['utility_item_id'] as String,
      details: UtilityDetail.fromJson(json['details'] as Map<String, dynamic>),
      image: json['image'] as String,
      imageId: json['image_id'] as String,
      files: json['files'] as List<dynamic>,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      userUtility:
          UserUtility.fromJson(json['user_utility'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_utility_id': userUtilityId,
      'utility_item_id': utilityItemId,
      'details': details.toJson(),
      'image': image,
      'image_id': imageId,
      'files': files,
      'updated_at': updatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'user_utility': userUtility.toJson(),
    };
  }
}

class UtilityDetail {
  final String field;

  UtilityDetail({required this.field});

  factory UtilityDetail.fromJson(Map<String, dynamic> json) {
    return UtilityDetail(
      field: json['field'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'field': field,
    };
  }
}

class UserUtility {
  final UtilityType utilityType;

  UserUtility({required this.utilityType});

  factory UserUtility.fromJson(Map<String, dynamic> json) {
    return UserUtility(
      utilityType:
          UtilityType.fromJson(json['utility_type'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'utility_type': utilityType.toJson(),
    };
  }
}

class UtilityType {
  final String name;

  UtilityType({required this.name});

  factory UtilityType.fromJson(Map<String, dynamic> json) {
    return UtilityType(
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
