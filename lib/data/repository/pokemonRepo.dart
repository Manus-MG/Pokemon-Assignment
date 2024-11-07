import '../models/PokemonCartd.dart';
import '../provider/pokemon_api_provider.dart';

class PokemonRepository {
  final PokemonApiProvider apiProvider;

  PokemonRepository({required this.apiProvider});

  Future<List<PokemonCard>> getCards({
    required int page,
    required int pageSize,
    String? query,
  }) async {
    final response = await apiProvider.getCards(
      page: page,
      pageSize: pageSize,
      query: query,
    );

    return (response['data'] as List)
        .map((card) => PokemonCard.fromJson(card))
        .toList();
  }
}