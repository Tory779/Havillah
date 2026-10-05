import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'favouritesprovider_screen.dart';
import 'flavour.dart';
import 'flavourdetail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> favoriteItems = context.watch<FavoritesProvider>().favoriteItems;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF201358), Color(0xFF4529BE)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 30),
                    _buildSearchBar(),
                    const SizedBox(height: 20),
                    _buildFavoritesList(context, favoriteItems),
                    if (favoriteItems.isNotEmpty) _buildRemoveAllButton(context),
                    const SizedBox(height: 15),
                    _buildRecommendationsGrid(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.holtwoodOneSc(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 2),
          children: [
            TextSpan(text: 'H', style: GoogleFonts.holtwoodOneSc(color: const Color(0xFFCC0505))),
            TextSpan(text: 'A', style: GoogleFonts.holtwoodOneSc(color: const Color(0xFF050FCC))),
            TextSpan(text: 'V', style: GoogleFonts.holtwoodOneSc(color: Colors.white)),
            TextSpan(text: 'I', style: GoogleFonts.holtwoodOneSc(color: const Color(0xFF008223))),
            TextSpan(text: 'L', style: GoogleFonts.holtwoodOneSc(color: const Color(0xFFB30593))),
            TextSpan(text: 'A', style: GoogleFonts.holtwoodOneSc(color: const Color(0xFFF56111))),
            TextSpan(text: 'H', style: GoogleFonts.holtwoodOneSc(color: const Color(0xFFCC0505))),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) => setState(() => _searchQuery = value.trim().toLowerCase()),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search favourites',
        hintStyle: const TextStyle(color: Colors.white70),
        suffixIcon: const Icon(Icons.search, color: Colors.white),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
      ),
    );
  }

  Widget _buildFavoritesList(BuildContext context, List<Map<String, dynamic>> favoriteItems) {
    if (favoriteItems.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0),
        child: Center(
          child: Text('No favorite items added', style: TextStyle(color: Colors.white70, fontSize: 16)),
        ),
      );
    }

    final matchingEntries = favoriteItems.asMap().entries.where((entry) {
      final name = (entry.value['name'] as String? ?? '').toLowerCase();
      return name.contains(_searchQuery);
    }).toList();

    if (matchingEntries.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0),
        child: Center(
          child: Text('No matching favourites', style: TextStyle(color: Colors.white70, fontSize: 16)),
        ),
      );
    }

    return Column(
      children: matchingEntries.map((entry) {
        final int index = entry.key;
        final Map<String, dynamic> item = entry.value;

        final String name = item['name'] as String? ?? 'Flavour';
        final String description = item['description'] as String? ?? '';
        final String imageAsset = (item['imageAsset'] ?? item['imageUrl'] ?? '') as String;
        final Color badgeColor = (item['badgeColor'] as Color?) ?? Colors.purple;

        return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                const Color(0xFFFFFFFF).withOpacity(0.35),
                const Color(0xFF6065FF).withOpacity(0.35),
              ],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: imageAsset.isNotEmpty
                    ? Image.asset(
                        imageAsset,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.icecream_outlined, size: 45, color: Colors.white70),
                      )
                    : const Icon(Icons.icecream_outlined, size: 45, color: Colors.white70),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.white70, size: 24),
                    onPressed: () => context.read<FavoritesProvider>().removeAt(index),
                    tooltip: 'Remove Item',
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FlavourDetailScreen(
                            name: name,
                            description: description,
                            imageAsset: imageAsset,
                            badgeColor: badgeColor,
                          ),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('View', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRemoveAllButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => context.read<FavoritesProvider>().clear(),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(50, 30),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text('Remove All', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    );
  }

  Widget _buildRecommendationsGrid() {
    final recommendations = [
      {'name': 'Coconut', 'color': const Color(0xFF6D4C41), 'imageAsset': 'assets/images/fonts/Coconut_ice_cream.png'},
      {'name': 'Cookies & Cream', 'color': const Color(0xFF8D6E63), 'imageAsset': 'assets/images/fonts/Cookies_and_cream_ice_cream.png'},
      {'name': 'Choco chips', 'color': const Color(0xFF3E2723), 'imageAsset': 'assets/images/fonts/Chocochips_ice_cream.png'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: recommendations.map((item) {
        final String name = item['name'] as String;
        final String imageAsset = item['imageAsset'] as String;
        final Color badgeColor = item['color'] as Color;

        // Find matching flavour details safely
        final Flavour? flavour = allFlavours.cast<Flavour?>().firstWhere(
              (f) => f?.name.toLowerCase() == name.toLowerCase(),
              orElse: () => null,
            );

        return Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlavourDetailScreen(
                    name: flavour?.name ?? name,
                    description: flavour?.description ?? '',
                    imageAsset: imageAsset,
                    badgeColor: badgeColor,
                  ),
                ),
              );
            },
            child: Container(
              height: 180,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9).withOpacity(0.35),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Image.asset(
                      imageAsset,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.icecream, size: 45, color: Colors.white70),
                    ),
                  ),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}