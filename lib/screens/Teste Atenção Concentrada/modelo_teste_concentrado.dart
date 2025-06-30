import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ModeloTesteConcentrado extends StatefulWidget {
  const ModeloTesteConcentrado({super.key});

  @override
  State<ModeloTesteConcentrado> createState() => _ModeloTesteConcentradoState();
}

class _ModeloTesteConcentradoState extends State<ModeloTesteConcentrado> {
  int numEsquerda = 1; // Será sorteado uma vez só
  int numDireita = 1;  // Muda a cada tecla →
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();

    // Sorteia uma imagem fixa para o lado esquerdo
    numEsquerda = Random().nextInt(19) + 1;
  }

  void _handleKey(KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.arrowRight) {
      setState(() {
        numDireita = Random().nextInt(19) + 1;
      });
    }
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
      onKeyEvent: _handleKey,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Modelo de Teste Concentrado'),
          centerTitle: true,
        ),
        body: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset('assets/images/img$numEsquerda.png'),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset('assets/images/img$numDireita.png'),
              ),
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