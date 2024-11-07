
import 'package:get/get.dart';

import '../data/provider/pokemon_api_provider.dart';
import '../data/repository/pokemonRepo.dart';
import '../presentation/controllers/pokemon_controller.dart';
import '../presentation/pages/home_page.dart';

abstract class Routes {
  static const HOME = '/';
  static const CARD_DETAIL = '/card-detail';
}

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
  ];
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PokemonApiProvider());
    Get.lazyPut(() => PokemonRepository(apiProvider: Get.find()));
    Get.lazyPut(() => PokemonController(repository: Get.find()));
  }
}
