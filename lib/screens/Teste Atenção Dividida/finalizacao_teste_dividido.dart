import 'package:flutter/material.dart';
import 'package:aplicacao/services/firebase_service.dart';

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
/// Agora como StatefulWidget para controlar init e mounted.
class FinalizacaoTesteDividido extends StatefulWidget {
  const FinalizacaoTesteDividido({super.key});

  @override
  State<FinalizacaoTesteDividido> createState() =>
      _FinalizacaoTesteDivididoState();
}

class _FinalizacaoTesteDivididoState extends State<FinalizacaoTesteDividido> {
  bool _isInit = false;
  late final Map<String, dynamic> statsAlternado;
  late final Map<String, dynamic> statsConcentrado;
  late final Map<String, dynamic> statsDividido;
  late final Map<String, dynamic> dadosParaPdf;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      // Pega os argumentos da rota
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ??
              {};

      // Extrai as listas de resultados
      final listaAlternado =
          (args['alternado']['resultados'] as List).cast<Map<String, dynamic>>();
      final listaConcentrado =
          (args['concentrado']['resultados'] as List).cast<Map<String, dynamic>>();
      final listaDividido =
          (args['dividido']['resultados'] as List).cast<Map<String, dynamic>>();

      // Calcula as estatísticas
      statsAlternado = calcularStats(listaAlternado);
      statsConcentrado = calcularStats(listaConcentrado);
      statsDividido = calcularStats(listaDividido);

      // Empacota os dados para o PDF e próxima tela
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
      // 1) Salva a sessão
      final sessionId = await service.saveSession({
        'startedAt': DateTime.now().toIso8601String(),
      });

      // 2) Salva cada bateria de resultados
      await service.saveResults(sessionId, statsAlternado['resultados']);
      await service.saveResults(sessionId, statsConcentrado['resultados']);
      await service.saveResults(sessionId, statsDividido['resultados']);

      // Verifica se o widget ainda está montado antes de navegar
      if (!mounted) return;

      // 3) Navega para Próximos Passos
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
