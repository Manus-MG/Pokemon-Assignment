import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../data/models/PokemonCartd.dart';
import '../../data/models/attack.dart';
import '../../data/models/weakness.dart';

class CardDetailPage extends StatelessWidget {
  final PokemonCard card;

  const CardDetailPage({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implement share functionality
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(context),
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Stack(
      children: [
        // Background gradient
        Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.8),
                Theme.of(context).primaryColor.withOpacity(0.4),
              ],
            ),
          ),
        ),
        // Card image
        Column(
          children: [
            const SizedBox(height: kToolbarHeight + 16), // Space for AppBar
            Hero(
              tag: card.id,
              child: GestureDetector(
                onTap: () => _showFullScreenImage(context),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: CachedNetworkImage(
                    imageUrl: card.images.large,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.error, color: Colors.white, size: 48),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showFullScreenImage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image with pinch to zoom
                InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Hero(
                    tag: '${card.id}_fullscreen',
                    child: CachedNetworkImage(
                      imageUrl: card.images.large,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                // Close button
                Positioned(
                  top: 16,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -48),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FadeInUp(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  card.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildInfoCard(context),
              const SizedBox(height: 24),
              if (card.attacks.isNotEmpty) _buildAttacksSection(context),
              const SizedBox(height: 24),
              _buildAdditionalInfo(context),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ... (rest of the widgets remain the same as in the previous version)
  Widget _buildInfoCard(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('HP', card.hp, Icons.favorite, Colors.red),
            const Divider(height: 24),
            _buildInfoRow('Types', card.types.join(', '), Icons.category, Colors.blue),
            const Divider(height: 24),
            _buildInfoRow('Set', '${card.set.name}\n(${card.set.series})', Icons.collections, Colors.purple),
            const Divider(height: 24),
            _buildInfoRow('Artist', card.artist, Icons.brush, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String content, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttacksSection(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Attacks',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...card.attacks.asMap().entries.map(
                (entry) => FadeInLeft(
              duration: Duration(milliseconds: 400 + (entry.key * 100)),
              child: _buildAttack(entry.value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttack(Attack attack) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                attack.damage.isEmpty ? '0' : attack.damage,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                attack.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAttackDetail('Cost', attack.cost.join(', ')),
                if (attack.text.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildAttackDetail('Effect', attack.text),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttackDetail(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo(BuildContext context) {
    if (card.weaknesses.isEmpty) return const SizedBox.shrink();

    return FadeInUp(
      duration: const Duration(milliseconds: 700),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weaknesses',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: card.weaknesses.map((weakness) => _buildWeaknessChip(weakness)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeaknessChip(Weakness weakness) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            weakness.type,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            weakness.value,
            style: TextStyle(
              color: Colors.red.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}