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
                'Após a leitura minuciosa e qualquer dúvida sanada com seu neuropsicólogo, você pode fechar esta janela.',
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
                await _exportarPdf(dados, context);
              },
              child: const Text('Exportar Relatório em PDF'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportarPdf(
      Map<String, dynamic> dados, BuildContext context) async {
    final pdf = pw.Document();

    pw.Widget buildTable(String titulo, Map<String, dynamic> stats) {
      final total = stats['total'] ?? 0;
      final acertos = stats['acertos'] ?? 0;
      final erros = stats['erros'] ?? 0;
      final omissoes = stats['omissoes'] ?? 0;
      final tempo = stats['tempoAcertos'] ?? {};

      final soma = tempo['soma'] ?? 0;
      final media = (tempo['media'] ?? 0.0).toDouble();
      final minimo = tempo['minimo'] ?? 0;
      final maximo = tempo['maximo'] ?? 0;

      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(titulo, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(children: [
                pw.Text('Total', textAlign: pw.TextAlign.center),
                pw.Text('Acertos', textAlign: pw.TextAlign.center),
                pw.Text('Erros', textAlign: pw.TextAlign.center),
                pw.Text('Omissões', textAlign: pw.TextAlign.center),
              ]),
              pw.TableRow(children: [
                pw.Text('$total', textAlign: pw.TextAlign.center),
                pw.Text('$acertos', textAlign: pw.TextAlign.center),
                pw.Text('$erros', textAlign: pw.TextAlign.center),
                pw.Text('$omissoes', textAlign: pw.TextAlign.center),
              ]),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(children: [
                pw.Text('Tempo Total', textAlign: pw.TextAlign.center),
                pw.Text('Média (ms)', textAlign: pw.TextAlign.center),
                pw.Text('Mínimo (ms)', textAlign: pw.TextAlign.center),
                pw.Text('Máximo (ms)', textAlign: pw.TextAlign.center),
              ]),
              pw.TableRow(children: [
                pw.Text('$soma', textAlign: pw.TextAlign.center),
                pw.Text('${media.toStringAsFixed(0)}', textAlign: pw.TextAlign.center),
                pw.Text('$minimo', textAlign: pw.TextAlign.center),
                pw.Text('$maximo', textAlign: pw.TextAlign.center),
              ]),
            ],
          ),
          pw.SizedBox(height: 12),
        ],
      );
    }

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

    final percFinal = totalGeral > 0 ? (acertosGeral / totalGeral) * 100 : 0.0;

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            buildTable('1. Teste de Atenção Alternada', dados['alternado'] ?? {}),
            buildTable('2. Teste de Atenção Concentrada', dados['concentrado'] ?? {}),
            buildTable('3. Teste de Atenção Dividida', dados['dividido'] ?? {}),
            pw.Divider(),
            pw.Text('Resumo Geral', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.Text('Total de respostas: $totalGeral'),
            pw.Text('Acertos totais: $acertosGeral'),
            pw.Text('Porcentagem final de acerto: ${percFinal.toStringAsFixed(1)}%'),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF exportado com sucesso!')),
      );
    }
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
              'Lorem ipsum dolor sit amet...',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
