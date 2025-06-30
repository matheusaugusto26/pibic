import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ModeloTesteAlternado extends StatefulWidget {
  const ModeloTesteAlternado({super.key});

  @override
  State<ModeloTesteAlternado> createState() => _ModeloTesteAlternadoState();
}

class _ModeloTesteAlternadoState extends State<ModeloTesteAlternado> {
  final FocusNode _focusNode = FocusNode();
  final Stopwatch _stopTroca = Stopwatch();
  int combinacaoIndex = 0;
  List<Map<String, int>> combinacoes = [];
  bool _respostaRegistrada = true;

  int numEsquerda = 1;
  int numDireita = 1;

  String spaceImage = 'assets/images/spacebar_normal.png';
  String arrowImage = 'assets/images/arrow_right_normal.png';

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _stopTroca.start();
    _gerarNovoBloco();
    _mostrarProximaCombinacao();
  }

  void _gerarNovoBloco() {
    final random = Random();
    final bloco = <Map<String, int>>[];

    final acertosDesejados = 5 + random.nextInt(3);
    int acertosGerados = 0;

    for (int i = 0; i < 20; i++) {
      int esquerda = random.nextInt(19) + 1;
      int direita;

      if (acertosGerados < acertosDesejados &&
          (20 - i) > (acertosDesejados - acertosGerados)) {
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

  void _mostrarProximaCombinacao() {
    if (!_respostaRegistrada) {
      // Apenas modelo de teste - omissão não registrada
    }

    if (combinacaoIndex >= combinacoes.length) {
      _gerarNovoBloco();
    }

    final combinacao = combinacoes[combinacaoIndex++];
    setState(() {
      numEsquerda = combinacao['esquerda']!;
      numDireita = combinacao['direita']!;
      _respostaRegistrada = false;
    });

    _stopTroca.reset();
    _stopTroca.start();
  }

  void _registrarReacao() {
    if (_respostaRegistrada) return;
    // Apenas modelo de teste - reação não registrada
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
          automaticallyImplyLeading: false,
          title: const Text('Modelo de Teste Alternado'),
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
                context, '/aplicacaotestealternado');
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
