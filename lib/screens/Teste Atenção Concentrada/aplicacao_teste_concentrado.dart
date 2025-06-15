import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AplicacaoTesteConcentrado extends StatefulWidget {
  const AplicacaoTesteConcentrado({super.key});

  @override
  State<AplicacaoTesteConcentrado> createState() =>
      _AplicacaoTesteConcentradoState();
}

class _AplicacaoTesteConcentradoState
    extends State<AplicacaoTesteConcentrado> {
  final FocusNode _focusNode = FocusNode();
  final Stopwatch _stopwatch = Stopwatch();

  bool _isInit = false;
  late List<Map<String, dynamic>> _resultadosAlternado;
  final List<Map<String, dynamic>> _resultadosConcentrado = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      // 1) Recebe o Map que veio de FinalizacaoTesteAlternado
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ??
              {};

      // 2) Extrai a lista bruta de resultados do alternado
      final alternadoMap = args['alternado'] as Map<String, dynamic>? ?? {};
      _resultadosAlternado = (alternadoMap['resultados'] as List)
          .cast<Map<String, dynamic>>();

      // 3) Prepara o listener de teclado e o cronômetro
      _focusNode.requestFocus();
      _stopwatch.start();

      // 4) Dispara o timer para terminar o teste
      Timer(const Duration(seconds: 120), () {
        if (!mounted) return;
        Navigator.pushReplacementNamed(
          context,
          '/finalizacaotesteconcentrado',
          arguments: {
            'alternado': _resultadosAlternado,
            'concentrado': _resultadosConcentrado,
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
      _resultadosConcentrado.add({
        'tempo': tempoReacao,
        'acerto': verificarAcerto(),
      });
    });
  }

  bool verificarAcerto() {
    // TODO: implementar a lógica real de acerto aqui
    return true;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Teste de Atenção Concentrada';

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
        child: Image.asset('assets/images/img$num.png'),
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
