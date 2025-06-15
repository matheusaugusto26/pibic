import 'package:flutter/material.dart';
import 'package:aplicacao/services/firebase_service.dart'; // <— adicione isto

/// Calcula estatísticas básicas (total, soma de tempos, média, acertos, erros e taxa)
Map<String, dynamic> calcularStats(List<Map<String, dynamic>> resultados) {
  final total = resultados.length;
  final somaTempos = resultados.fold<int>(
    0,
    (soma, resultado) => soma + (resultado['tempo'] as int),
  );
  final tempoMedio = total > 0 ? somaTempos / total : 0.0;
  final acertos = resultados.where((r) => r['acerto'] == true).length;
  final erros = total - acertos;
  final taxaAcerto = total > 0 ? (acertos / total) * 100 : 0.0;

  return {
    'resultados': resultados,
    'total': total,
    'somaTempos': somaTempos,
    'tempoMedio': tempoMedio,
    'acertos': acertos,
    'erros': erros,
    'taxaAcerto': taxaAcerto,
  };
}

/// Tela de finalização do Teste de Atenção Dividida
/// Salva sessão e resultados no Firebase antes de prosseguir.
class FinalizacaoTesteDividido extends StatelessWidget {
  const FinalizacaoTesteDividido({super.key});

  @override
  Widget build(BuildContext context) {
    // Captura o contexto local para uso após await
    final localContext = context;

    // Recebe dados das etapas anteriores e resultados brutos
    final dadosPrevios =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {};
    final alternado = dadosPrevios['alternado'] as Map<String, dynamic>? ?? {};
    final concentrado = dadosPrevios['concentrado'] as Map<String, dynamic>? ?? {};
    final dividido = dadosPrevios['dividido'] as Map<String, dynamic>? ?? {};

    final listaAlternado =
        (alternado['resultados'] as List).cast<Map<String, dynamic>>();
    final listaConcentrado =
        (concentrado['resultados'] as List).cast<Map<String, dynamic>>();
    final listaDividido =
        (dividido['resultados'] as List).cast<Map<String, dynamic>>();

    // Gera estatísticas
    final statsAlternado = calcularStats(listaAlternado);
    final statsConcentrado = calcularStats(listaConcentrado);
    final statsDividido = calcularStats(listaDividido);

    // Dados a serem passados ao PDF e próxima tela
    final dadosParaPdf = {
      'alternado': statsAlternado,
      'concentrado': statsConcentrado,
      'dividido': statsDividido,
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Finalização: Atenção Dividida'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade100,
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
              onPressed: () async {
                final service = FirebaseService();
                try {
                  // 1) Salva a sessão e obtém o ID
                  final sessionData = {
                    'startedAt': DateTime.now().toIso8601String(),
                  };
                  final sessionId = await service.saveSession(sessionData);

                  // 2) Salva cada bateria de resultados
                  await service.saveResults(
                      sessionId, statsAlternado['resultados']);
                  await service.saveResults(
                      sessionId, statsConcentrado['resultados']);
                  await service.saveResults(
                      sessionId, statsDividido['resultados']);

                  // 3) Navega para Próximos Passos
                  Navigator.pushReplacementNamed(
                    localContext,
                    '/proximospassos',
                    arguments: dadosParaPdf,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(localContext).showSnackBar(
                    SnackBar(content: Text('Erro ao salvar: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.white,
              ),
              child: const Text('Salvar no Firebase e Prosseguir'),
            ),
          ],
        ),
      ),
    );
  }
}
