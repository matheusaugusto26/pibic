import 'package:flutter/material.dart';

/// Tela de finalização do Teste de Atenção Alternada
/// Não exibe estatísticas, apenas prepara os dados para o próximo teste.
class FinalizacaoTesteAlternado extends StatelessWidget {
  const FinalizacaoTesteAlternado({super.key});

  @override
  Widget build(BuildContext context) {
    // 1) Recupera a lista de resultados vindos de AplicacaoTesteAlternado
    final resultadosLista = (ModalRoute.of(context)!.settings.arguments
            as List<dynamic>? ??
        [])
        .cast<Map<String, dynamic>>();

    // 2) Calcula estatísticas
    final int total = resultadosLista.length;
    final int somaTempos = resultadosLista.fold<int>(
      0,
      (soma, item) => soma + (item['tempo'] as int),
    );
    final double tempoMedio = total > 0 ? somaTempos / total : 0.0;
    final int acertos =
        resultadosLista.where((item) => item['acerto'] == true).length;
    final int erros = total - acertos;
    final double taxaAcerto = total > 0 ? (acertos / total) * 100 : 0.0;

    // 3) Empacota tudo num Map para enviar ao próximo teste
    final Map<String, dynamic> dadosAlternado = {
      'alternado': {
        'resultados': resultadosLista,
        'total': total,
        'somaTempos': somaTempos,
        'tempoMedio': tempoMedio,
        'acertos': acertos,
        'erros': erros,
        'taxaAcerto': taxaAcerto,
      },
    };

    // 4) Exibe a tela de finalização e botão para ir ao modelo do próximo teste
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Finalização: Atenção Alternada'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade100,
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
                // Navega para o modelo do Teste Concentrado,
                // passando os dados do alternado
                print('✅ Total de respostas no Alternado: ${dadosAlternado.length}');
                Navigator.pushReplacementNamed(
                  context,
                  '/modelotesteconcentrado',
                  arguments: dadosAlternado,
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

