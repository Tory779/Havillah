import 'dart:io';

class UserProfile {
  String username;
  String email;
  String? address;
  File? profileImage;
  String? defaultPaymentMethod;

  UserProfile({
    required this.username,
    required this.email,
    required this.address,
    this.profileImage,
    this.defaultPaymentMethod,
  });
}