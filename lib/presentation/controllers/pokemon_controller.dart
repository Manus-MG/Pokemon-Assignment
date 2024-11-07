import 'package:get/get.dart';

import '../../data/models/PokemonCartd.dart';
import '../../data/repository/pokemonRepo.dart';

class PokemonController extends GetxController {
  final PokemonRepository repository;

  PokemonController({required this.repository});

  RxList<PokemonCard> cards = <PokemonCard>[].obs;
  RxBool isLoading = false.obs;
  RxInt currentPage = 1.obs;
  RxString searchQuery = ''.obs;

  Future<void> loadCards({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      cards.clear();
    }

    if (isLoading.value) return;

    try {
      isLoading.value = true;
      final newCards = await repository.getCards(
        page: currentPage.value,
        pageSize: 10,
        query: searchQuery.value.isNotEmpty
            ? 'name:*${searchQuery.value}*'
            : null,
      );

      cards.addAll(newCards);
      currentPage.value++;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load cards');
    } finally {
      isLoading.value = false;
    }
  }

  void search(String query) {
    searchQuery.value = query;
    loadCards(refresh: true);
  }
}