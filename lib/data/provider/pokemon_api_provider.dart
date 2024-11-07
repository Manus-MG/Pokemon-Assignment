import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonApiProvider {
  static const String baseUrl = 'https://api.pokemontcg.io/v2';

  Future<Map<String, dynamic>> getCards({
    required int page,
    required int pageSize,
    String? query,
  }) async {
    final url = query != null
        ? '$baseUrl/cards?q=$query&page=$page&pageSize=$pageSize'
        : '$baseUrl/cards?page=$page&pageSize=$pageSize';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load cards');
    }
  }
}
