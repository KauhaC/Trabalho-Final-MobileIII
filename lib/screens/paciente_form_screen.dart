import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PacienteFormScreen extends StatefulWidget {
  final Map<String, String>? paciente;
  final Function(Map<String, String>)? onSave;

  const PacienteFormScreen({super.key, this.paciente, this.onSave});

  @override
  State<PacienteFormScreen> createState() => _PacienteFormScreenState();
}

class _PacienteFormScreenState extends State<PacienteFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();
  String? _sexo;

  final _cpfMask = MaskTextInputFormatter(
    mask: "###.###.###-##",
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _telefoneMask = MaskTextInputFormatter(
    mask: "(##) #####-####",
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    if (widget.paciente != null) {
      _nomeController.text = widget.paciente!["nome"] ?? "";
      _idadeController.text = widget.paciente!["idade"] ?? "";
      _cpfController.text = widget.paciente!["cpf"] ?? "";
      _telefoneController.text = widget.paciente!["telefone"] ?? "";
      _sexo = widget.paciente!["sexo"];
    }
  }

  void _salvar() {
    if (_formKey.currentState!.validate() && _sexo != null) {
      final paciente = {
        "nome": _nomeController.text,
        "idade": _idadeController.text,
        "cpf": _cpfController.text,
        "telefone": _telefoneController.text,
        "sexo": _sexo!,
      };

      Navigator.pop(context, paciente); // retorna para PacientesScreen
    } else if (_sexo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione o sexo")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.paciente == null ? "Novo Paciente" : "Editar Paciente"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: "Nome completo"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Digite o nome" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _idadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Idade"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Digite a idade" : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _sexo,
                decoration: const InputDecoration(labelText: "Sexo"),
                items: const [
                  DropdownMenuItem(value: "M", child: Text("Masculino")),
                  DropdownMenuItem(value: "F", child: Text("Feminino")),
                ],
                onChanged: (value) {
                  setState(() {
                    _sexo = value;
                  });
                },
                validator: (value) =>
                    value == null ? "Selecione o sexo" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _cpfController,
                inputFormatters: [_cpfMask],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "CPF"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Digite o CPF" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _telefoneController,
                inputFormatters: [_telefoneMask],
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "Telefone"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Digite o telefone" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvar,
                child: const Text("Salvar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
