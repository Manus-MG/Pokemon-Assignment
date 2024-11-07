class Weakness {
  final String type;
  final String value;

  Weakness({
    required this.type,
    required this.value,
  });

  factory Weakness.fromJson(Map<String, dynamic> json) {
    return Weakness(
      type: json['type'] ?? '',
      value: json['value'] ?? '',
    );
  }
}