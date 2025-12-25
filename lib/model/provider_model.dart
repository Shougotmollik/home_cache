class Provider {
  final String id;
  final String type;
  final String company;
  final String name;
  final String mobile;
  final String webUrl;
  final List<Document> documents;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final String? deletedAt;
  final String rating;
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
    required this.isFollowed,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json["id"] ?? json["provider_id"] ?? "",
      type: json["type"] ?? "",
      company: json["company"] ?? "",
      name: json["name"] ?? "Unknown",
      mobile: json["mobile"] ?? "",
      webUrl: json["web_url"] ?? "",
      documents: json["documents"] != null
          ? (json["documents"] as List)
              .map((doc) => Document.fromJson(doc))
              .toList()
          : [],
      updatedAt: json["updated_at"] != null
          ? DateTime.parse(json["updated_at"])
          : null,
      createdAt: json["created_at"] != null
          ? DateTime.parse(json["created_at"])
          : null,
      deletedAt: json["deleted_at"],
      rating: json["rating"] != null ? json["rating"].toString() : "0.00",
      isFollowed: json["is_followed"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type": type,
      "company": company,
      "name": name,
      "mobile": mobile,
      "web_url": webUrl,
      "documents": documents.map((doc) => doc.toJson()).toList(),
      "updated_at": updatedAt?.toIso8601String(),
      "created_at": createdAt?.toIso8601String(),
      "deleted_at": deletedAt,
      "rating": rating,
      "is_followed": isFollowed,
    };
  }

  @override
  String toString() {
    return 'Provider(id: $id, name: $name, isFollowed: $isFollowed, rating: $rating)';
  }
}

// Document Model
class Document {
  final String url;
  final String fileId;

  Document({
    required this.url,
    required this.fileId,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      url: json['url'] ?? '',
      fileId: json['file_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'file_id': fileId,
    };
  }

  // Get filename from URL
  String get fileName {
    try {
      return url.split('/').last.replaceAll('%20', ' ');
    } catch (e) {
      return fileId.split('/').last;
    }
  }
}

// Appointment Model
class Appointment {
  final String title;
  final String date;

  Appointment({
    required this.title,
    required this.date,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      title: json['title'] ?? 'Untitled',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
    };
  }

  // Formatted date for display
  String get formattedDate {
    try {
      final dateTime = DateTime.parse(date);
      return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    } catch (e) {
      return date;
    }
  }

  // Formatted time for display
  String get formattedTime {
    try {
      final dateTime = DateTime.parse(date);
      final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
      final period = dateTime.hour >= 12 ? 'PM' : 'AM';
      return "$hour:${dateTime.minute.toString().padLeft(2, '0')} $period";
    } catch (e) {
      return '';
    }
  }
}