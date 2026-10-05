import 'package:flutter/material.dart';
import 'helpandsupport_screen.dart';
import 'editprofile_screen.dart';
import 'user_profile.dart';
import 'notifications_screen.dart';
import 'package:go_router/go_router.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile profile = UserProfile(
    username: '',
    email: '',
    address: '',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTopHeader(),
                  const SizedBox(height: 25),
                  _buildProfileOptionsList(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 30, bottom: 25),
      decoration: BoxDecoration(
        color: const Color(0xFF8B3A8B).withOpacity(0.85),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFFD9D9D9),
                backgroundImage: profile.profileImage != null
                    ? FileImage(profile.profileImage!)
                    : null,
                child: profile.profileImage == null
                    ? const Icon(Icons.person, size: 60, color: Colors.white70)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            profile.username,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            profile.email,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOptionsList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOptionTile(
            icon: Icons.person,
            title: 'Edit Profile',
            onTap: () => _onEditProfilePressed(context),
          ),
          _buildOptionTile(
            icon: Icons.notifications_none,
            title: 'Notifications',
            onTap: () => _onNotificationsPressed(context),
          ),
          _buildOptionTile(
            icon: Icons.bookmark_border,
            title: 'Saved Items',
            onTap: () => _onSavedItemsPressed(context),
          ),
          _buildOptionTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () => _onHelpSupportPressed(context),
          ),
          const SizedBox(height: 10),
          _buildLogoutButton(context),
          const SizedBox(height: 200),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14.0),
      child: Material(
        color: const Color(0xFF130932).withOpacity(0.85),
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 14.0,
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 22),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Material(
        color: const Color(0xFF130932).withOpacity(0.85),
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () => _onLogoutPressed(context),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.white, size: 20),
                SizedBox(width: 10),
                Text(
                  'Log out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onEditProfilePressed(BuildContext context) async {
    final updatedProfile = await Navigator.push<UserProfile>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(profile: profile),
      ),
    );

    if (updatedProfile != null) {
      setState(() {
        profile = updatedProfile;
      });
    }
  }

  void _onNotificationsPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
    );
  }

  void _onSavedItemsPressed(BuildContext context) {}

  void _onHelpSupportPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HelpAndSupportScreen()),
    );
  }

  void _onLogoutPressed(BuildContext context) {
    context.go('/login');
  }
}