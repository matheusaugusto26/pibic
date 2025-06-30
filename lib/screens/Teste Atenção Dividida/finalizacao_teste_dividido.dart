import 'package:aplicacao/services/resultados_cache.dart';
import 'package:aplicacao/services/sessao_cache.dart';
import 'package:aplicacao/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Map<String, dynamic> calcularStats(List<Map<String, dynamic>> resultados) {
  final total = resultados.length;

  final acertos = resultados.where((r) => r['tipoResposta'] == 'acerto').toList();
  final erros = resultados.where((r) => r['tipoResposta'] == 'erro').toList();
  final omissoes = resultados.where((r) => r['tipoResposta'] == 'omissao').toList();

  final temposAcertos = acertos
      .where((r) => r.containsKey('tempoReacao'))
      .map((r) => r['tempoReacao'] as int)
      .toList();

  final somaTempos = temposAcertos.fold<int>(0, (soma, t) => soma + t);
  final tempoMedio = temposAcertos.isNotEmpty ? somaTempos / temposAcertos.length : 0.0;
  final tempoMinimo = temposAcertos.isNotEmpty ? temposAcertos.reduce((a, b) => a < b ? a : b) : 0;
  final tempoMaximo = temposAcertos.isNotEmpty ? temposAcertos.reduce((a, b) => a > b ? a : b) : 0;

  return {
    'resultados': resultados,
    'total': total,
    'acertos': acertos.length,
    'erros': erros.length,
    'omissoes': omissoes.length,
    'tempoAcertos': {
      'soma': somaTempos,
      'media': tempoMedio,
      'minimo': tempoMinimo,
      'maximo': tempoMaximo,
    },
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
      await Firebase.initializeApp();

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
        SnackBar(
          content: Text('Erro ao salvar resultados: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Finalização: Atenção Dividida'),
        centerTitle: true,
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
              child: const Text('Salvar e Prosseguir'),
            ),
          ],
        ),
      ),
    );
  }
}
