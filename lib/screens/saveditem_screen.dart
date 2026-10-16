import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'favouritesprovider_screen.dart';
import 'flavour.dart';
import 'flavourdetail_screen.dart';

class SavedItemsScreen extends StatelessWidget {
  const SavedItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> savedItems =
        context.watch<FavoritesProvider>().favoriteItems;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image (from Help & Support Screen)
          Positioned.fill(
            child: Image.asset(
              'assets/images/fonts/ice_cream_bg.jpe',
              fit: BoxFit.cover,
            ),
          ),
          // Dark Purple Overlay
          Positioned.fill(
            child: Container(
              color: const Color(0xFF2A1653).withOpacity(0.72),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header Bar with Back Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Expanded(child: _buildHeader()),
                      const SizedBox(width: 40), // Balance back button spacing
                    ],
                  ),
                ),
                
                // Title and Subtitle
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                  child: Column(
                    children: [
                      Text(
                        'Saved Items',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Your favorite flavors always within reach.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Flavors Pill Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA5528F),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Flavors',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Saved List or Empty State Placeholder
                Expanded(
                  child: savedItems.isEmpty
                      ? const Center(
                          child: Text(
                            'Your saved items will show here.',
                            style: TextStyle(color: Colors.white70, fontSize: 15),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: savedItems.length,
                          itemBuilder: (context, index) {
                            final item = savedItems[index];
                            return _buildSavedCard(context, item);
                          },
                        ),
                ),

                // Bottom Navigation Bar
                _buildBottomNavigationBar(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Havilah Title Header
  Widget _buildHeader() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(
              style: GoogleFonts.holtwoodOneSc(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
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
          Text(
            'Ice cream app',
            style: GoogleFonts.alexBrush(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Item Card Design
  Widget _buildSavedCard(BuildContext context, Map<String, dynamic> item) {
    final String name = item['name'] as String? ?? 'Flavour';
    final String description = item['description'] as String? ?? '';
    final String imageAsset = (item['imageAsset'] ?? item['imageUrl'] ?? '') as String;
    final Color badgeColor = (item['badgeColor'] as Color?) ?? Colors.purple;

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Ice Cream Picture Icon -> Navigates to Detail Screen when tapped
          GestureDetector(
            onTap: () {
              // Find matching flavour model if available
              final Flavour? flavour = allFlavours.cast<Flavour?>().firstWhere(
                    (f) => f?.name.toLowerCase() == name.toLowerCase(),
                    orElse: () => null,
                  );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlavourDetailScreen(
                    name: flavour?.name ?? name,
                    description: flavour?.description ?? description,
                    imageAsset: imageAsset,
                    badgeColor: badgeColor,
                  ),
                ),
              );
            },
            child: Container(
              width: 55,
              height: 55,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: ClipOval(
                child: imageAsset.isNotEmpty
                    ? Image.asset(
                        imageAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.icecream, size: 30, color: Colors.purple),
                      )
                    : const Icon(Icons.icecream, size: 30, color: Colors.purple),
              ),
            ),
          ),

          // Action Icons (Heart and Delete/Trash)
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite, color: Color(0xFFC2185B), size: 28),
                onPressed: () {
                  context.read<FavoritesProvider>().toggleFavorite(item);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
                onPressed: () {
                  context.read<FavoritesProvider>().toggleFavorite(item);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Navigation Bar at Bottom
  Widget _buildBottomNavigationBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: Colors.white, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white, size: 30),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: Colors.white, size: 30),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}