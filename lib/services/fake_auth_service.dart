// lib/services/fake_auth_service.dart
class FakeAuthService {
  static const String _validEmail = "teste@teste.com";
  static const String _validPassword = "123456";

  /// Simula uma chamada de rede: retorna um token (String) se credenciais corretas,
  /// ou lança uma Exception em caso de erro (para imitar comportamento real).
  Future<String> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // simula latência

    if (email == _validEmail && password == _validPassword) {
      return "fake_token_123456";
    } else {
      throw Exception("Unauthorized");
    }
  }
}
