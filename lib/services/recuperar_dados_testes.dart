import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> recuperarDadosCalculados(String sessionId) async {
  final resultadosSnapshot = await FirebaseFirestore.instance
      .collection('sessions')
      .doc(sessionId)
      .collection('results')
      .get();

  final resultados = resultadosSnapshot.docs.map((doc) => doc.data()).toList();

  final testes = ['Alternado', 'Concentrado', 'Dividido'];
  final dadosPorTeste = <String, Map<String, dynamic>>{};

  for (final tipo in testes) {
    final resultadoTeste = resultados.where((r) => r['tipoTeste'] == tipo).toList();

    final reacoes = resultadoTeste.where((r) => r['tipo'] == 'reacao').toList();
    final trocas = resultadoTeste.where((r) => r['tipo'] == 'troca').toList();

    final acertos = reacoes.where((r) => r['tipoResposta'] == 'acerto').toList();
    final erros = reacoes.where((r) => r['tipoResposta'] == 'erro').toList();
    final omissoes = reacoes.where((r) => r['tipoResposta'] == 'omissao').toList();

    List<int> temposReacao = acertos
        .where((r) => r.containsKey('tempoReacao'))
        .map((r) => (r['tempoReacao'] as num).toInt())
        .toList();

    List<int> temposTroca = trocas
        .where((r) => r.containsKey('tempoTroca'))
        .map((r) => (r['tempoTroca'] as num).toInt())
        .toList();

    Map<String, dynamic> tempoStats(List<int> lista) {
      if (lista.isEmpty) {
        return {'minimo': 0, 'maximo': 0, 'media': 0};
      }
      final min = lista.reduce((a, b) => a < b ? a : b);
      final max = lista.reduce((a, b) => a > b ? a : b);
      final media = lista.reduce((a, b) => a + b) ~/ lista.length;
      return {'minimo': min, 'maximo': max, 'media': media};
    }

    dadosPorTeste[tipo.toLowerCase()] = {
      'total': reacoes.length,
      'acertos': acertos.length,
      'erros': erros.length,
      'omissoes': omissoes.length,
      'tempoReacao': tempoStats(temposReacao),
      'tempoTroca': tempoStats(temposTroca),
    };
  }

  return dadosPorTeste;
}