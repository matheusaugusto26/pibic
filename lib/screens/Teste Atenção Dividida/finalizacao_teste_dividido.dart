import 'package:aplicacao/services/resultados_cache.dart';
import 'package:aplicacao/services/sessao_cache.dart';
import 'package:aplicacao/services/firebase_service.dart';
import 'package:flutter/material.dart';

Map<String, dynamic> calcularStats(List<Map<String, dynamic>> resultados) {
  final reacoes = resultados.where((r) => r['tipo'] == 'reacao').toList();
  final trocas = resultados.where((r) => r['tipo'] == 'troca').toList();

  final acertos = reacoes.where((r) => r['tipoResposta'] == 'acerto').toList();
  final erros = reacoes.where((r) => r['tipoResposta'] == 'erro').toList();
  final omissoes = reacoes.where((r) => r['tipoResposta'] == 'omissao').toList();

  final temposReacao = reacoes
      .where((r) => r.containsKey('tempoReacao') && r['tempoReacao'] is int)
      .map((r) => r['tempoReacao'] as int)
      .toList();

  final temposTroca = trocas
      .where((r) => r.containsKey('tempoTroca') && r['tempoTroca'] is int)
      .map((r) => r['tempoTroca'] as int)
      .toList();

  final somaReacao = temposReacao.fold(0, (soma, t) => soma + t);
  final mediaReacao = temposReacao.isNotEmpty ? somaReacao / temposReacao.length : 0.0;
  final minReacao = temposReacao.isNotEmpty ? temposReacao.reduce((a, b) => a < b ? a : b) : 0;
  final maxReacao = temposReacao.isNotEmpty ? temposReacao.reduce((a, b) => a > b ? a : b) : 0;

  final somaTroca = temposTroca.fold(0, (soma, t) => soma + t);
  final mediaTroca = temposTroca.isNotEmpty ? somaTroca / temposTroca.length : 0.0;
  final minTroca = temposTroca.isNotEmpty ? temposTroca.reduce((a, b) => a < b ? a : b) : 0;
  final maxTroca = temposTroca.isNotEmpty ? temposTroca.reduce((a, b) => a > b ? a : b) : 0;

  final totalTentativas = acertos.length + erros.length + omissoes.length;

  return {
    'resultados': resultados,
    'total': totalTentativas,
    'acertos': acertos.length,
    'erros': erros.length,
    'omissoes': omissoes.length,
    'tempoReacao': {
      'media': mediaReacao,
      'minimo': minReacao,
      'maximo': maxReacao,
    },
    'tempoTroca': {
      'media': mediaTroca,
      'minimo': minTroca,
      'maximo': maxTroca,
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
