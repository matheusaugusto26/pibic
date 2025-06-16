import 'dart:async';
import 'dart:math';
import 'package:aplicacao/services/resultados_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AplicacaoTesteDividido extends StatefulWidget {
  const AplicacaoTesteDividido({super.key});

  @override
  State<AplicacaoTesteDividido> createState() => _AplicacaoTesteDivididoState();
}

class _AplicacaoTesteDivididoState extends State<AplicacaoTesteDividido> {
  final FocusNode _focusNode = FocusNode();
  final Stopwatch _stopwatch = Stopwatch();

  late List<int> numerosEsquerda;  // 3 imagens fixas da esquerda
  int numeroDireita = 1;           // Imagem da direita que vai mudando
  Timer? _timer;

  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      // Sorteia 3 imagens únicas para a esquerda
      numerosEsquerda = _sortearTresNumerosDistintos();

      _focusNode.requestFocus();
      _stopwatch.start();

      // Timer para alterar a imagem da direita a cada 500ms
      _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
        setState(() {
          numeroDireita = Random().nextInt(19) + 1;
        });
      });

      // Termina o teste após 240s
      Timer(const Duration(seconds: 240), () {
        _timer?.cancel();
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/finalizacaotestedividido');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terminado!')),
        );
      });

      _isInit = true;
    }
  }

  List<int> _sortearTresNumerosDistintos() {
    List<int> todos = List.generate(19, (index) => index + 1);
    todos.shuffle();
    return todos.take(3).toList();
  }

  void _onSpacePressed() {
    final tempoReacao = _stopwatch.elapsedMilliseconds;
    ResultadosCache.resultadosDividido.add({
      'tempo': tempoReacao,
      'acerto': verificarAcerto(),
      'numEsquerda': numerosEsquerda,
      'numDireita': numeroDireita,
    });
  }

  bool verificarAcerto() {
    return numerosEsquerda.contains(numeroDireita);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (KeyEvent event) {
        if (event.logicalKey == LogicalKeyboardKey.space && event is KeyDownEvent) {
          _onSpacePressed();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Aplicação do Teste Dividido'),
          centerTitle: true,
          backgroundColor: Colors.blue.shade100,
        ),
        body: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Image.asset('assets/images/img${numerosEsquerda[0]}.png'),
                    const SizedBox(height: 60),
                    Image.asset('assets/images/img${numerosEsquerda[1]}.png'),
                    const SizedBox(height: 60),
                    Image.asset('assets/images/img${numerosEsquerda[2]}.png'),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: RightBox(numero: numeroDireita),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RightBox extends StatelessWidget {
  final int numero;

  const RightBox({super.key, required this.numero});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: Image.asset('assets/images/img$numero.png'),
      ),
    );
  }
}
