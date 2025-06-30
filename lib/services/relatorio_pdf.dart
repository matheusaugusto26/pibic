import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> exportarRelatorioPdf(Map<String, dynamic> dados, BuildContext context) async {
  final pdf = pw.Document();

  pw.Widget buildTempoTable(String titulo, Map<String, dynamic> tempo) {
    final media = (tempo['media'] ?? 0).toDouble();
    final minimo = tempo['minimo'] ?? 0;
    final maximo = tempo['maximo'] ?? 0;

    return pw.Column(children: [
      pw.Text(titulo, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
      pw.Table(
        border: pw.TableBorder.all(width: 0.5),
        children: [
          pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                pw.Text('Média', textAlign: pw.TextAlign.center),
                pw.Text('Mínimo', textAlign: pw.TextAlign.center),
                pw.Text('Máximo', textAlign: pw.TextAlign.center),
              ]),
          pw.TableRow(children: [
            pw.Text('${media.toStringAsFixed(0)}', textAlign: pw.TextAlign.center),
            pw.Text('$minimo', textAlign: pw.TextAlign.center),
            pw.Text('$maximo', textAlign: pw.TextAlign.center),
          ]),
        ],
      ),
    ]);
  }

  pw.Widget buildSection(String title, Map<String, dynamic> stats) {
    final total = stats['total'] ?? 0;
    final acertos = stats['acertos'] ?? 0;
    final erros = stats['erros'] ?? 0;
    final omissoes = stats['omissoes'] ?? 0;
    final tempoReacao = stats['tempoReacao'] as Map<String, dynamic>? ?? {};
    final tempoTroca = stats['tempoTroca'] as Map<String, dynamic>? ?? {};

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 8),
        pw.Text(title, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 4),
        pw.Table(
          border: pw.TableBorder.all(width: 0.5),
          children: [
            pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
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
        pw.SizedBox(height: 6),
        buildTempoTable('Tempo de Reação (ms)', tempoReacao),
        pw.SizedBox(height: 6),
        buildTempoTable('Tempo de Troca (ms)', tempoTroca),
      ],
    );
  }

  final totalGeral = <int>[
    dados['alternado']?['total'] ?? 0,
    dados['concentrado']?['total'] ?? 0,
    dados['dividido']?['total'] ?? 0,
  ].fold(0, (a, b) => a + b);

  final acertosGeral = <int>[
    dados['alternado']?['acertos'] ?? 0,
    dados['concentrado']?['acertos'] ?? 0,
    dados['dividido']?['acertos'] ?? 0,
  ].fold(0, (a, b) => a + b);

  final percFinal = totalGeral > 0 ? (acertosGeral / totalGeral) * 100 : 0.0;

  pdf.addPage(
    pw.Page(
      margin: const pw.EdgeInsets.all(24),
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Relatório de Testes de Atenção', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 12),
          buildSection('1. Teste de Atenção Alternada', dados['alternado'] ?? {}),
          buildSection('2. Teste de Atenção Concentrada', dados['concentrado'] ?? {}),
          buildSection('3. Teste de Atenção Dividida', dados['dividido'] ?? {}),
          pw.Divider(),
          pw.SizedBox(height: 6),
          pw.Text('Resumo Geral', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.Text('Total de respostas: $totalGeral'),
          pw.Text('Acertos totais: $acertosGeral'),
          pw.Text('Porcentagem final de acerto: ${percFinal.toStringAsFixed(1)}%'),
        ],
      ),
    ),
  );

  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PDF exportado com sucesso!')),
    );
  }
}
