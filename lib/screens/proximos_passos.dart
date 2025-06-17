// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ProximosPassos extends StatelessWidget {
  const ProximosPassos({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final Map<String, dynamic> dados =
        args is Map<String, dynamic> ? args : {};

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Próximos Passos'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade100,
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
                'Após a leitura minuciosa e qualquer questão sanada com seu neuropsicólogo, você pode fechar esta janela.',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            const ScrollableTextBox(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.white,
              ),
              child: const Text('Começar Nova Sessão de Teste'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                await _exportarPdf(dados);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: const Text('Exportar Relatório em PDF'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportarPdf(Map<String, dynamic> dados) async {
    final pdf = pw.Document();

    void addStats(String titulo, Map<String, dynamic> stats) {
      final total = stats['total'] ?? 0;
      final acertos = stats['acertos'] ?? 0;
      final erros = stats['erros'] ?? 0;
      final taxa = (stats['taxaAcerto'] ?? 0.0).toDouble();
      final soma = stats['somaTempos'] ?? 0;
      final media = (stats['tempoMedio'] ?? 0.0).toDouble();
      final minimo = stats['tempoMinimo'] ?? 0;
      final maximo = stats['tempoMaximo'] ?? 0;

      pdf.addPage(
        pw.MultiPage(
          build: (context) => [
            pw.Header(level: 1, text: titulo),
            pw.Text('Total de respostas: $total'),
            pw.Text('Acertos: $acertos'),
            pw.Text('Erros: $erros'),
            pw.Text('Taxa de acerto: ${taxa.toStringAsFixed(1)}%'),
            pw.Text('Tempo médio de reação: ${media.toStringAsFixed(0)} ms'),
            pw.Text('Tempo mínimo de reação: $minimo ms'),
            pw.Text('Tempo máximo de reação: $maximo ms'),
            pw.Text('Soma total dos tempos de reação: $soma ms'),
          ],
        ),
      );
    }

    addStats('1. Teste de Atenção Alternada', dados['alternado'] ?? {});
    addStats('2. Teste de Atenção Concentrada', dados['concentrado'] ?? {});
    addStats('3. Teste de Atenção Dividida', dados['dividido'] ?? {});

    final totalGeral = [
      dados['alternado']?['total'] ?? 0,
      dados['concentrado']?['total'] ?? 0,
      dados['dividido']?['total'] ?? 0
    ].reduce((a, b) => a + b);

    final acertosGeral = [
      dados['alternado']?['acertos'] ?? 0,
      dados['concentrado']?['acertos'] ?? 0,
      dados['dividido']?['acertos'] ?? 0
    ].reduce((a, b) => a + b);

    final percFinal =
        totalGeral > 0 ? (acertosGeral / totalGeral) * 100 : 0.0;

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Divider(),
          pw.Header(level: 1, text: 'Resultado Final Geral'),
          pw.Text('Total de respostas: $totalGeral'),
          pw.Text('Acertos totais: $acertosGeral'),
          pw.Text('Porcentagem final de acerto: ${percFinal.toStringAsFixed(1)}%'),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
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
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Lorem ipsum dolor sit amet...',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
