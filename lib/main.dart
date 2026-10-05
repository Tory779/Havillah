import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'screens/cart_provider.dart';
import 'screens/home_screen.dart';
import 'screens/favourites_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/favouritesprovider_screen.dart';
import 'constants/notification_service.dart';
import 'constants/notification_provider.dart';
import 'screens/login_screen.dart';
import 'screens/loading_screen.dart';
void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotification(); // Initialize the notification service
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => FavoritesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

final GoRouter _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/loading', builder: (context, state) => const LoadingScreen()),
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF271378),
          body: child,
          bottomNavigationBar: _buildGlobalBottomBar(context, state),
        );
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/favorites',
          builder: (context, state) => const FavoritesScreen(),
        ),
        // Add Profile Route
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);

Widget _buildGlobalBottomBar(BuildContext context, GoRouterState state) {
  final String location = state.uri.toString();

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    color: const Color(0xFF271378),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: Icon(
            Icons.home,
            color: location == '/' ? Colors.pinkAccent : Colors.white,
            size: 32,
          ),
          onPressed: () => context.go('/'),
        ),
        IconButton(
          icon: Icon(
            Icons.favorite,
            color: location == '/favorites' ? Colors.pinkAccent : Colors.white,
            size: 30,
          ),
          onPressed: () => context.go('/favorites'),
        ),
        // Wire up Profile Navigation Button
        IconButton(
          icon: Icon(
            Icons.account_circle,
            color: location == '/profile' ? Colors.pinkAccent : Colors.white,
            size: 32,
          ),
          onPressed: () => context.go('/profile'),
        ),
      ],
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Havilah',
      routerConfig: _router,
      theme: ThemeData(
        fontFamily: 'sans-serif',
        useMaterial3: true,
      ),
    );
  }
}