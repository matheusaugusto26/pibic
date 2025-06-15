import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AplicacaoTesteDividido extends StatefulWidget {
  const AplicacaoTesteDividido({super.key});

  @override
  AplicacaoTesteDivididoState createState() => AplicacaoTesteDivididoState();
}

class AplicacaoTesteDivididoState extends State<AplicacaoTesteDividido> {
  final FocusNode _focusNode = FocusNode();
  final Stopwatch _stopwatch = Stopwatch();
  final List<Map<String, dynamic>> resultados = [];

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _stopwatch.start();

    Future.delayed(const Duration(seconds: 240), () {
      if (mounted) {
        Navigator.pushReplacementNamed(
            context, '/finalizacaotestedividido');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Terminado!'),
        ));
      }
    });
  }

  void _onKey(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.space) {
      final int tempoReacao = _stopwatch.elapsedMilliseconds;
      setState(() {
        resultados.add({
          'tempo': tempoReacao,
          'acerto': verificarAcerto(), // implemente sua lógica aqui
        });
      });
      // Para debug:
      print(
        'Espaço pressionado → Tempo: ${tempoReacao}ms • Total de respostas: ${resultados.length}'
      );
    }
  }

  bool verificarAcerto() {
    // TODO: substituir por validação real, por exemplo:
    // compare o valor atual de num (preciso expor esse valor aqui) com o valor esperado.
    return true;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Teste de Atenção Dividida';
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _onKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(appTitle),
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
                    SizedBox(height: 20),
                    ImageSection(image: 'assets/images/square1.png'),
                    SizedBox(height: 60),
                    ImageSection(image: 'assets/images/square2.png'),
                    SizedBox(height: 60),
                    ImageSection(image: 'assets/images/square3.png'),
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
        num = Random().nextInt(19) + 1; // números de 1 a 19
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
        child: Image.asset('images/img$num.png'),
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
