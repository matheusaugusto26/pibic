import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ModeloTesteDividido extends StatefulWidget {
  const ModeloTesteDividido({super.key});

  @override
  State<ModeloTesteDividido> createState() => _ModeloTesteDivididoState();
}

class _ModeloTesteDivididoState extends State<ModeloTesteDividido> {
  List<int> numerosEsquerda = [];
  int numDireita = 1;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _sortearNumerosEsquerda();
    _focusNode.requestFocus();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  void _sortearNumerosEsquerda() {
    List<int> todos = List.generate(19, (index) => index + 1);
    todos.shuffle();
    setState(() {
      numerosEsquerda = todos.take(3).toList();
    });
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    _focusNode.dispose();
    super.dispose();
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == PhysicalKeyboardKey.arrowRight) {
        setState(() {
          numDireita = Random().nextInt(19) + 1;
        });
      }
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
          title: const Text('Modelo de Teste Dividido'),
          centerTitle: true,
        ),
        body: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: numerosEsquerda
                    .map((n) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Image.asset('assets/images/img$n.png'),
                        ))
                    .toList(),
              ),
            ),
            Expanded(
              child: Image.asset('assets/images/img$numDireita.png'),
            ),
          ],
        ),
        floatingActionButton: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/aplicacaotestedividido');
          },
          child: const Text('Vamos para o Teste!'),
        ),
      ),
    );
  }
}
