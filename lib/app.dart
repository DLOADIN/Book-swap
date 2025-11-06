import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/book_provider.dart';
import 'models/book.dart';
import 'screens/auth_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/email_verification_screen.dart';
import 'screens/post_book_screen.dart';
import 'screens/book_detail_screen.dart';
import 'screens/chat_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
      ],
      child: Consumer<AuthProvider>(builder: (context, auth, _) {
        Widget home;
        
        if (auth.isSignedIn) {
          home = const MainNavigationScreen();
        } else if (auth.isSignedInButUnverified) {
          home = EmailVerificationScreen(email: auth.user?.email ?? '');
        } else {
          home = const AuthScreen();
        }

        return MaterialApp(
          title: 'EcoBookHub',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E7D32), // Forest Green
              primaryContainer: Color(0xFF4CAF50), // Light Green
              secondary: Color(0xFF66BB6A), // Medium Green
              secondaryContainer: Color(0xFFA5D6A7), // Very Light Green
              surface: Color(0xFFF1F8E9), // Green Tint Background
              background: Color(0xFFE8F5E8), // Light Green Background
              onPrimary: Colors.white,
              onSecondary: Colors.white,
              onSurface: Color(0xFF1B5E20), // Dark Green Text
              onBackground: Color(0xFF1B5E20),
              tertiary: Color(0xFF81C784), // Accent Green
              error: Color(0xFFD32F2F),
            ),
            scaffoldBackgroundColor: const Color(0xFFE8F5E8),
            cardTheme: CardThemeData(
              elevation: 8,
              shadowColor: const Color(0xFF2E7D32).withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            iconTheme: const IconThemeData(
              color: Color(0xFF2E7D32),
              size: 24,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              elevation: 12,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFFF1F8E9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Color(0xFF66BB6A)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Color(0xFF66BB6A)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
              ),
            ),
          ),
          home: home,
          routes: {
            '/home': (ctx) => const MainNavigationScreen(),
            '/auth': (ctx) => const AuthScreen(),
            '/verify': (ctx) => EmailVerificationScreen(
              email: auth.user?.email ?? '',
            ),
            '/add-book': (ctx) => const PostBookScreen(),
            '/book-detail': (ctx) => BookDetailScreen(
              book: ModalRoute.of(ctx)!.settings.arguments as Book,
            ),
            '/chat': (ctx) => const ChatScreen(),
          },
        );
      }),
    );
  }
}
