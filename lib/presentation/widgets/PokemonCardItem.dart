import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/PokemonCartd.dart';
import '../pages/CardDetailsPage.dart';
class PokemonCardItem extends StatelessWidget {
  final PokemonCard card;

  const PokemonCardItem({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: card.id,
      child: Card(
        child: InkWell(
          onTap: () => Get.to(() => CardDetailPage(card: card)),
          child: Column(
            children: [
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: card.images.small,
                  placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  card.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}