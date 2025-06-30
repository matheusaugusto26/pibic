import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:aplicacao/services/sessao_cache.dart';
import 'package:http/http.dart' as http;

enum SingingCharacter { masculino, feminino, intersexo }

extension SingingCharacterExtension on SingingCharacter {
  String get label {
    switch (this) {
      case SingingCharacter.masculino:
        return 'Masculino';
      case SingingCharacter.feminino:
        return 'Feminino';
      case SingingCharacter.intersexo:
        return 'Intersexo';
    }
  }
}

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

  SingingCharacter _sexo = SingingCharacter.masculino;
  String? _estadoSelecionado;
  String? _cidadeSelecionada;
  String? _escolaridadeSelecionada;

  List<Map<String, dynamic>> _estados = [];
  List<String> _cidades = [];

  final List<String> escolaridades = [
    'Ensino Fundamental Completo',
    'Ensino Médio Completo',
    'Ensino Superior Completo',
    'Pós-graduação Completa',
    'Outro',
  ];

  @override
  void initState() {
    super.initState();
    _carregarEstados();
  }

  Future<void> _carregarEstados() async {
    final response = await http.get(
      Uri.parse('https://servicodados.ibge.gov.br/api/v1/localidades/estados'),
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      setState(() {
        _estados = data
            .map<Map<String, dynamic>>((estado) => {
                  'id': estado['id'],
                  'sigla': estado['sigla'],
                  'nome': estado['nome'],
                })
            .toList()
          ..sort((a, b) => a['nome'].compareTo(b['nome']));
      });
    }
  }

  Future<void> _carregarCidades(String uf) async {
    setState(() => _cidades = []);
    final estado = _estados.firstWhere(
      (e) => e['sigla'] == uf,
      orElse: () => {},
    );

    if (estado.isEmpty) return;

    final response = await http.get(Uri.parse(
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados/${estado['id']}/municipios'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      setState(() {
        _cidades =
            data.map<String>((cidade) => cidade['nome'].toString()).toList();
      });
    }
  }

  void _salvarSessao() {
    final sessionData = {
      'nomePaciente': _nomeController.text,
      'idade': _idadeController.text,
      'cpf': _cpfController.text,
      'escolaridade': _escolaridadeSelecionada,
      'cidade': _cidadeSelecionada,
      'estado': _estadoSelecionado,
      'sexoBiologico': _sexo.name,
      'dataAplicacao': DateTime.now().toIso8601String(),
    };

    SessaoCache.sessionData = sessionData;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    _cpfController.dispose();
    super.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Nome
              TextFormField(
                controller: _nomeController,
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor, digite o Nome'
                    : null,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Nome Completo *',
                ),
              ),
              const SizedBox(height: 20),

              // Sexo Biológico
              const Text('Sexo Biológico:', style: TextStyle(fontSize: 16)),
              Column(
                children: SingingCharacter.values.map((sexo) {
                  return RadioListTile<SingingCharacter>(
                    title: Text(sexo.label), 
                    value: sexo,
                    groupValue: _sexo,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _sexo = value);
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Idade
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

              // CPF
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

              // Escolaridade
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  icon: Icon(Icons.school),
                  labelText: 'Escolaridade *',
                ),
                value: _escolaridadeSelecionada,
                items: escolaridades
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                validator: (value) =>
                    value == null ? 'Selecione a escolaridade' : null,
                onChanged: (value) =>
                    setState(() => _escolaridadeSelecionada = value),
              ),
              const SizedBox(height: 20),

              // Estado
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  icon: Icon(Icons.map),
                  labelText: 'Estado *',
                ),
                value: _estadoSelecionado,
                items: _estados
                    .map((estado) => DropdownMenuItem<String>(
                          value: estado['sigla'] as String,
                          child: Text(estado['nome'] as String),
                        ))
                    .toList(),
                validator: (value) =>
                    value == null ? 'Selecione um estado' : null,
                onChanged: (estado) {
                  setState(() {
                    _estadoSelecionado = estado;
                    _cidadeSelecionada = null;
                  });
                  if (estado != null) _carregarCidades(estado);
                },
              ),
              const SizedBox(height: 20),

              // Cidade
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  icon: Icon(Icons.location_city),
                  labelText: 'Cidade *',
                ),
                value: _cidadeSelecionada,
                items: _cidades
                    .map((cidade) => DropdownMenuItem(
                          value: cidade,
                          child: Text(cidade),
                        ))
                    .toList(),
                validator: (value) =>
                    value == null ? 'Selecione uma cidade' : null,
                onChanged: (cidade) {
                  setState(() => _cidadeSelecionada = cidade);
                },
              ),
              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _salvarSessao();
                      Navigator.pushReplacementNamed(
                          context, '/modelotestealternado');
                    }
                  },
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
