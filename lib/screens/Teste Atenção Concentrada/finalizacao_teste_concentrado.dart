import 'package:flutter/material.dart';

/// Calcula estatísticas básicas (total, soma de tempos, média, acertos, erros e taxa)
Map<String, dynamic> calcularStats(List<Map<String, dynamic>> resultados) {
  final total = resultados.length;
  final somaTempos = resultados.fold<int>(
    0,
    (soma, r) => soma + (r['tempo'] as int),
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

/// Tela de finalização do Teste de Atenção Concentrada
/// Recebe dados de alternado e concentrado e inicia o fluxo do teste dividido.
class FinalizacaoTesteConcentrado extends StatelessWidget {
  const FinalizacaoTesteConcentrado({super.key});

  @override
  Widget build(BuildContext context) {
    // 1) Recupera o Map com 'alternado' e 'concentrado'
    final args = ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>? ?? {};

    // 2) Extrai o Map do alternado
    final alternadoMap = args['alternado'] as Map<String, dynamic>? ?? {};
    // 3) Ajusta aqui o listaAlternado para ser List<Map<…>>
    final List<Map<String, dynamic>> listaAlternado =
        List<Map<String, dynamic>>.from(
            alternadoMap['resultados'] as List<dynamic>? ?? []);

    // 4) Extrai a lista bruta de resultados do concentrado
    final List<Map<String, dynamic>> listaConcentrado =
        List<Map<String, dynamic>>.from(
            args['concentrado'] as List<dynamic>? ?? []);

    // 5) Calcula estatísticas de cada bateria
    final statsAlternado = calcularStats(listaAlternado);
    final statsConcentrado = calcularStats(listaConcentrado);

    // 6) Prepara o pacote para o próximo teste
    final dadosParaDividido = {
      'alternado': statsAlternado,
      'concentrado': statsConcentrado,
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Finalização: Atenção Concentrada'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade100,
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
                  arguments: dadosParaDividido,
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
