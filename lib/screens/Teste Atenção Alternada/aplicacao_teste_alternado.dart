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
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    _focusNode.dispose();
    super.dispose();
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == PhysicalKeyboardKey.arrowRight) {
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
      if (event.logicalKey == PhysicalKeyboardKey.space) {
        final tempoReacao = _stopTroca.elapsedMilliseconds;
        ResultadosCache.resultadosAlternado.add({
          'tipo': 'reacao',
          'tempoReacao': tempoReacao,
          'acerto': numEsquerda == numDireita,
          'numEsquerda': numEsquerda,
          'numDireita': numDireita,
        });
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        appBar: AppBar(title: const Text('Teste Alternado')),
        body: Row(
          children: [
            Expanded(child: Image.asset('assets/images/img$numEsquerda.png')),
            Expanded(child: Image.asset('assets/images/img$numDireita.png')),
          ],
        ),
      ),
    );
  }
}
