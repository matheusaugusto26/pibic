import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aplicacao/services/resultados_cache.dart';

class AplicacaoTesteConcentrado extends StatefulWidget {
  const AplicacaoTesteConcentrado({super.key});

  @override
  State<AplicacaoTesteConcentrado> createState() => _AplicacaoTesteConcentradoState();
}

class _AplicacaoTesteConcentradoState extends State<AplicacaoTesteConcentrado> {
  final FocusNode _focusNode = FocusNode();
  final Stopwatch _stopTroca = Stopwatch();

  late int numEsquerda;
  int numDireita = 1;

  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      numEsquerda = Random().nextInt(19) + 1;
      _focusNode.requestFocus();
      _stopTroca.start();
      HardwareKeyboard.instance.addHandler(_handleKeyEvent);
      _isInit = true;
    }
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
          numDireita = Random().nextInt(19) + 1;
        });

        ResultadosCache.resultadosConcentrado.add({
          'tipo': 'troca',
          'tempoTroca': tempoTroca,
          'numEsquerda': numEsquerda,
          'numDireita': numDireita,
        });
      }
      if (event.logicalKey == PhysicalKeyboardKey.space) {
        final tempoReacao = _stopTroca.elapsedMilliseconds;
        ResultadosCache.resultadosConcentrado.add({
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
        appBar: AppBar(title: const Text('Teste Concentrado')),
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
