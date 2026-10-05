import 'package:flutter/material.dart';
import 'notification_model.dart';
import 'notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  // Pre-loaded items matching your mock-up UI
  final List<AppNotification> _notifications = [
    AppNotification(
      id: '1',
      title: 'Order Confirmed',
      message: 'Your order #1234FB has been confirmed. Get ready for some sweet moments.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    AppNotification(
      id: '2',
      title: 'Your order is on the way',
      message: 'Your order is being prepared & will be with you shortly. STAY TUNED!.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    AppNotification(
      id: '3',
      title: 'New order alert',
      message: 'Come try our new Coconut flavor. A tropical delight in every scoop.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    AppNotification(
      id: '4',
      title: "You've earned a reward",
      message: "Thanks for being a loyal customer. You've earned 50 bonus points.",
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    AppNotification(
      id: '5',
      title: 'Happy birthday to YOU!!!',
      message: 'Wishing you a sweet & joyful year ahead. Enjoy 15% off your next order.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  List<AppNotification> get notifications => _notifications;

  // Add notification to state AND trigger device push notification
  void addNotification({required String title, required String message}) {
    final newNotif = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      timestamp: DateTime.now(),
    );

    _notifications.insert(0, newNotif);
    notifyListeners();

    // Trigger system tray popup alert
    NotificationService().showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: message,
    );
  }

  // Delete notification by ID (Triggers when trash icon is tapped)
  void removeNotification(String id) {
    _notifications.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}