import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // for the google font, turns out flutter doesnt have it.
// this rubbish thing confused the hell out of me. we thank god for copilot
import 'all_flavours.dart';
import 'orderreview_screen.dart';
import 'flavourdetail_screen.dart';
import 'flavour.dart';
import 'package:go_router/go_router.dart';
import 'user_profile.dart'; // Ensure user_profile import is present

class HomeScreen extends StatelessWidget { 
  final UserProfile? userProfile;// omo mehn we thank god for flutter's packages
  const HomeScreen({super.key, this.userProfile}); // the homescreen constructor apparently

  @override
  Widget build(BuildContext context) {
    //const backgroundColor = Color(0xFF271378);

     return PopScope(
    canPop: false,
    onPopInvokedWithResult: (bool didPop, Object? result) {
      if (!didPop) {
        context.go('/loading');
      }
    },
    child: Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF201358),
              Color(0xFF4529BE),
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: SafeArea(
              child: Stack(
                children: [
                  ..._buildBackgroundStars(),
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        _buildTopBar(context),
                        const SizedBox(height: 20),
                        _buildHeroBanner(),
                        const SizedBox(height: 20),
                        _buildCtaSection(context),
                        const SizedBox(height: 25),
                        _buildSectionHeader(context),
                        const SizedBox(height: 15),
                        _buildPopularFlavorsList(context),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

  
  /// Positions bright pink stars across the background stack.
  List<Widget> _buildBackgroundStars() {
final starPositions = [
  {'top': 80.0, 'left': 12.0, 'size': 18.0},
  {'top': 110.0, 'right': 15.0, 'size': 20.0},
  {'top': 200.0, 'left': 8.0, 'size': 14.0},
  {'top': 250.0, 'left': 10.0, 'size': 16.0},
  {'top': 280.0, 'right': 12.0, 'size': 18.0},
  {'top': 310.0, 'right': 20.0, 'size': 14.0},
];

    return starPositions.map((pos) {
      // Safely extract values without dynamic casting warnings
      final double top = (pos['top'] as num).toDouble();
      final double? left = pos['left'] != null ? (pos['left'] as num).toDouble() : null;
      final double? right = pos['right'] != null ? (pos['right'] as num).toDouble() : null;
      final double size = (pos['size'] as num).toDouble();

      return Positioned(
        top: top,
        left: left,
        right: right,
        child: Icon(
          Icons.star,
          color: Colors.pinkAccent,
          size: size,
        ),
      );
    }).toList();
  }

  /// Top Bar with drawer, styled HAVILAH text, and shopping cart icon.
  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () {
            context.go('/loading');
          },
        ),
        RichText(
          text:  TextSpan(
            style: GoogleFonts.holtwoodOneSc(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
            children: [
              TextSpan(text: 'H', style: GoogleFonts.holtwoodOneSc(color: Color(0xFFCC0505))),
              TextSpan(text: 'A', style: GoogleFonts.holtwoodOneSc(color: Color(0xFF050FCC))),
              TextSpan(text: 'V', style: GoogleFonts.holtwoodOneSc(color: Colors.white)),
              TextSpan(text: 'I', style: GoogleFonts.holtwoodOneSc(color: Color(0xFF008223))),
              TextSpan(text: 'L', style: GoogleFonts.holtwoodOneSc(color: Color(0xFFB30593))),
              TextSpan(text: 'A', style: GoogleFonts.holtwoodOneSc(color: Color(0xFFF56111))),
              TextSpan(text: 'H', style: GoogleFonts.holtwoodOneSc(color: Color(0xFFCC0505))),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 28),
          onPressed: () {
            final profile = UserProfile(
      username: 'Guest',
      email: 'guest@email.com',
      address: 'Default Address',
    );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderReviewScreen(userProfile: profile)),
            );
          },
        ),
      ],
    );
  }

  /// Hero Banner Image with Play Button overlay.
  Widget _buildHeroBanner() {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            'https://images.unsplash.com/photo-1563805042-7684c019e1cb?q=80&w=600',
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 180,
              color: Colors.grey[300],
              child: const Icon(Icons.icecream, size: 50, color: Colors.grey),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(204),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.play_arrow, color: Colors.white, size: 28),
        ),
      ],
    );
  }

  /// Headline Text, Subtitle, and Gradient Button with Ice Cream Emoji.
  Widget _buildCtaSection(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'A little scoop of happiness.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 6),
            Text(
             '❤️',
              style: TextStyle(fontSize: 22),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Discover your next favorite flavor.',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.black, width: 1.5),
            gradient: const LinearGradient(
              colors: [Color(0xFF43C6AC), Color(0xFFF857A6)],
            ),
          ),
          child: ElevatedButton(
            onPressed: () {
                       Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AllFlavours()),
    );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Explore flavours',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward, color: Colors.black),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Section Header ("Popular Flavors" vs "View all...")
  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Popular Flavors',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: () {
             Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AllFlavours()),
    );
  },
          
          child: const Text(
            'View all...',
            style: TextStyle(color: Colors.purpleAccent, fontSize: 14),
          ),
        ),
      ],
    );
  }

  /// Popular Flavors Cards with Network Images and Graceful Fallbacks.
  Widget _buildPopularFlavorsList(BuildContext context) {
  final List<Flavour> popularFlavours = allFlavours.where((f) => f.isPopular).toList();

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: popularFlavours.map((flavour) {
      void goToDetail() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlavourDetailScreen(
              name: flavour.name,
              description: flavour.description,
              imageAsset: flavour.imageAsset,
              badgeColor: flavour.badgeColor,
            ),
          ),
        );
      }

      return Expanded(
        child: GestureDetector(
          onTap: goToDetail,
          child: Container(
            height: 110,
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Image.asset(
                      flavour.imageAsset,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.icecream, size: 38, color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(flavour.name, style: TextStyle(color: flavour.badgeColor, fontWeight: FontWeight.bold, fontSize: 11)),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList(),
  );
}

}