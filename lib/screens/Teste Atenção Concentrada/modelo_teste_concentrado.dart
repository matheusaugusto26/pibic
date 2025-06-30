import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ModeloTesteConcentrado extends StatefulWidget {
  const ModeloTesteConcentrado({super.key});

  @override
  State<ModeloTesteConcentrado> createState() => _ModeloTesteConcentradoState();
}

class _ModeloTesteConcentradoState extends State<ModeloTesteConcentrado> {
  final FocusNode _focusNode = FocusNode();
  final Stopwatch _stopTroca = Stopwatch();
  final Random _random = Random();

  int numEsquerda = 1;
  int numDireita = 1;
  final List<List<int>> _combinacoes = [];
  int _indexCombinacao = 0;
  bool _respostaRegistrada = true;

  String spaceImage = 'assets/images/spacebar_normal.png';
  String arrowImage = 'assets/images/arrow_right_normal.png';

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _stopTroca.start();
    numEsquerda = _random.nextInt(19) + 1;
    _gerarNovoBloco();
    _mostrarProximaCombinacao();
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

  void _mostrarProximaCombinacao() {
    if (!_respostaRegistrada) {
      // omissão ignorada
    }

    if (_indexCombinacao >= _combinacoes.length) {
      _gerarNovoBloco();
    }

    final combinacao = _combinacoes[_indexCombinacao++];
    setState(() {
      numDireita = combinacao[1];
      _respostaRegistrada = false;
    });

    _stopTroca.reset();
    _stopTroca.start();
  }

  void _registrarReacao() {
    if (_respostaRegistrada) return;

    // acerto ou erro ignorado internamente
    _respostaRegistrada = true;
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

  void _handleKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _mostrarProximaCombinacao();
        _pressionarTecla('arrow');
      } else if (event.logicalKey == LogicalKeyboardKey.space) {
        _registrarReacao();
        _pressionarTecla('space');
      }
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _stopTroca.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarColor = Theme.of(context).appBarTheme.backgroundColor ??
        Theme.of(context).primaryColor;

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKey,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Modelo de Teste Concentrado'),
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
        floatingActionButton: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(
                context, '/aplicacaotesteconcentrado');
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Colors.white,
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text('Vamos para o Teste!'),
          ),
        ),
      ),
    );
  }
}
