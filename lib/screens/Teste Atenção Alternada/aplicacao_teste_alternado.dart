import 'dart:async';
import 'dart:math';
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
  final List<Map<String, dynamic>> resultados = [];

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _stopwatch.start();

    Future.delayed(const Duration(seconds: 150), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/finalizacaotestealternado',
            arguments: resultados);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terminado!')),
        );
      }
    });
  }

  void _onSpacePressed() {
    final int tempoReacao = _stopwatch.elapsedMilliseconds;
    setState(() {
      resultados.add({
        'tempo': tempoReacao,
        'acerto': verificarAcerto(),
      });
    });
  }

  bool verificarAcerto() {
    // TODO: adaptar lógica de acerto
    return true;
  }

  @override
  void dispose() {
    _focusNode.dispose();
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
        body: const Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 200),
                    ImageSection(image: 'assets/images/square2.png'),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: RightBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RightBox extends StatefulWidget {
  const RightBox({super.key});
  @override
  State<RightBox> createState() => _RightBoxState();
}

class _RightBoxState extends State<RightBox> {
  int num = 1;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        num = Random().nextInt(19) + 1;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: InkWell(
          child: Image.asset('images/img$num.png'),
        ),
      ),
    );
  }
}

class ImageSection extends StatelessWidget {
  const ImageSection({super.key, required this.image});

  final String image;

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
