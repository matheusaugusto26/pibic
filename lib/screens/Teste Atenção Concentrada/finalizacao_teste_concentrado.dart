import 'package:flutter/material.dart';

/// Tela de finalização do Teste de Atenção Concentrada
/// Não exibe estatísticas, apenas armazena para uso posterior no PDF.
class FinalizacaoTesteConcentrado extends StatelessWidget {
  const FinalizacaoTesteConcentrado({super.key});

  @override
  Widget build(BuildContext context) {
    // Recebe dados da etapa anterior (Teste Alternado)
    final Map<String, dynamic> dadosPrevios =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ??
            {};
    final alternado = dadosPrevios['alternado'] as Map<String, dynamic>? ?? {};
    // Recebe resultados deste teste (Concentrado)
    final resultadosConcentrado =
        alternado['resultadosConcentrado'] as List<Map<String, dynamic>>? ?? [];

    // Cálculo das estatísticas para este teste
    final totalC = resultadosConcentrado.length;
    final somaTemposC = resultadosConcentrado.fold<int>(
      0,
      (soma, item) => soma + (item['tempo'] as int),
    );
    final tempoMedioC = totalC > 0 ? somaTemposC / totalC : 0.0;
    final acertosC =
        resultadosConcentrado.where((item) => item['acerto'] == true).length;
    final errosC = totalC - acertosC;
    final taxaAcertoC = totalC > 0 ? (acertosC / totalC) * 100 : 0.0;

    // Construção dos dados sequenciais para o próximo passo
    final Map<String, dynamic> dadosParaProximo = {
      'alternado': alternado,
      'concentrado': {
        'resultados': resultadosConcentrado,
        'total': totalC,
        'somaTempos': somaTemposC,
        'tempoMedio': tempoMedioC,
        'acertos': acertosC,
        'erros': errosC,
        'taxaAcerto': taxaAcertoC,
      },
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blue.shade100,
        title: const Text('Finalização: Atenção Concentrada'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Parabéns! Você terminou o Teste de Atenção Concentrada!',
              style: TextStyle(fontSize: 28),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/modelotestedividido',
                  arguments: dadosParaProximo,
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.white,
              ),
              child: const Text('Vamos para o Modelo do Teste Dividido!'),
            ),
          ],
        ),
      ),
    );
  }
}
