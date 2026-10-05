import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  static const int deliveryFee = 4500;

  List<Map<String, dynamic>> get cartItems => _cartItems;

  int get subtotal => _cartItems.fold(
        0,
        (sum, item) => sum + (item['price'] as int),
      );

  int get total => subtotal + deliveryFee;

  void increaseQuantity(int index) {
    _cartItems[index]['quantity']++;
    notifyListeners();
  }

  void decreaseQuantity(int index) {
    if (_cartItems[index]['quantity'] > 1) {
      _cartItems[index]['quantity']--;
      notifyListeners();
    }
  }

  void addItem(Map<String, dynamic> newItem) {
    _cartItems.add(newItem);
    notifyListeners();
  }

  void removeItem(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  // ADDED: Clears cart items after successful payment
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}