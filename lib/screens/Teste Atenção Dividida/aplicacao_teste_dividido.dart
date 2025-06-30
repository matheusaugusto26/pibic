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

  final int tempoLimiteSegundos = 240;

  final List<Map<String, int>> _combinacoes = [];
  int _indiceAtual = 0;
  final Random _random = Random();

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
      int numDireita;

      if (acertosGerados < acertosDesejados && (20 - i) > (acertosDesejados - acertosGerados)) {
        numDireita = numerosEsquerda[_random.nextInt(3)];
        acertosGerados++;
      } else {
        do {
          numDireita = _random.nextInt(19) + 1;
        } while (numerosEsquerda.contains(numDireita));
      }

      bloco.add({'numDireita': numDireita});
    }

    bloco.shuffle();
    _combinacoes.addAll(bloco);
    _indiceAtual = 0;
  }

  void _mudarImagemDireita() {
    final tempoTroca = _stopTroca.elapsedMilliseconds;
    _stopTroca.reset();
    _stopTroca.start();

    if (_indiceAtual >= _combinacoes.length) {
      _gerarNovoBloco();
    }

    setState(() {
      numeroDireita = _combinacoes[_indiceAtual]['numDireita']!;
      _indiceAtual++;
    });

    ResultadosCache.resultadosDividido.add({
      'tipo': 'troca',
      'tempoTroca': tempoTroca,
      'numEsquerda': List.from(numerosEsquerda),
      'numDireita': numeroDireita,
    });
  }

  void _registrarReacao() {
    final tempoReacao = _stopTroca.elapsedMilliseconds;

    ResultadosCache.resultadosDividido.add({
      'tipo': 'reacao',
      'tempoReacao': tempoReacao,
      'acerto': numerosEsquerda.contains(numeroDireita),
      'numEsquerda': List.from(numerosEsquerda),
      'numDireita': numeroDireita,
    });
  }

  void _finalizarTeste() {
    _timer?.cancel();
    Navigator.pushReplacementNamed(context, '/finalizacaotestedividido');
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            _mudarImagemDireita();
          } else if (event.logicalKey == LogicalKeyboardKey.space) {
            _registrarReacao();
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
    _stopTroca.stop();
    _stopTempoTotal.stop();
    _timer?.cancel();
    super.dispose();
  }
}