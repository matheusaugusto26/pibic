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
      _isInit = true;
    }
  }

  List<int> _sortearTresNumerosDistintos() {
    List<int> todos = List.generate(19, (index) => index + 1);
    todos.shuffle();
    return todos.take(3).toList();
  }

  void _mudarImagemDireita() {
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

  void _registrarReacao() {
    final tempoReacao = _stopTroca.elapsedMilliseconds;

    ResultadosCache.resultadosDividido.add({
      'tipo': 'reacao',
      'tempoReacao': tempoReacao,
      'acerto': numerosEsquerda.contains(numeroDireita),
      'numEsquerda': numerosEsquerda,
      'numDireita': numeroDireita,
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            _mudarImagemDireita();
          }
          if (event.logicalKey == LogicalKeyboardKey.space) {
            _registrarReacao();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Teste Dividido'),
          centerTitle: true,
        ),
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
            Expanded(
              child: Image.asset('assets/images/img$numeroDireita.png'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
