class Attack {
  final String name;
  final List<String> cost;
  final String damage;
  final String text;

  Attack({
    required this.name,
    required this.cost,
    required this.damage,
    required this.text,
  });

  factory Attack.fromJson(Map<String, dynamic> json) {
    return Attack(
      name: json['name'] ?? '',
      cost: List<String>.from(json['cost'] ?? []),
      damage: json['damage'] ?? '',
      text: json['text'] ?? '',
    );
  }
}