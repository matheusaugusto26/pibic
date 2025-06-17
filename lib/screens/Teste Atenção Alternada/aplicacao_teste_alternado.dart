import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aplicacao/services/resultados_cache.dart';

class AplicacaoTesteAlternado extends StatefulWidget {
  const AplicacaoTesteAlternado({super.key});

  @override
  State<AplicacaoTesteAlternado> createState() => _AplicacaoTesteAlternadoState();
}

class _AplicacaoTesteAlternadoState extends State<AplicacaoTesteAlternado> {
  final FocusNode _focusNode = FocusNode();
  final Stopwatch _stopTroca = Stopwatch();

  int numEsquerda = 1;
  int numDireita = 1;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _stopTroca.start();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _mudarImagens() {
    final tempoTroca = _stopTroca.elapsedMilliseconds;
    _stopTroca.reset();
    _stopTroca.start();

    setState(() {
      numEsquerda = Random().nextInt(19) + 1;
      numDireita = Random().nextInt(19) + 1;
    });

    ResultadosCache.resultadosAlternado.add({
      'tipo': 'troca',
      'tempoTroca': tempoTroca,
      'numEsquerda': numEsquerda,
      'numDireita': numDireita,
    });
  }

  void _registrarReacao() {
    final tempoReacao = _stopTroca.elapsedMilliseconds;

    ResultadosCache.resultadosAlternado.add({
      'tipo': 'reacao',
      'tempoReacao': tempoReacao,
      'acerto': numEsquerda == numDireita,
      'numEsquerda': numEsquerda,
      'numDireita': numDireita,
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            _mudarImagens();
          }
          if (event.logicalKey == LogicalKeyboardKey.space) {
            _registrarReacao();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Aplicação do Teste Alternado'),
          centerTitle: true,
        ),
        body: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset('assets/images/img$numEsquerda.png'),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset('assets/images/img$numDireita.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
