import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'favouritesprovider_screen.dart';
import 'orderReview_screen.dart';
import 'user_profile.dart';

class FlavourDetailScreen extends StatefulWidget {
  final UserProfile? userProfile;
  final String name;
  final String description;
  final String imageAsset;
  final Color badgeColor;

  const FlavourDetailScreen({
    super.key,
    this.userProfile,
    required this.name,
    required this.description,
    required this.imageAsset,
    required this.badgeColor,
  });
 
  @override
  State<FlavourDetailScreen> createState() => _FlavourDetailScreenState();
}

class _FlavourDetailScreenState extends State<FlavourDetailScreen> {
  static const Map<String, int> tubBasePrices = {'Small': 0, 'Medium': 500, 'Large': 700};
  static const Map<String, List<int>> scoopRange = {
    'Small': [1, 2],
    'Medium': [1, 3],
    'Large': [4, 6],
  };
  static const int scoopPrice = 2500;

  String selectedSize = 'Small';
  late int scoopCount;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    scoopCount = scoopRange[selectedSize]![0];
  }

  void _onSizeChanged(String newSize) {
    setState(() {
      selectedSize = newSize;
      final range = scoopRange[newSize]!;
      if (scoopCount < range[0]) scoopCount = range[0];
      if (scoopCount > range[1]) scoopCount = range[1];
    });
  }

  void _changeScoop(int delta) {
    final range = scoopRange[selectedSize]!;
    final newCount = scoopCount + delta;
    if (newCount >= range[0] && newCount <= range[1]) {
      setState(() => scoopCount = newCount);
    }
  }

  int get _unitPrice => tubBasePrices[selectedSize]! + (scoopCount * scoopPrice);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
             Container(
  height: 320,
  width: double.infinity,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [widget.badgeColor, Colors.white],
    ),
  ),
  child: Center(
    child: Image.asset(
      widget.imageAsset,
      height: 220,
      width: 220,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.icecream, size: 80, color: Colors.white70),
    ),
  ),
),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color:  Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.name, style: TextStyle(color: widget.badgeColor, fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(widget.description, style: const TextStyle(color: Colors.black87, fontSize: 13)),
                        const SizedBox(height: 20),
                        const Text('Choose size', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 10),
                        _buildSizeSelector(),
                        const SizedBox(height: 24),
                        _buildScoopStepper(),
                        const SizedBox(height: 16),
                        _buildQuantityStepper(),
                        const SizedBox(height: 24),
                        _buildAddToCartButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    _buildHeartButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeartButton() {
    final bool isFav = context.watch<FavoritesProvider>().isFavorite(widget.name);
    return IconButton(
      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.pink),
      onPressed: () {
        context.read<FavoritesProvider>().toggleFavorite({
          'name': widget.name,
          'description': widget.description,
          'imageAsset': widget.imageAsset,
          'badgeColor': widget.badgeColor,
        });
      },
    );
  }

  Widget _buildSizeSelector() {
    return Row(
      children: tubBasePrices.entries.map((entry) {
        final String size = entry.key;
        final int basePrice = entry.value;
        final bool isSelected = size == selectedSize;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () => _onSizeChanged(size),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? widget.badgeColor : Colors.white,
                border: Border.all(color: widget.badgeColor, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(size, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(
                    basePrice == 0 ? 'Free' : '₦$basePrice',
                    style: TextStyle(color: isSelected ? Colors.white : Colors.black54, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildScoopStepper() {
    final range = scoopRange[selectedSize]!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Scoop (${range[0]}-${range[1]})', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
        Row(
          children: [
            _buildStepperButton(icon: Icons.remove, onPressed: () => _changeScoop(-1)),
            SizedBox(width: 32, child: Text('$scoopCount', textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
            _buildStepperButton(icon: Icons.add, onPressed: () => _changeScoop(1)),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantityStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Quantity', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
        Row(
          children: [
            _buildStepperButton(icon: Icons.remove, onPressed: () => setState(() { if (quantity > 1) quantity--; })),
            SizedBox(width: 32, child: Text('$quantity', textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
            _buildStepperButton(icon: Icons.add, onPressed: () => setState(() => quantity++)),
          ],
        ),
      ],
    );
  }

  Widget _buildStepperButton({required IconData icon, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6)),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildAddToCartButton() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
            Text('₦${_unitPrice * quantity}', style: TextStyle(color: widget.badgeColor, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              context.read<CartProvider>().addItem({
                'name': widget.name,
                'imageAsset': widget.imageAsset,
                'size': selectedSize,
                'scoops': scoopCount,
                'price': _unitPrice * quantity,
                'quantity': quantity,
                'badgeColor': widget.badgeColor,
              });
              final profile = UserProfile(
      username: 'Guest',
      email: 'guest@email.com',
      address: 'Default Address',
    );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  OrderReviewScreen(userProfile: profile)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.badgeColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Add to cart', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}