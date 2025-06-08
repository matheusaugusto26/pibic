import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class ModeloTesteAlternado extends StatefulWidget {
  const ModeloTesteAlternado({super.key});

  @override
  State<ModeloTesteAlternado> createState() => _ModeloTesteAlternadoState();
}

class _ModeloTesteAlternadoState extends State<ModeloTesteAlternado> {
  int num = 1;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    super.dispose();
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (HardwareKeyboard.instance.physicalKeysPressed
          .contains(PhysicalKeyboardKey.arrowRight)) {
        setState(() {
          num = Random().nextInt(20) + 1;
        });
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Modelo de Teste Alternado'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade100,
        actions: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, '/aplicacaotestealternado');
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Prepare-se para a Aplicação do Teste!'),
                ));
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.white,
              ),
              child: const Text('Vamos para o Teste!'),
            ),
          ),
        ],
      ),
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 175),
                  Image.asset('images/img$num.png'),
                ],
              ),
            ),
            const Expanded(
              flex: 1,
              child: RightBox(),
            ),
          ],
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

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    super.dispose();
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (HardwareKeyboard.instance.physicalKeysPressed
          .contains(PhysicalKeyboardKey.arrowRight)) {
        setState(() {
          num = Random().nextInt(20) + 1;
        });
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[200],
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 175),
              Image.asset('images/img$num.png'),
            ],
          ),
        ));
  }
}
