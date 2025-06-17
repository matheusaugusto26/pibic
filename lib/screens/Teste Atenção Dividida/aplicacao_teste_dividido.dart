import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aplicacao/services/resultados_cache.dart';

class AplicacaoTesteDividido extends StatefulWidget {
  const AplicacaoTesteDividido({super.key});

  @override
  State<AplicacaoTesteDividido> createState() => _AplicacaoTesteDivididoState();
}

class _AplicacaoTesteDivididoState extends State<AplicacaoTesteDividido> {
  final FocusNode _focusNode = FocusNode();
  final Stopwatch _stopTroca = Stopwatch();

  late List<int> numerosEsquerda;
  int numeroDireita = 1;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      numerosEsquerda = _sortearTresNumerosDistintos();
      _focusNode.requestFocus();
      _stopTroca.start();
      HardwareKeyboard.instance.addHandler(_handleKeyEvent);
      _isInit = true;
    }
  }

  List<int> _sortearTresNumerosDistintos() {
    List<int> todos = List.generate(19, (index) => index + 1);
    todos.shuffle();
    return todos.take(3).toList();
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
          numeroDireita = Random().nextInt(19) + 1;
        });

        ResultadosCache.resultadosDividido.add({
          'tipo': 'troca',
          'tempoTroca': tempoTroca,
          'numEsquerda': numerosEsquerda,
          'numDireita': numeroDireita,
        });
      }
      if (event.logicalKey == PhysicalKeyboardKey.space) {
        final tempoReacao = _stopTroca.elapsedMilliseconds;
        ResultadosCache.resultadosDividido.add({
          'tipo': 'reacao',
          'tempoReacao': tempoReacao,
          'acerto': numerosEsquerda.contains(numeroDireita),
          'numEsquerda': numerosEsquerda,
          'numDireita': numeroDireita,
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
        appBar: AppBar(title: const Text('Teste Dividido')),
        body: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: numerosEsquerda
                    .map((n) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Image.asset('assets/images/img$n.png'),
                        ))
                    .toList(),
              ),
            ),
            Expanded(child: Image.asset('assets/images/img$numeroDireita.png')),
          ],
        ),
      ),
    );
  }
}
