import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';
import 'pacientes_screen.dart';
import 'paciente_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> pacientes = [
    {"nome": "João", "sexo": "M", "cpf": "123.456.789-00", "telefone": "(11) 99999-8888"},
    {"nome": "Maria", "sexo": "F", "cpf": "987.654.321-00", "telefone": "(21) 98888-7777"},
  ];

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("accessToken");

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return SizedBox(
      height: 140,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  color ?? Colors.teal,
                  (color ?? Colors.teal).withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50, color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consultório Saúde+"),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
          )
        ],
      ),
      body: Column(
        children: [
          // === Dashboard com gráfico de pacientes por sexo ===
          Expanded(
            flex: 2,
            child: DashboardScreen(pacientes: pacientes),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildCard(
                    icon: Icons.people,
                    title: "Pacientes",
                    color: Colors.blue,
                    onTap: () async {
                      final resultado = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PacientesScreen(pacientes: pacientes),
                        ),
                      );
                      if (resultado != null && resultado is List<Map<String, String>>) {
                        setState(() => pacientes = resultado);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCard(
                    icon: Icons.person_add,
                    title: "Novo Paciente",
                    color: Colors.green,
                    onTap: () async {
                      final novoPaciente = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PacienteFormScreen(
                            onSave: (paciente) {
                              Navigator.pop(context, paciente);
                            },
                          ),
                        ),
                      );

                      if (novoPaciente != null && novoPaciente is Map<String, String>) {
                        setState(() {
                          pacientes.add(novoPaciente);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
