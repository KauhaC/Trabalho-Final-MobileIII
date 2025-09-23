import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: "admin");
  final _senhaController = TextEditingController(text: "123");

  Future<void> _login() async {
    if (_emailController.text == "admin" && _senhaController.text == "123") {
      final prefs = await SharedPreferences.getInstance();

      final token = "fake_token_${DateTime.now().millisecondsSinceEpoch}";
      final expiry = DateTime.now().add(const Duration(minutes: 1)); // expira em 1 min

      await prefs.setString("token", token);
      await prefs.setString("expiry", expiry.toIso8601String());

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email ou senha inválidos")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login - Consultório Saúde+")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _senhaController,
              decoration: const InputDecoration(labelText: "Senha"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text("Entrar"),
            ),
          ],
        ),
      ),
    );
  }
}
