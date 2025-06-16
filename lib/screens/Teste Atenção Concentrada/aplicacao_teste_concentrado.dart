import 'dart:async';
import 'dart:math';
import 'package:aplicacao/services/resultados_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AplicacaoTesteConcentrado extends StatefulWidget {
  const AplicacaoTesteConcentrado({super.key});

  @override
  _AplicacaoTesteConcentradoState createState() => _AplicacaoTesteConcentradoState();
}

class _AplicacaoTesteConcentradoState extends State<AplicacaoTesteConcentrado> {
  final FocusNode _focusNode = FocusNode();
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  late int numEsquerda; // Número fixo da esquerda
  int numDireita = 1; // Número da direita (muda)
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      numEsquerda = Random().nextInt(19) + 1;

      _focusNode.requestFocus();
      _stopwatch.start();

      // Timer para mudar a imagem da direita
      _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
        setState(() {
          numDireita = Random().nextInt(19) + 1;
        });
      });

      // Finalizar após 120 segundos
      Future.delayed(const Duration(seconds: 120), () {
        _timer?.cancel();
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/finalizacaotesteconcentrado');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Terminado!')),
          );
        }
      });

      _isInit = true;
    }
  }

  void _onSpacePressed() {
    final tempoReacao = _stopwatch.elapsedMilliseconds;
    ResultadosCache.resultadosConcentrado.add({
      'tempo': tempoReacao,
      'acerto': verificarAcerto(),
      'numEsquerda': numEsquerda,
      'numDireita': numDireita,
    });
  }

  bool verificarAcerto() {
    return numEsquerda == numDireita;
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
          title: const Text('Aplicação do Teste Concentrado'),
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
                    const SizedBox(height: 200),
                    Image.asset('assets/images/img$numEsquerda.png'), // Esquerda fixa
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: RightBox(numero: numDireita), // Direita mudando
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
    return Center(
      child: Image.asset('assets/images/img$numero.png'),
    );
  }
}

class ImageSection extends StatelessWidget {
  final String image;

  const ImageSection({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
