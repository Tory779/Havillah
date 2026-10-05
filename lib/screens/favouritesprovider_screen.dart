import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _favoriteItems = [];

  List<Map<String, dynamic>> get favoriteItems => _favoriteItems;

  bool isFavorite(String name) {
    return _favoriteItems.any((item) => item['name'] == name);
  }

  void toggleFavorite(Map<String, dynamic> flavor) {
    if (isFavorite(flavor['name'] as String)) {
      _favoriteItems.removeWhere((item) => item['name'] == flavor['name']);
    } else {
      _favoriteItems.add(flavor);
    }
    notifyListeners();
  }

  void removeAt(int index) {
    _favoriteItems.removeAt(index);
    notifyListeners();
  }

  void clear() {
    _favoriteItems.clear();
    notifyListeners();
  }
}