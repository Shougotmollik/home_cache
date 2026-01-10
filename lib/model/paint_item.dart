import 'package:home_cache/config/helper/time_date_parser.dart';
import 'package:intl/intl.dart';

class PaintItem {
  final String id;
  final PaintItemDetails details;

  PaintItem({
    required this.id,
    required this.details,
  });

  factory PaintItem.fromJson(Map<String, dynamic> json) {
    return PaintItem(
      id: json['id'] as String,
      details: PaintItemDetails.fromJson(json['details']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'details': details.toJson(),
    };
  }
}

class PaintItemDetails {
  final String type;
  final String brand;
  final String color;
  final String finish;
  final String location;
  final String brandLine;
  final DateTime? lastPainted;

  PaintItemDetails({
    required this.type,
    required this.brand,
    required this.color,
    required this.finish,
    required this.location,
    required this.brandLine,
    required this.lastPainted,
  });

  factory PaintItemDetails.fromJson(Map<String, dynamic> json) {
    return PaintItemDetails(
      type: json['type'] as String,
      brand: json['brand'] as String,
      color: json['color'] as String,
      finish: json['finish'] as String,
      location: json['location'] as String,
      brandLine: json['brand_line'] as String,
      lastPainted: timeDateParser(json['last_painted']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'brand': brand,
      'color': color,
      'finish': finish,
      'location': location,
      'brand_line': brandLine,
      'last_painted': lastPainted != null
          ? DateFormat('yyyy-MM-dd').format(lastPainted!)
          : null,
    };
  }
}
