class CardImages {
  final String small;
  final String large;

  CardImages({
    required this.small,
    required this.large,
  });

  factory CardImages.fromJson(Map<String, dynamic> json) {
    return CardImages(
      small: json['small'] ?? '',
      large: json['large'] ?? '',
    );
  }
}