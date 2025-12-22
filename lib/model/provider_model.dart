class Provider {
  final String id;
  final String type;
  final String company;
  final String name;
  final String mobile;
  final String webUrl;
  final List<dynamic> documents;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final String? deletedAt;
  final String rating;
  final String? lastServiceDate;
  bool isFollowed;

  Provider({
    required this.id,
    required this.type,
    required this.company,
    required this.name,
    required this.mobile,
    required this.webUrl,
    required this.documents,
    this.updatedAt,
    this.createdAt,
    this.deletedAt,
    required this.rating,
    this.lastServiceDate,
    required this.isFollowed,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json["provider_id"] ?? "",
      type: json["type"] ?? "",
      company: json["company"] ?? "",
      name: json["name"] ?? "Unknown",
      mobile: json["mobile"] ?? "",
      webUrl: json["web_url"] ?? "",
      documents: json["documents"] ?? [],
      updatedAt: json["updated_at"] != null
          ? DateTime.parse(json["updated_at"])
          : null,
      createdAt: json["created_at"] != null
          ? DateTime.parse(json["created_at"])
          : null,
      deletedAt: json["deleted_at"],
      rating: json["rating"] != null ? json["rating"].toString() : "0.00",
      lastServiceDate: json["last_service_date"],
      isFollowed: json["is_followed"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "provider_id": id,
      "type": type,
      "company": company,
      "name": name,
      "mobile": mobile,
      "web_url": webUrl,
      "documents": documents,
      "updated_at": updatedAt?.toIso8601String(),
      "created_at": createdAt?.toIso8601String(),
      "deleted_at": deletedAt,
      "rating": rating,
      "last_service_date": lastServiceDate,
      "is_followed": isFollowed,
    };
  }

  @override
  String toString() {
    return 'Provider(id: $id, name: $name, isFollowed: $isFollowed, rating: $rating, lastServiceDate: $lastServiceDate)';
  }
}
