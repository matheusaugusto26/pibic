import 'package:flutter/material.dart';
import 'package:aplicacao/services/relatorio_pdf.dart';

class ProximosPassos extends StatelessWidget {
  const ProximosPassos({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final Map<String, dynamic> dados = args is Map<String, dynamic> ? args : {};

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Próximos Passos'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Estes são os Próximos Passos para continuar a sua Avaliação Neuropsicológica.\n'
                'Após a leitura minuciosa, caso tenha qualquer dúvida, compartilhe com seu neuropsicólogo',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            const ScrollableTextBox(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('Começar Nova Sessão de Teste'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                await exportarRelatorioPdf(dados, context);
              },
              child: const Text('Exportar Relatório em PDF'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/resultadosAnteriores');
              },
              child: const Text('Ver resultados anteriores'),
            ),
          ],
        ),
      ),
    );
  }
}

class ScrollableTextBox extends StatelessWidget {
  const ScrollableTextBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 800,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '''
1. Informe ao neuropsicólogo que o teste foi finalizado.
2. Os dados coletados já foram registrados no sistema.
3. Caso tenha dúvidas sobre o procedimento, comunique imediatamente.

Lembre-se:
Este teste faz parte de um processo mais amplo de investigação. Apenas um profissional habilitado pode interpretar os dados.

Após a leitura, o neuropsicólogo prosseguirá de acordo.
''',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
