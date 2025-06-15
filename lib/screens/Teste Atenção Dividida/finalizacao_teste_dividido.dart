import 'package:flutter/material.dart';

/// Tela de finalização do Teste de Atenção Dividida
/// Não exibe estatísticas, apenas armazena para uso posterior no PDF.
class FinalizacaoTesteDividido extends StatelessWidget {
  const FinalizacaoTesteDividido({super.key});

  @override
  Widget build(BuildContext context) {
    // Recebe dados das etapas anteriores (Alternado e Concentrado) e os resultados do Teste Dividido
    final Map<String, dynamic> dadosPrevios =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {};
    final alternado = dadosPrevios['alternado'] as Map<String, dynamic>? ?? {};
    final concentrado = dadosPrevios['concentrado'] as Map<String, dynamic>? ?? {};
    final dividido = dadosPrevios['dividido'] as Map<String, dynamic>? ?? {};

    // Lista de resultados brutos do teste dividido
    final List<Map<String, dynamic>> resultadosDividido =
        dividido['resultados'] as List<Map<String, dynamic>>? ?? [];

    // Cálculo das estatísticas do Teste Dividido
    final int totalD = resultadosDividido.length;
    final int somaTemposD = resultadosDividido.fold<int>(
        0, (soma, item) => soma + (item['tempo'] as int));
    final double tempoMedioD = totalD > 0 ? somaTemposD / totalD : 0.0;
    final int acertosD =
        resultadosDividido.where((item) => item['acerto'] == true).length;
    final int errosD = totalD - acertosD;
    final double taxaAcertoD =
        totalD > 0 ? (acertosD / totalD) * 100 : 0.0;

    // Dados completos para geração de PDF
    final Map<String, dynamic> dadosParaPdf = {
      'alternado': alternado,
      'concentrado': concentrado,
      'dividido': {
        'resultados': resultadosDividido,
        'total': totalD,
        'somaTempos': somaTemposD,
        'tempoMedio': tempoMedioD,
        'acertos': acertosD,
        'erros': errosD,
        'taxaAcerto': taxaAcertoD,
      },
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blue.shade100,
        title: const Text('Finalização: Atenção Dividida'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Parabéns! Você terminou Todos os Testes!',
              style: TextStyle(fontSize: 28),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Navega para próximos passos, passando todo o pacote de dados para gerar o PDF
                Navigator.pushReplacementNamed(
                  context,
                  '/proximospassos',
                  arguments: dadosParaPdf,
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.white,
              ),
              child: const Text('Vamos para os Próximos Passos!'),
            ),
          ],
        ),
      ),
    );
  }
}
