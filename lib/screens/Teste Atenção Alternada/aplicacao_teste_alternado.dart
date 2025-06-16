import 'dart:async';
import 'dart:math';
import 'package:aplicacao/services/resultados_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AplicacaoTesteAlternado extends StatefulWidget {
  const AplicacaoTesteAlternado({super.key});

  @override
  AplicacaoTesteAlternadoState createState() => AplicacaoTesteAlternadoState();
}

class AplicacaoTesteAlternadoState extends State<AplicacaoTesteAlternado> {
  final FocusNode _focusNode = FocusNode();
  final Stopwatch _stopwatch = Stopwatch();

  int numEsquerda = 1;
  int numDireita = 1;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _stopwatch.start();

    // Timer para atualizar as imagens a cada 500ms
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {
        numEsquerda = Random().nextInt(19) + 1;
        numDireita = Random().nextInt(19) + 1;
      });
    });

    Future.delayed(const Duration(seconds: 150), () {
      _timer?.cancel();
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/finalizacaotestealternado',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terminado!')),
        );
      }
    });
  }

  void _onSpacePressed() {
    final tempoReacao = _stopwatch.elapsedMilliseconds;
    ResultadosCache.resultadosAlternado.add({
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
        if (event.logicalKey == LogicalKeyboardKey.space &&
            event is KeyDownEvent) {
          _onSpacePressed();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Aplicação do Teste Alternado'),
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
                    Image.asset('assets/images/img$numEsquerda.png'), // Imagem da esquerda
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: RightBox(numero: numDireita), // Imagem da direita
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
