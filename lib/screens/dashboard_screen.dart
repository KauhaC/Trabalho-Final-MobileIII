import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  final List<Map<String, String>> pacientes;

  const DashboardScreen({super.key, required this.pacientes});

  @override
  Widget build(BuildContext context) {
    int masculino = pacientes.where((p) => p["sexo"] == "M").length;
    int feminino = pacientes.where((p) => p["sexo"] == "F").length;
    int total = masculino + feminino;

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Distribuição de Pacientes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      value: masculino.toDouble(),
                      color: Colors.blue,
                      radius: 60,
                      title: "", // sem texto dentro
                    ),
                    PieChartSectionData(
                      value: feminino.toDouble(),
                      color: Colors.pink,
                      radius: 60,
                      title: "", // sem texto dentro
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // === Legenda Bonita ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(Colors.blue, "Homens: $masculino"),
                _buildLegendItem(Colors.pink, "Mulheres: $feminino"),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Total: $total pacientes",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            )
          ],
        ),
      ),
    );
  }

  static Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}