import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trabalho_final_mobile/screens/home_screen.dart';
import 'package:trabalho_final_mobile/screens/login_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _decideScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final expiry = prefs.getString("expiry");

    if (token != null && expiry != null) {
      final expiryDate = DateTime.parse(expiry);
      if (DateTime.now().isBefore(expiryDate)) {
        return const HomeScreen();
      }
    }
    return const LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consultório Saúde+',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal, // verde-azulado
          primary: Colors.teal,
          secondary: Colors.lightBlueAccent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.teal,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
