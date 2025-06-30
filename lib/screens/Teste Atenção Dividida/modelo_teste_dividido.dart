import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ModeloTesteDividido extends StatefulWidget {
  const ModeloTesteDividido({super.key});

  @override
  State<ModeloTesteDividido> createState() => _ModeloTesteDivididoState();
}

class _ModeloTesteDivididoState extends State<ModeloTesteDividido> {
  final FocusNode _focusNode = FocusNode();
  final Stopwatch _stopTroca = Stopwatch();
  final Random _random = Random();

  List<int> numerosEsquerda = [];
  int numeroDireita = 1;
  List<Map<String, int>> _combinacoes = [];
  int _indiceAtual = 0;
  bool _respostaRegistrada = true;

  String spaceImage = 'assets/images/spacebar_normal.png';
  String arrowImage = 'assets/images/arrow_right_normal.png';

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _stopTroca.start();
    _sortearNumerosEsquerda();
    _gerarNovoBloco();
    _mostrarProximaCombinacao();
  }

  void _sortearNumerosEsquerda() {
    final todos = List.generate(19, (index) => index + 1)..shuffle();
    numerosEsquerda = todos.take(3).toList();
  }

  void _gerarNovoBloco() {
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
    _combinacoes = bloco;
    _indiceAtual = 0;
  }

  void _mostrarProximaCombinacao() {
    if (!_respostaRegistrada) {
      // Apenas modelo de teste - omissão não registrada
    }

    if (_indiceAtual >= _combinacoes.length) {
      _gerarNovoBloco();
    }

    setState(() {
      numeroDireita = _combinacoes[_indiceAtual]['numDireita']!;
      _indiceAtual++;
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
          title: const Text('Modelo de Teste Dividido'),
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
                    flex: 2,
                    child: Row(
                      children: numerosEsquerda
                          .map((n) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset('assets/images/img$n.png'),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
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
        floatingActionButton: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(
                context, '/aplicacaotestedividido');
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
