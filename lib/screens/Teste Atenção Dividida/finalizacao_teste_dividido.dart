import 'package:aplicacao/services/resultados_cache.dart';
import 'package:aplicacao/services/sessao_cache.dart';
import 'package:aplicacao/services/firebase_service.dart';
import 'package:flutter/material.dart';

Map<String, dynamic> calcularStats(List<Map<String, dynamic>> resultados) {
  final total = resultados.length;
  final tempos = resultados.map((r) => r['tempo'] as int).toList();

  final somaTempos = tempos.fold<int>(0, (soma, t) => soma + t);
  final tempoMedio = total > 0 ? somaTempos / total : 0.0;
  final tempoMinimo = tempos.isNotEmpty ? tempos.reduce((a, b) => a < b ? a : b) : 0;
  final tempoMaximo = tempos.isNotEmpty ? tempos.reduce((a, b) => a > b ? a : b) : 0;

  final acertos = resultados.where((r) => r['acerto'] == true).length;
  final erros = total - acertos;
  final taxaAcerto = total > 0 ? (acertos / total) * 100 : 0.0;

  return {
    'resultados': resultados,
    'total': total,
    'somaTempos': somaTempos,
    'tempoMedio': tempoMedio,
    'tempoMinimo': tempoMinimo,
    'tempoMaximo': tempoMaximo,
    'acertos': acertos,
    'erros': erros,
    'taxaAcerto': taxaAcerto,
  };
}

class FinalizacaoTesteDividido extends StatefulWidget {
  const FinalizacaoTesteDividido({super.key});

  @override
  State<FinalizacaoTesteDividido> createState() => _FinalizacaoTesteDivididoState();
}

class _FinalizacaoTesteDivididoState extends State<FinalizacaoTesteDividido> {
  late final Map<String, dynamic> statsAlternado;
  late final Map<String, dynamic> statsConcentrado;
  late final Map<String, dynamic> statsDividido;
  late final Map<String, dynamic> dadosParaPdf;

  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      statsAlternado = calcularStats(ResultadosCache.resultadosAlternado);
      statsConcentrado = calcularStats(ResultadosCache.resultadosConcentrado);
      statsDividido = calcularStats(ResultadosCache.resultadosDividido);

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
      final sessionData = {
        ...?SessaoCache.sessionData,
        'startedAt': DateTime.now().toIso8601String(),
      };

      final sessionId = await service.saveSession(sessionData);

      await service.saveResults(sessionId, statsAlternado['resultados'], 'Alternado');
      await service.saveResults(sessionId, statsConcentrado['resultados'], 'Concentrado');
      await service.saveResults(sessionId, statsDividido['resultados'], 'Dividido');

      if (!mounted) return;

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
