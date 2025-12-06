class ViewByType {
  final String id;
  final String image;
  final String type;

  ViewByType({
    required this.id,
    required this.image,
    required this.type,
  });

  factory ViewByType.fromJson(Map<String, dynamic> json) {
    return ViewByType(
      id: json['id'],
      image: json['image'],
      type: json['type'],
    );
  }
}