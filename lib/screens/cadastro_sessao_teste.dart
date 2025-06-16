import 'package:flutter/material.dart';
import 'package:aplicacao/services/sessao_cache.dart';

class CadastroSessaoTeste extends StatefulWidget {
  const CadastroSessaoTeste({super.key});

  @override
  State<CadastroSessaoTeste> createState() => _CadastroSessaoTesteState();
}

class _CadastroSessaoTesteState extends State<CadastroSessaoTeste> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _escolaridadeController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();

  SingingCharacter _sexo = SingingCharacter.masculino;

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    _cpfController.dispose();
    _escolaridadeController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    super.dispose();
  }

  void _salvarSessao() {
    final sessionData = {
      'nomePaciente': _nomeController.text,
      'idade': _idadeController.text,
      'cpf': _cpfController.text,
      'escolaridade': _escolaridadeController.text,
      'cidade': _cidadeController.text,
      'estado': _estadoController.text,
      'sexoBiologico': _sexo.name,
      'dataAplicacao': DateTime.now().toIso8601String(),
    };

    SessaoCache.sessionData = sessionData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cadastro de Sessão de Teste'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(100, 50, 100, 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Por favor, digite o Nome' : null,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Nome Completo *',
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(Icons.people),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      'Sexo Biológico:',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: SingingCharacter.values.map((sexo) {
                  return ListTile(
                    title: Text(sexo.name),
                    leading: Radio<SingingCharacter>(
                      value: sexo,
                      groupValue: _sexo,
                      onChanged: (SingingCharacter? value) {
                        if (value != null) {
                          setState(() => _sexo = value);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _idadeController,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Digite a idade' : null,
                decoration: const InputDecoration(
                  icon: Icon(Icons.cake),
                  labelText: 'Idade *',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _cpfController,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Digite o CPF' : null,
                decoration: const InputDecoration(
                  icon: Icon(Icons.pin),
                  labelText: 'CPF *',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _escolaridadeController,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Digite a escolaridade' : null,
                decoration: const InputDecoration(
                  icon: Icon(Icons.school),
                  labelText: 'Escolaridade *',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _cidadeController,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Digite a cidade' : null,
                decoration: const InputDecoration(
                  icon: Icon(Icons.maps_home_work),
                  labelText: 'Cidade de Realização *',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _estadoController,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Digite o estado' : null,
                decoration: const InputDecoration(
                  icon: Icon(Icons.map_sharp),
                  labelText: 'Estado de Realização *',
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _salvarSessao();
                      Navigator.pushReplacementNamed(
                          context, '/modelotestealternado');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Dados da Sessão Salvos com Sucesso!'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.white,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Salvar'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum SingingCharacter { masculino, feminino, intersexo, outro }
