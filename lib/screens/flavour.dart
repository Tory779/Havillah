import 'package:flutter/material.dart';

class Flavour {
  final String name;
  final String description;
  final String imageAsset;
  final Color badgeColor;
  final bool isPopular;

  const Flavour({
    required this.name,
    required this.description,
    required this.imageAsset,
    required this.badgeColor,
    this.isPopular = false,
  });
}

const List<Flavour> allFlavours = [
  Flavour(
    name: 'Chocolate',
    description: 'Rich, velvety chocolate that melts into every spoonful of pure indulgence.',
    imageAsset : 'assets/images/fonts/Chocolate_ice_cream.png',
    badgeColor: Colors.brown,
  ),
  Flavour(
    name: 'Strawberry',
    description: 'Taste the delicious sweetness of strawberries in every creamy scoop.',
    imageAsset: 'assets/images/fonts/Strawberry_Icecream_image.png',
    badgeColor: Colors.pink,
    isPopular: true,
  ),
  Flavour(
    name: 'Cotton Candy',
    description: 'A fluffy, sugary swirl that brings the fairground straight to your cone.',
    imageAsset: 'assets/images/fonts/Cotton_candy_ice_cream.png',
    badgeColor: Colors.lightBlue,
    isPopular: true,
  ),
  Flavour(
    name: 'Vanilla',
    description: 'Classic and creamy — the timeless scoop that never goes out of style.',
    imageAsset: 'assets/images/fonts/Vanilla_Ice_cream.png',
    badgeColor: Color.fromARGB(255, 219, 172, 42),
  ),
  Flavour(
    name: 'Caramel',
    description: 'Smooth caramel ribbons swirled through every rich, golden scoop.',
    imageAsset: 'assets/images/fonts/Caramel_icecream.png',
    badgeColor: Color.fromARGB(255, 109, 60, 4),
  ),
  Flavour(
    name: 'Oreos',
    description: 'Chunks of cookie folded into cream for the ultimate crunch-meets-smooth combo.',
    imageAsset: 'assets/images/fonts/Oreos_ice_cream.png',
    badgeColor: Colors.black87,
    isPopular: true,
  ),
  Flavour(
    name: 'Coconut',
    description: 'Tropical and creamy, with real coconut in every refreshing bite.',
    imageAsset: 'assets/images/fonts/Coconut_ice_cream.png',
    badgeColor: Colors.grey,
  ),
  Flavour(
    name: 'Cookies & Cream',
    description: "A cookie lover's dream — crushed cookies swirled into silky cream.",
    imageAsset: 'assets/images/fonts/Cookies_and_cream_ice_cream.png',
    badgeColor: Color.fromARGB(255, 71, 40, 14),
  ),
  Flavour(
    name: 'Choco Chips',
    description: 'Creamy vanilla base loaded with chocolate chips in every scoop.',
    imageAsset: 'assets/images/fonts/Chocochips_ice_cream.png',
    badgeColor: Color(0xFF6D4C41),
  ),
];