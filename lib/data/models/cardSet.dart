class CardSet {
  final String id;
  final String name;
  final String series;

  CardSet({
    required this.id,
    required this.name,
    required this.series,
  });

  factory CardSet.fromJson(Map<String, dynamic> json) {
    return CardSet(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      series: json['series'] ?? '',
    );
  }
}
