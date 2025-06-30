import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aplicacao/services/resultados_cache.dart';

class AplicacaoTesteConcentrado extends StatefulWidget {
  const AplicacaoTesteConcentrado({super.key});

  @override
  State<AplicacaoTesteConcentrado> createState() =>
      _AplicacaoTesteConcentradoState();
}

class _AplicacaoTesteConcentradoState extends State<AplicacaoTesteConcentrado> {
  final FocusNode _focusNode = FocusNode();
  final Stopwatch _stopTroca = Stopwatch();
  final Stopwatch _stopTempoTotal = Stopwatch();
  Timer? _timer;

  int numEsquerda = 1;
  int numDireita = 1;
  bool _isInit = false;

  final int tempoLimiteSegundos = 120;
  final List<List<int>> _combinacoes = [];
  int _indexCombinacao = 0;
  final Random _random = Random();

  bool _respostaRegistrada = true;

  String spaceImage = 'assets/images/spacebar_normal.png';
  String arrowImage = 'assets/images/arrow_right_normal.png';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      numEsquerda = _random.nextInt(19) + 1;
      _gerarNovoBloco();

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

  void _gerarNovoBloco() {
    final bloco = <List<int>>[];
    final acertosDesejados = 5 + _random.nextInt(3);
    int acertosGerados = 0;

    for (int i = 0; i < 20; i++) {
      int direita;
      if (acertosGerados < acertosDesejados &&
          (20 - i) > (acertosDesejados - acertosGerados)) {
        direita = numEsquerda;
        acertosGerados++;
      } else {
        do {
          direita = _random.nextInt(19) + 1;
        } while (direita == numEsquerda);
      }
      bloco.add([numEsquerda, direita]);
    }

    bloco.shuffle();
    _combinacoes.addAll(bloco);
  }

  void _mudarImagemDireita() {
    final tempoTroca = _stopTroca.elapsedMilliseconds;
    _stopTroca.reset();
    _stopTroca.start();

    if (!_respostaRegistrada && numEsquerda == numDireita) {
      ResultadosCache.resultadosConcentrado.add({
        'tipo': 'reacao',
        'tipoResposta': 'omissao',
        'tempoReacao': null,
        'numEsquerda': numEsquerda,
        'numDireita': numDireita,
      });
    }

    ResultadosCache.resultadosConcentrado.add({
      'tipo': 'troca',
      'tempoTroca': tempoTroca,
    });

    if (_indexCombinacao >= _combinacoes.length) {
      _gerarNovoBloco();
    }

    final combinacao = _combinacoes[_indexCombinacao++];
    setState(() {
      numDireita = combinacao[1];
    });

    _respostaRegistrada = false;
  }

  void _registrarReacao() {
    if (_respostaRegistrada) return;

    final tempoReacao = _stopTroca.elapsedMilliseconds;
    final acerto = numEsquerda == numDireita;

    ResultadosCache.resultadosConcentrado.add({
      'tipo': 'reacao',
      'tipoResposta': acerto ? 'acerto' : 'erro',
      'tempoReacao': tempoReacao,
      'numEsquerda': numEsquerda,
      'numDireita': numDireita,
    });

    _respostaRegistrada = true;
  }

  void _finalizarTeste() {
    _timer?.cancel();
    Navigator.pushReplacementNamed(context, '/finalizacaotesteconcentrado');
  }

  void _pressionarTecla(String tecla) {
    setState(() {
      if (tecla == 'space') {
        spaceImage = 'assets/images/spacebar_pressed.png';
      } else if (tecla == 'arrow') {
        arrowImage = 'assets/images/arrow_right_pressed.png';
      }
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        if (tecla == 'space') {
          spaceImage = 'assets/images/spacebar_normal.png';
        } else if (tecla == 'arrow') {
          arrowImage = 'assets/images/arrow_right_normal.png';
        }
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _stopTroca.stop();
    _stopTempoTotal.stop();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarColor = Theme.of(context).appBarTheme.backgroundColor ??
        Theme.of(context).primaryColor;

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            _mudarImagemDireita();
            _pressionarTecla('arrow');
          } else if (event.logicalKey == LogicalKeyboardKey.space) {
            _registrarReacao();
            _pressionarTecla('space');
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
        body: Column(
          children: [
            Expanded(
              flex: 6,
              child: Row(
                children: [
                  Expanded(
                      child: Image.asset('assets/images/img$numEsquerda.png')),
                  Expanded(
                      child: Image.asset('assets/images/img$numDireita.png')),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * 0.4,
              child: Container(
                color: appBarColor,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(spaceImage, width: screenHeight * 0.3),
                      Image.asset(arrowImage, width: screenHeight * 0.3),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
