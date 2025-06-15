import 'package:flutter/material.dart';

/// Tela de finalização do Teste de Atenção Alternada
/// Não exibe estatísticas, apenas armazena para uso posterior no PDF.
class FinalizacaoTesteAlternado extends StatelessWidget {
  const FinalizacaoTesteAlternado({super.key});

  @override
  Widget build(BuildContext context) {
    // Recupera os resultados passados como argumento de rota
    final List<Map<String, dynamic>> resultados =
        ModalRoute.of(context)!.settings.arguments as List<Map<String, dynamic>>? ?? [];

    // Cálculo das estatísticas (armazenadas em memória, não exibidas)
    final int total = resultados.length;
    final int somaTempos = resultados.fold<int>(
      0,
      (soma, item) => soma + (item['tempo'] as int),
    );
    final double tempoMedio = total > 0 ? somaTempos / total : 0.0;
    final int acertos = resultados.where((item) => item['acerto'] == true).length;
    final int erros = total - acertos;
    final double taxaAcerto = total > 0 ? (acertos / total) * 100 : 0.0;

    // Dados a serem enviados sequencialmente para a próxima etapa
    final Map<String, dynamic> dadosParaProximoTeste = {
      'alternado': {
        'resultados': resultados,
        'total': total,
        'somaTempos': somaTempos,
        'tempoMedio': tempoMedio,
        'acertos': acertos,
        'erros': erros,
        'taxaAcerto': taxaAcerto,
      },
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blue.shade100,
        title: const Text('Finalização: Atenção Alternada'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Parabéns! Você terminou o Teste de Atenção Alternada!',
              style: TextStyle(fontSize: 28),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Navega para o modelo do Teste de Atenção Concentrada, mantendo a ordem dos testes
                Navigator.pushReplacementNamed(
                  context,
                  '/modelotesteconcentrado',
                  arguments: dadosParaProximoTeste,
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.white,
              ),
              child: const Text('Vamos para o Modelo do Teste Concentrado!'),
            ),
          ],
        ),
      ),
    );
  }
}
