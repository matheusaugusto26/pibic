import 'dart:async';
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
  final Stopwatch _stopTempoTotal = Stopwatch();
  Timer? _timer;

  List<int> numerosEsquerda = [];
  int numeroDireita = 1;
  bool _isInit = false;

  final int tempoLimiteSegundos = 10; //240 BEFORE

  final List<Map<String, int>> _combinacoes = [];
  int _indiceAtual = 0;
  final Random _random = Random();

  bool _respostaRegistrada = true;

  String spaceImage = 'assets/images/spacebar_normal.png';
  String arrowImage = 'assets/images/arrow_right_normal.png';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      numerosEsquerda = _sortearTresNumerosDistintos();
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

  List<int> _sortearTresNumerosDistintos() {
    List<int> todos = List.generate(19, (index) => index + 1);
    todos.shuffle();
    return todos.take(3).toList();
  }

  void _gerarNovoBloco() {
    _combinacoes.clear();
    final bloco = <Map<String, int>>[];
    final acertosDesejados = 5 + _random.nextInt(3);
    int acertosGerados = 0;

    for (int i = 0; i < 20; i++) {
      int numDir;

      if (acertosGerados < acertosDesejados &&
          (20 - i) > (acertosDesejados - acertosGerados)) {
        numDir = numerosEsquerda[_random.nextInt(3)];
        acertosGerados++;
      } else {
        do {
          numDir = _random.nextInt(19) + 1;
        } while (numerosEsquerda.contains(numDir));
      }

      bloco.add({'numDireita': numDir});
    }

    bloco.shuffle();
    _combinacoes.addAll(bloco);
    _indiceAtual = 0;
  }

  void _mudarImagemDireita() {
    final tempoTroca = _stopTroca.elapsedMilliseconds;
    _stopTroca.reset();
    _stopTroca.start();

    if (!_respostaRegistrada) {
      ResultadosCache.resultadosDividido.add({
        'tipo': 'reacao',
        'tipoResposta': 'omissao',
        'tempoReacao': null,
        'numEsquerda': List.from(numerosEsquerda),
        'numDireita': numeroDireita,
      });
    }

    ResultadosCache.resultadosDividido.add({
      'tipo': 'troca',
      'tempoTroca': tempoTroca,
    });

    if (_indiceAtual >= _combinacoes.length) {
      _gerarNovoBloco();
    }

    setState(() {
      numeroDireita = _combinacoes[_indiceAtual]['numDireita']!;
      _indiceAtual++;
    });

    _respostaRegistrada = false;
  }

  void _registrarReacao() {
    if (_respostaRegistrada) return;

    final tempoReacao = _stopTroca.elapsedMilliseconds;
    final acerto = numerosEsquerda.contains(numeroDireita);

    ResultadosCache.resultadosDividido.add({
      'tipo': 'reacao',
      'tipoResposta': acerto ? 'acerto' : 'erro',
      'tempoReacao': tempoReacao,
      'numEsquerda': List.from(numerosEsquerda),
      'numDireita': numeroDireita,
    });

    _respostaRegistrada = true;
  }

  void _finalizarTeste() {
    _timer?.cancel();
    Navigator.pushReplacementNamed(context, '/finalizacaotestedividido');
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
          automaticallyImplyLeading: false,
          title: const Text('Aplicação do Teste Dividido'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              flex: 6,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: numerosEsquerda
                            .map((n) => Image.asset(
                                  'assets/images/img$n.png',
                                  width: 80,
                                  height: 80,
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset('assets/images/img$numeroDireita.png'),
                    ),
                  ),
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
