import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class AplicacaoTesteConcentrado extends StatefulWidget {
  const AplicacaoTesteConcentrado({super.key});

  @override
  AplicacaoTesteConcentradoState createState() =>
      AplicacaoTesteConcentradoState();
}

class AplicacaoTesteConcentradoState extends State<AplicacaoTesteConcentrado> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 120), () {
      // Check if the widget is still mounted before navigating
      try {
        if (mounted) {
          Navigator.pushReplacementNamed(
              context, '/finalizacaotesteconcentrado');
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
    const String appTitle = 'Teste de Atenção Concentrada';
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
