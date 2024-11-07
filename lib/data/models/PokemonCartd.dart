import 'package:pokemon/data/models/weakness.dart';

import 'attack.dart';
import 'cardImages.dart';
import 'cardSet.dart';

class PokemonCard {
  final String id;
  final String name;
  final String supertype;
  final List<String> subtypes;
  final String hp;
  final List<String> types;
  final List<Attack> attacks;
  final List<Weakness> weaknesses;
  final CardSet set;
  final String number;
  final String artist;
  final CardImages images;

  PokemonCard({
    required this.id,
    required this.name,
    required this.supertype,
    required this.subtypes,
    required this.hp,
    required this.types,
    required this.attacks,
    required this.weaknesses,
    required this.set,
    required this.number,
    required this.artist,
    required this.images,
  });

  factory PokemonCard.fromJson(Map<String, dynamic> json) {
    return PokemonCard(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      supertype: json['supertype'] ?? '',
      subtypes: List<String>.from(json['subtypes'] ?? []),
      hp: json['hp'] ?? '',
      types: List<String>.from(json['types'] ?? []),
      attacks: (json['attacks'] as List<dynamic>?)
          ?.map((attack) => Attack.fromJson(attack))
          .toList() ??
          [],
      weaknesses: (json['weaknesses'] as List<dynamic>?)
          ?.map((weakness) => Weakness.fromJson(weakness))
          .toList() ??
          [],
      set: CardSet.fromJson(json['set'] ?? {}),
      number: json['number'] ?? '',
      artist: json['artist'] ?? '',
      images: CardImages.fromJson(json['images'] ?? {}),
    );
  }
}