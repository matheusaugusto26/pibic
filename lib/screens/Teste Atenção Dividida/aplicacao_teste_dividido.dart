import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class AplicacaoTesteDividido extends StatefulWidget {
  const AplicacaoTesteDividido({super.key});

  @override
  AplicacaoTesteDivididoState createState() => AplicacaoTesteDivididoState();
}

class AplicacaoTesteDivididoState extends State<AplicacaoTesteDividido> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 240), () {
      // Check if the widget is still mounted before navigating
      try {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/finalizacaotestedividido');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Terminado!'),
          ));
        }
      } catch (e) {
        print('Error: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Teste de Atenção Dividida';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(appTitle),
          centerTitle: true,
          backgroundColor: Colors.blue.shade100,
        ),
        body: const Center(
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align content at the start
            children: <Widget>[
              Expanded(
                flex: 1, // Image column will take up 1/3 of the available space
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
                flex: 1, // Box will take up 2/3 of the available space
                child: RightBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget for the right box
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
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        num = Random().nextInt(19) + 1; // Generates numbers from 1 to 19
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
