import 'package:flutter/material.dart';

class CadastroSessaoTeste extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  const CadastroSessaoTeste({super.key});

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
            child: Padding(
          padding: const EdgeInsets.fromLTRB(100, 50, 100, 50),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
              // List.generate(50, (index) => Text('Item $index')),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o Nome Completo do Paciente';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Qual é o Nome de Registro do Paciente?',
                  labelText: 'Nome Completo *',
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: const Row(
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
              ),
              const SizedBox(height: 20),
              Container(
                  margin: const EdgeInsets.fromLTRB(17, 0, 0, 0),
                  child: const RadioButton()),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite a Idade do Paciente';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.cake),
                  hintText: 'Qual é o Idade do Paciente?',
                  labelText: 'Idade *',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o CPF do Paciente';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.pin),
                  hintText: 'Qual é o CPF do Paciente?',
                  labelText: 'CPF *',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite a Escolaridade do Paciente';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.school),
                  hintText: 'Qual é a Escolaridade do Paciente?',
                  labelText: 'Escolaridade *',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite a Cidade onde será realizada essa Sessão de Teste';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.maps_home_work),
                  hintText:
                      'Qual é a Cidade de Realização dessa Sessão de Teste?',
                  labelText: 'Cidade de Realização dessa Sessão de Teste *',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o Estado onde será realizado essa Sessão de Teste';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.map_sharp),
                  hintText:
                      'Qual é o Estado de Realização dessa Sessão de Teste?',
                  labelText: 'Estado de Realização dessa Sessão de Teste *',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: "${(DateTime.now())}",
                decoration: const InputDecoration(
                  icon: Icon(Icons.date_range),
                  hintText: '',
                  labelText: 'Data de Aplicação do Teste *',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushReplacementNamed(
                            context, '/modelotestealternado');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Dados da Sessão Salvos com Sucesso!'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.white),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Salvar'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}

enum SingingCharacter { masculino, feminino, intersexo, outro }

class RadioButton extends StatefulWidget {
  const RadioButton({super.key});

  @override
  State<RadioButton> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioButton> {
  SingingCharacter? _character = SingingCharacter.masculino;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ListTile(
        title: const Text('Masculino'),
        leading: Radio<SingingCharacter>(
          value: SingingCharacter.masculino,
          groupValue: _character,
          onChanged: (SingingCharacter? value) {
            setState(() {
              _character = value;
            });
          },
        ),
      ),
      ListTile(
        title: const Text('Feminino'),
        leading: Radio<SingingCharacter>(
          value: SingingCharacter.feminino,
          groupValue: _character,
          onChanged: (SingingCharacter? value) {
            setState(() {
              _character = value;
            });
          },
        ),
      ),
      ListTile(
        title: const Text('Intersexo'),
        leading: Radio<SingingCharacter>(
          value: SingingCharacter.intersexo,
          groupValue: _character,
          onChanged: (SingingCharacter? value) {
            setState(() {
              _character = value;
            });
          },
        ),
      ),
      ListTile(
          title: const Text('Outro'),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.outro,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
              });
            },
          ))
    ]);
  }
}
