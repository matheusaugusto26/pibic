import 'dart:async';
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
  final Stopwatch _stopTempoTotal = Stopwatch();
  Timer? _timer;

  int numEsquerda = 1;
  int numDireita = 1;
  int combinacaoIndex = 0;
  final int tempoLimiteSegundos = 10;

  List<Map<String, int>> combinacoes = [];
  bool _respostaRegistrada = true;

  String spaceImage = 'assets/images/spacebar_normal.png';
  String arrowImage = 'assets/images/arrow_right_normal.png';

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _stopTroca.start();
    _stopTempoTotal.start();
    _gerarNovoBloco();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_stopTempoTotal.elapsed.inSeconds >= tempoLimiteSegundos) {
        _finalizarTeste();
      }
    });
  }

  void _gerarNovoBloco() {
    final random = Random();
    final bloco = <Map<String, int>>[];

    final acertosDesejados = 5 + random.nextInt(3);
    int acertosGerados = 0;

    for (int i = 0; i < 20; i++) {
      int esquerda = random.nextInt(19) + 1;
      int direita;

      if (acertosGerados < acertosDesejados && (20 - i) > (acertosDesejados - acertosGerados)) {
        direita = esquerda;
        acertosGerados++;
      } else {
        do {
          direita = random.nextInt(19) + 1;
        } while (direita == esquerda);
      }

      bloco.add({'esquerda': esquerda, 'direita': direita});
    }

    bloco.shuffle();
    combinacoes.addAll(bloco);
  }

  void _mudarImagens() {
    final tempoTroca = _stopTroca.elapsedMilliseconds;
    _stopTroca.reset();
    _stopTroca.start();

    if (!_respostaRegistrada) {
      ResultadosCache.resultadosAlternado.add({
        'tipo': 'reacao',
        'tipoResposta': 'omissao',
        'tempoReacao': null,
        'numEsquerda': numEsquerda,
        'numDireita': numDireita,
      });
    }

    ResultadosCache.resultadosAlternado.add({
      'tipo': 'troca',
      'tempoTroca': tempoTroca,
    });

    if (combinacaoIndex >= combinacoes.length) {
      _gerarNovoBloco();
    }

    final combinacao = combinacoes[combinacaoIndex++];

    setState(() {
      numEsquerda = combinacao['esquerda']!;
      numDireita = combinacao['direita']!;
    });

    _respostaRegistrada = false;
  }

  void _registrarReacao() {
    if (_respostaRegistrada) return;

    final tempoReacao = _stopTroca.elapsedMilliseconds;
    final acerto = numEsquerda == numDireita;

    ResultadosCache.resultadosAlternado.add({
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
    Navigator.pushReplacementNamed(context, '/finalizacaotestealternado');
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _stopTroca.stop();
    _stopTempoTotal.stop();
    _timer?.cancel();
    super.dispose();
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
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarColor = Theme.of(context).appBarTheme.backgroundColor ??
        Theme.of(context).primaryColor;

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            _mudarImagens();
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
          automaticallyImplyLeading: false,
          title: const Text('Aplicação do Teste Alternado'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              flex: 6,
              child: Row(
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
            SizedBox(
              height: screenHeight * 0.4, // ocupa 40% da tela
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
