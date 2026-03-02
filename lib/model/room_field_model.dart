class RoomField {
  final bool success;
  final String item;
  final List<Field> fields;

  RoomField({
    required this.success,
    required this.item,
    required this.fields,
  });

  factory RoomField.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = json['data'] ?? json;

    return RoomField(
      success: data['success'] ?? false,
      item: data['item'] ?? '',
      fields:
          (data['fields'] as List?)?.map((f) => Field.fromJson(f)).toList() ??
              [],
    );
  }
}

class Field {
  final String field;
  final String type;
  final List<String>? values;

  Field({
    required this.field,
    required this.type,
    this.values,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      field: json['field'] ?? '',
      type: json['type'] ?? '',
      // Handles the null check for the "values" list
      values: json['values'] != null ? List<String>.from(json['values']) : null,
    );
  }
}
