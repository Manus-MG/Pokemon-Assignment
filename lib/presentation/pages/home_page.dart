import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../data/provider/pokemon_api_provider.dart';
import '../../data/repository/pokemonRepo.dart';
import '../controllers/pokemon_controller.dart';
import '../widgets/PokemonCardItem.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.put(PokemonController(
    repository: PokemonRepository(
      apiProvider: PokemonApiProvider(),
    ),
  ));

  final scrollController = ScrollController();
  final searchController = TextEditingController();
  bool isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    controller.loadCards();
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      controller.loadCards();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          _buildSliverAppBar(),
          _buildSearchBar(),
          _buildGrid(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    return FadeInUp(
      duration: const Duration(milliseconds: 200),
      child: FloatingActionButton(
        onPressed: () {
          scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Pokémon Cards',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.3),
              colorBlendMode: BlendMode.darken,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FadeInDown(
          duration: const Duration(milliseconds: 400),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              onChanged: (value) => controller.search(value),
              textAlign: TextAlign.center,  // Center the input text
              decoration: InputDecoration(
                hintText: 'Search Pokémon cards...',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey[400],
                  ),
                ),
                suffixIcon: searchController.text.isNotEmpty
                    ? Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.grey[400],
                    ),
                    onPressed: () {
                      searchController.clear();
                      controller.search('');
                    },
                  ),
                )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 48.0,  // Increased padding to account for icons
                  vertical: 14.0,
                ),
                isCollapsed: true,  // This helps maintain consistent height
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildGrid() {
    return Obx(
          () => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              if (index >= controller.cards.length) {
                return _buildLoadingCard();
              }
              return FadeInUp(
                duration: Duration(milliseconds: 300 + (index * 100)),
                child: PokemonCardItem(card: controller.cards[index]),
              );
            },
            childCount: controller.cards.length + (controller.isLoading.value ? 2 : 0),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }
}