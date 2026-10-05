import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'orderreview_screen.dart';
import 'flavourdetail_screen.dart';
import 'flavour.dart';
import 'user_profile.dart'; // Ensure user_profile import is present

class AllFlavours extends StatefulWidget {
  final UserProfile? userProfile;

  const AllFlavours({super.key, this.userProfile});

  @override
  State<AllFlavours> createState() => _AllFlavoursState();
}

class _AllFlavoursState extends State<AllFlavours> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    _buildTopBar(context),
                    const SizedBox(height: 10),
                    const Text(
                      'All Flavours',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSearchBar(),
                    const SizedBox(height: 20),
                    _buildFlavorsGrid(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'search flavor...',
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
  
  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 25),
          onPressed: () {
            // FIX 1: Simply pop back to the previous screen (HomeScreen)
            Navigator.pop(context);
          },
        ),
        RichText(
          text: TextSpan(
            style: GoogleFonts.holtwoodOneSc(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
            children: const [
              TextSpan(text: 'H', style: TextStyle(color: Color(0xFFCC0505))),
              TextSpan(text: 'A', style: TextStyle(color: Color(0xFF050FCC))),
              TextSpan(text: 'V', style: TextStyle(color: Colors.white)),
              TextSpan(text: 'I', style: TextStyle(color: Color(0xFF008223))),
              TextSpan(text: 'L', style: TextStyle(color: Color(0xFFB30593))),
              TextSpan(text: 'A', style: TextStyle(color: Color(0xFFF56111))),
              TextSpan(text: 'H', style: TextStyle(color: Color(0xFFCC0505))),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
          onPressed: () {
            // FIX 2: Pass userProfile parameter required by OrderReviewScreen
            final profile = widget.userProfile ?? UserProfile(
              username: 'Guest',
              email: 'guest@email.com',
              address: 'Default Address',
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderReviewScreen(userProfile: profile),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFlavorsGrid(BuildContext context) {
    final filteredFlavours = allFlavours.where((flavour) {
      return flavour.name.toLowerCase().contains(_searchQuery.trim().toLowerCase());
    }).toList();

    if (filteredFlavours.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Text(
          'not found',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 14,
      childAspectRatio: 0.72,
      children: filteredFlavours.map((flavour) {
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

        return GestureDetector(
          onTap: goToDetail,
          child: Container(
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(
                    flavour.imageAsset,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.icecream, size: 40, color: Colors.grey),
                  ),
                ),
                Text(flavour.name, style: TextStyle(color: flavour.badgeColor, fontWeight: FontWeight.bold, fontSize: 11)),
                const SizedBox(height: 6),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}