import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ModeloTesteConcentrado extends StatefulWidget {
  const ModeloTesteConcentrado({super.key});

  @override
  State<ModeloTesteConcentrado> createState() => _ModeloTesteConcentradoState();
}

class _ModeloTesteConcentradoState extends State<ModeloTesteConcentrado> {
  int numDireita = 1;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    _focusNode.dispose();
    super.dispose();
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == PhysicalKeyboardKey.arrowRight) {
      setState(() {
        numDireita = Random().nextInt(19) + 1;
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Modelo de Teste Concentrado'),
          centerTitle: true,
        ),
        body: Row(
          children: [
            Expanded(
              child: Image.asset('assets/images/square2.png'), // Imagem fixa esquerda
            ),
            Expanded(
              child: Image.asset('assets/images/img$numDireita.png'),
            ),
          ],
        ),
        floatingActionButton: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/aplicacaotesteconcentrado');
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
