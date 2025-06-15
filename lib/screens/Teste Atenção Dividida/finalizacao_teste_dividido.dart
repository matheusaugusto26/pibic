import 'package:flutter/material.dart';
import 'package:aplicacao/services/firebase_service.dart';

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

/// Tela de finalização do Teste de Atenção Dividida
/// Recebe os dados de alternado, concentrado e dividido, salva no Firebase e passa adiante.
class FinalizacaoTesteDividido extends StatefulWidget {
  const FinalizacaoTesteDividido({super.key});

  @override
  State<FinalizacaoTesteDividido> createState() =>
      _FinalizacaoTesteDivididoState();
}

class _FinalizacaoTesteDivididoState
    extends State<FinalizacaoTesteDividido> {
  bool _isInit = false;
  late final Map<String, dynamic> statsAlternado;
  late final Map<String, dynamic> statsConcentrado;
  late final Map<String, dynamic> statsDividido;
  late final Map<String, dynamic> dadosParaPdf;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ??
              {};

      // Extrai o mapa de estatísticas de alternado (já contém 'resultados', 'total', etc.)
      final alternadoMap = args['alternado'] as Map<String, dynamic>? ?? {};
      // Extrai o mapa de estatísticas de concentrado
      final concentradoMap =
          args['concentrado'] as Map<String, dynamic>? ?? {};
      // Extrai a lista bruta de resultados divididos
      final divididoMap = args['dividido'] as Map<String, dynamic>? ?? {};

      // Converte as listas dinamicamente tipadas
      final listaAlternado = List<Map<String, dynamic>>.from(
        alternadoMap['resultados'] as List<dynamic>? ?? [],
      );
      final listaConcentrado = List<Map<String, dynamic>>.from(
        concentradoMap['resultados'] as List<dynamic>? ?? [],
      );
      final listaDividido = List<Map<String, dynamic>>.from(
        divididoMap['resultados'] as List<dynamic>? ?? [],
      );

      // Calcula estatísticas finais de cada bateria
      statsAlternado = calcularStats(listaAlternado);
      statsConcentrado = calcularStats(listaConcentrado);
      statsDividido = calcularStats(listaDividido);

      // Prepara o pacote completo para PDF e próxima tela
      dadosParaPdf = {
        'alternado': statsAlternado,
        'concentrado': statsConcentrado,
        'dividido': statsDividido,
      };

      _isInit = true;
    }
  }

  Future<void> _salvarEProsseguir() async {
    final service = FirebaseService();
    try {
      // 1) Salva a sessão e obtém um ID
      final sessionId = await service.saveSession({
        'startedAt': DateTime.now().toIso8601String(),
      });

      // 2) Salva resultados de cada bateria
      await service.saveResults(sessionId, statsAlternado['resultados']);
      await service.saveResults(sessionId, statsConcentrado['resultados']);
      await service.saveResults(sessionId, statsDividido['resultados']);

      if (!mounted) return;
      // 3) Navega para Próximos Passos com o pacote completo
      Navigator.pushReplacementNamed(
        context,
        '/proximospassos',
        arguments: dadosParaPdf,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar resultados: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: _salvarEProsseguir,
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
