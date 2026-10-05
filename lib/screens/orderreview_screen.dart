import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'all_flavours.dart';
import 'user_profile.dart';
import 'payment_selection_sheet.dart';


class OrderReviewScreen extends StatelessWidget {
  final UserProfile userProfile;

  const OrderReviewScreen({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = context.watch<CartProvider>();
    final List<Map<String, dynamic>> cartItems = cartProvider.cartItems;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF201358), Color(0xFF4529BE)],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildTopBar(context),
                    const SizedBox(height: 24),
                    const Text('Review your order(s).', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    const Text("You've got great taste. Here's what you picked.", style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 20),
                    if (cartItems.isEmpty)
                      _buildEmptyState()
                    else
                      ...cartItems.asMap().entries.map(
                        (entry) => _buildCartItemCard(context, entry.key, entry.value),
                      ),
                    const SizedBox(height: 8),
                    if (cartItems.isNotEmpty) _buildAddMoreBanner(context),
                    const SizedBox(height: 20),
                    if (cartItems.isNotEmpty) _buildOrderSummary(cartProvider),
                    const SizedBox(height: 20),
                    if (cartItems.isNotEmpty) _buildDoneButton(context, cartProvider),
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

  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40.0),
      child: Center(
        child: Text('Your cart is empty, explore flavours to add to your cart.', style: TextStyle(color: Colors.white70, fontSize: 14)),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        Column(
          children: [
            RichText(
              text: TextSpan(
                style: GoogleFonts.holtwoodOneSc(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2),
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
            Text('Ice cream app', style: GoogleFonts.dancingScript(color: Colors.white70, fontSize: 13)),
          ],
        ),
        const SizedBox(width: 48),
      ],
    );
  }

 Widget _buildCartItemCard(BuildContext context, int index, Map<String, dynamic> item) {
  final String imageAsset = (item['imageAsset'] ?? '') as String;

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: const Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(16)),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 60,
            height: 60,
            color: Colors.grey[300],
            child: imageAsset.isNotEmpty
                ? Image.asset(
                    imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.icecream, size: 38, color: Colors.grey),
                  )
                : const Icon(Icons.icecream, size: 38, color: Colors.grey),
          ),
        ),

          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'] as String? ?? 'Item', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: (item['badgeColor'] as Color?) ?? Colors.purple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(item['size'] as String? ?? 'Standard', style: const TextStyle(color: Colors.white, fontSize: 11)),
                    ),
                    const SizedBox(width: 6),
                    Text('x${item['quantity'] ?? 1}', style: const TextStyle(color: Colors.black54, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.black54, size: 22),
                onPressed: () => context.read<CartProvider>().removeItem(index),
                tooltip: 'Remove item',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Text('₦${item['price'] ?? 0}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddMoreBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Image.asset('assets/images/fonts/Ice_cream_image.jpg', width: 30, height: 30, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Want to add more?', style: TextStyle(color: Color(0xFFE0C27A), fontWeight: FontWeight.bold, fontSize: 17)),
                const SizedBox(height: 4),
                const Text('Explore more flavors and make it even sweeter.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD9D9D9), Color(0xFF737373)],
                    ),
                    borderRadius: BorderRadius.circular(20),
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, color: Colors.black, size: 14),
                        SizedBox(width: 4),
                        Text('Explore flavours', style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(CartProvider cartProvider) {
    final int itemCount = cartProvider.cartItems.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.purple[200], borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order summary', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Items ($itemCount)', style: const TextStyle(color: Colors.black87)),
              Text('₦${cartProvider.subtotal}', style: const TextStyle(color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Delivery fee', style: TextStyle(color: Colors.black87)),
              Text('₦${CartProvider.deliveryFee}', style: const TextStyle(color: Colors.black87)),
            ],
          ),
          const Divider(color: Colors.black26, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              Text('₦${cartProvider.total}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDoneButton(BuildContext context, CartProvider cartProvider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (userProfile.defaultPaymentMethod != null) {
            _executeOrder(context, userProfile.defaultPaymentMethod!, cartProvider);
          } else {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (bottomSheetContext) => PaymentSelectionSheet(
                orderTotal: cartProvider.total,
                initialDefaultMethod: userProfile.defaultPaymentMethod,
                onPaymentConfirmed: (selectedMethod, saveAsDefault) {
                  if (saveAsDefault) {
                    userProfile.defaultPaymentMethod = selectedMethod;
                  }
                  Navigator.pop(bottomSheetContext);
                  _executeOrder(context, selectedMethod, cartProvider);
                },
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.purpleAccent, size: 20),
            SizedBox(width: 8),
            Text('Done', style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: Colors.purpleAccent, size: 18),
          ],
        ),
      ),
    );
  }

  void _executeOrder(BuildContext context, String method, CartProvider cartProvider) {
    String message = method == 'cash'
        ? 'Order placed successfully! Pay on pickup.'
        : 'Payment processed successfully via card!';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );

    cartProvider.clearCart();
    Navigator.pop(context);
  }
}