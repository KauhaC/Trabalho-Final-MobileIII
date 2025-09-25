import 'package:flutter/material.dart';
import 'paciente_form_screen.dart';

class PacientesScreen extends StatefulWidget {
  final List<Map<String, String>> pacientes;

  const PacientesScreen({super.key, required this.pacientes});

  @override
  State<PacientesScreen> createState() => _PacientesScreenState();
}

class _PacientesScreenState extends State<PacientesScreen> {
  void _novoPaciente() async {
    final novoPaciente = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PacienteFormScreen(
          onSave: (novoPaciente) {
            Navigator.pop(context, novoPaciente);
          },
        ),
      ),
    );

    if (novoPaciente != null && novoPaciente is Map<String, String>) {
      setState(() {
        widget.pacientes.add(novoPaciente);
      });
    }
  }

  void _editarPaciente(int index) async {
    final paciente = widget.pacientes[index];

    final pacienteAtualizado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PacienteFormScreen(
          paciente: paciente,
          onSave: (pacienteAtualizado) {
            Navigator.pop(context, pacienteAtualizado);
          },
        ),
      ),
    );

    if (pacienteAtualizado != null && pacienteAtualizado is Map<String, String>) {
      setState(() {
        widget.pacientes[index] = pacienteAtualizado;
      });
    }
  }

  void _excluirPaciente(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Excluir Paciente"),
        content: const Text("Tem certeza que deseja excluir este paciente?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.pacientes.removeAt(index);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Excluir"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, widget.pacientes);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Pacientes"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, widget.pacientes);
            },
          ),
        ),
        body: widget.pacientes.isEmpty
            ? const Center(child: Text("Nenhum paciente cadastrado"))
            : ListView.builder(
                itemCount: widget.pacientes.length,
                itemBuilder: (context, index) {
                  final paciente = widget.pacientes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          (paciente["nome"]?.isNotEmpty ?? false)
                              ? paciente["nome"]![0].toUpperCase()
                              : "?",
                        ),
                      ),
                      title: Text(paciente["nome"] ?? ""),
                      subtitle: Text(
                        "Idade: ${paciente["idade"] ?? ""} anos\n"
                        "Sexo: ${paciente["sexo"] == "M" ? "Masculino" : "Feminino"}\n"
                        "CPF: ${paciente["cpf"] ?? ""}\n"
                        "Telefone: ${paciente["telefone"] ?? ""}",
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _editarPaciente(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _excluirPaciente(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: _novoPaciente,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
