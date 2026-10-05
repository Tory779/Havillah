import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/notification_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationProvider = context.watch<NotificationProvider>();
    final notifications = notificationProvider.notifications;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/fonts/ice_cream_bg.jpe', // Ensure this image asset is declared in pubspec.yaml
              fit: BoxFit.cover,
            ),
          ),
          // Purple Tint / Gradient Overlay matching design
          Positioned.fill(
            child: Container(
              color: const Color(0xFF2A1653).withOpacity(0.72),
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            _buildTopBar(context),
                            const SizedBox(height: 16),
                            const Text(
                              'Notifications',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Stay updated with the latest from Havilah.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (notifications.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: Center(
                                  child: Text(
                                    'No notifications left.',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
                            else
                              ...notifications.map(
                                (item) => _buildNotificationCard(context, item),
                              ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        Expanded(
          child: Center(
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.holtwoodOneSc(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                    children: const [
                      TextSpan(
                        text: 'H',
                        style: TextStyle(color: Color(0xFFCC0505)),
                      ),
                      TextSpan(
                        text: 'A',
                        style: TextStyle(color: Color(0xFF050FCC)),
                      ),
                      TextSpan(
                        text: 'V',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: 'I',
                        style: TextStyle(color: Color(0xFF008223)),
                      ),
                      TextSpan(
                        text: 'L',
                        style: TextStyle(color: Color(0xFFB30593)),
                      ),
                      TextSpan(
                        text: 'A',
                        style: TextStyle(color: Color(0xFFF56111)),
                      ),
                      TextSpan(
                        text: 'H',
                        style: TextStyle(color: Color(0xFFCC0505)),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Ice cream app',
                  style: GoogleFonts.dancingScript(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildNotificationCard(BuildContext context, dynamic item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF28194E).withOpacity(0.85), // Translucent dark purple
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.notifications,
            color: Colors.white,
            size: 26,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.message,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12.5,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.white70,
              size: 24,
            ),
            onPressed: () {
              context.read<NotificationProvider>().removeNotification(item.id);
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Delete notification',
          ),
        ],
      ),
    );
  }
}