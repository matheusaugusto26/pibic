import 'dart:async';
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
  final Stopwatch _stopTempoTotal = Stopwatch();
  Timer? _timer;

  late int numEsquerda;
  int numDireita = 1;
  bool _isInit = false;

  final int tempoLimiteSegundos = 120;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      numEsquerda = Random().nextInt(19) + 1;
      _focusNode.requestFocus();
      _stopTroca.start();
      _stopTempoTotal.start();

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_stopTempoTotal.elapsed.inSeconds >= tempoLimiteSegundos) {
          _finalizarTeste();
        }
      });

      _isInit = true;
    }
  }

  void _mudarImagemDireita() {
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

  void _registrarReacao() {
    final tempoReacao = _stopTroca.elapsedMilliseconds;

    ResultadosCache.resultadosConcentrado.add({
      'tipo': 'reacao',
      'tempoReacao': tempoReacao,
      'acerto': numEsquerda == numDireita,
      'numEsquerda': numEsquerda,
      'numDireita': numDireita,
    });
  }

  void _finalizarTeste() {
    _timer?.cancel();
    Navigator.pushReplacementNamed(context, '/finalizacaotesteconcentrado');
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
          title: const Text('Aplicação do Teste Concentrado'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Row(
          children: [
            Expanded(
              child: Image.asset('assets/images/img$numEsquerda.png'),
            ),
            Expanded(
              child: Image.asset('assets/images/img$numDireita.png'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _stopTroca.stop();
    _stopTempoTotal.stop();
    _timer?.cancel();
    super.dispose();
  }
}
