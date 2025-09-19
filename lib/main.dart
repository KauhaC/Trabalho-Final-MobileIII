import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const TrabalhoFinalApp());
}

class TrabalhoFinalApp extends StatelessWidget {
  const TrabalhoFinalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trabalho Final Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}
