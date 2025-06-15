// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ProximosPassos extends StatelessWidget {
  const ProximosPassos({super.key});

  @override
  Widget build(BuildContext context) {
    // Recupera todos os dados para gerar o PDF
    final Map<String, dynamic> dados =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {};

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
            // Botão existente para nova sessão
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
            // Botão para exportar PDF
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

    // Extrai estatísticas de cada teste
    final alt = dados['alternado'] as Map<String, dynamic>? ?? {};
    final conc = dados['concentrado'] as Map<String, dynamic>? ?? {};
    final divi = dados['dividido'] as Map<String, dynamic>? ?? {};

    // Cálculo da porcentagem final acumulada
    final totalGeral =
        (alt['total'] as int? ?? 0) + (conc['total'] as int? ?? 0) + (divi['total'] as int? ?? 0);
    final acertosGeral =
        (alt['acertos'] as int? ?? 0) + (conc['acertos'] as int? ?? 0) + (divi['acertos'] as int? ?? 0);
    final percFinal = totalGeral > 0 ? (acertosGeral / totalGeral) * 100 : 0.0;

    // Adiciona páginas com estatísticas de cada teste
    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, text: 'Relatório de Avaliação Neuropsicológica'),
          pw.Header(level: 1, text: '1. Teste de Atenção Alternada'),
          pw.Text('Total de respostas: ${alt['total'] ?? 0}'),
          pw.Text('Acertos: ${alt['acertos'] ?? 0}'),
          pw.Text('Erros: ${alt['erros'] ?? 0}'),
          pw.Text('Taxa de acerto: ${ (alt['taxaAcerto'] as double? ?? 0.0).toStringAsFixed(1) }%'),
          pw.Text('Tempo médio de reação: ${ (alt['tempoMedio'] as double? ?? 0.0).toStringAsFixed(0) } ms'),
          pw.SizedBox(height: 12),
          pw.Header(level: 1, text: '2. Teste de Atenção Concentrada'),
          pw.Text('Total de respostas: ${conc['total'] ?? 0}'),
          pw.Text('Acertos: ${conc['acertos'] ?? 0}'),
          pw.Text('Erros: ${conc['erros'] ?? 0}'),
          pw.Text('Taxa de acerto: ${ (conc['taxaAcerto'] as double? ?? 0.0).toStringAsFixed(1) }%'),
          pw.Text('Tempo médio de reação: ${ (conc['tempoMedio'] as double? ?? 0.0).toStringAsFixed(0) } ms'),
          pw.SizedBox(height: 12),
          pw.Header(level: 1, text: '3. Teste de Atenção Dividida'),
          pw.Text('Total de respostas: ${divi['total'] ?? 0}'),
          pw.Text('Acertos: ${divi['acertos'] ?? 0}'),
          pw.Text('Erros: ${divi['erros'] ?? 0}'),
          pw.Text('Taxa de acerto: ${ (divi['taxaAcerto'] as double? ?? 0.0).toStringAsFixed(1) }%'),
          pw.Text('Tempo médio de reação: ${ (divi['tempoMedio'] as double? ?? 0.0).toStringAsFixed(0) } ms'),
          pw.Divider(),
          pw.Header(level: 1, text: 'Resultado Final'),
          pw.Text('Total Geral: $totalGeral respostas'),
          pw.Text('Acertos Gerais: $acertosGeral'),
          pw.Text('Porcentagem Final de Acerto: ${percFinal.toStringAsFixed(1)}%'),
        ],
      ),
    );

    // Layout/Salvamento do PDF
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
              // Seu texto explicativo aqui
              'Lorem ipsum dolor sit amet...',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}