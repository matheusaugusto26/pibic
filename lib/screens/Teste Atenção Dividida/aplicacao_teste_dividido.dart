import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AplicacaoTesteDividido extends StatefulWidget {
  const AplicacaoTesteDividido({super.key});

  @override
  State<AplicacaoTesteDividido> createState() =>
      _AplicacaoTesteDivididoState();
}

class _AplicacaoTesteDivididoState extends State<AplicacaoTesteDividido> {
  final FocusNode _focusNode = FocusNode();
  final Stopwatch _stopwatch = Stopwatch();

  bool _isInit = false;
  late Map<String, dynamic> _dadosAlternado;
  late Map<String, dynamic> _dadosConcentrado;
  final List<Map<String, dynamic>> _resultadosDividido = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      // 1) Recebe o Map com 'alternado' e 'concentrado' vindos da rota
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ??
              {};

      _dadosAlternado = args['alternado'] as Map<String, dynamic>? ?? {};
      _dadosConcentrado = args['concentrado'] as Map<String, dynamic>? ?? {};

      // 2) Prepara foco e cronômetro
      _focusNode.requestFocus();
      _stopwatch.start();

      // 3) Agenda o término do teste (240s) e navega para Finalização
      Timer(const Duration(seconds: 240), () {
        if (!mounted) return;
        Navigator.pushReplacementNamed(
          context,
          '/finalizacaotestedividido',
          arguments: {
            'alternado': _dadosAlternado,
            'concentrado': _dadosConcentrado,
            'dividido': {
              'resultados': _resultadosDividido,
            },
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terminado!')),
        );
      });

      _isInit = true;
    }
  }

  void _onSpacePressed() {
    final int tempoReacao = _stopwatch.elapsedMilliseconds;
    setState(() {
      _resultadosDividido.add({
        'tempo': tempoReacao,
        'acerto': _verificarAcerto(),
      });
    });
  }

  bool _verificarAcerto() {
    // TODO: implemente aqui a lógica real de validação do teste dividido
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
  int _num = 1;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {
        _num = Random().nextInt(19) + 1;
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
        child: Image.asset('assets/images/img$_num.png'),
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
