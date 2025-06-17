import 'package:flutter/material.dart';

class TermosECondicoes extends StatelessWidget {
  const TermosECondicoes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Termos e Condições'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Estes são os termos e condições para continuar a Aplicação do Teste.\n'
                'Leia-os atentamente e prossiga com cautela.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 20),
            const ScrollableTextBox(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/cadastrosessaoteste');
              },
              child: const Text('Aceitar e Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}

class ScrollableTextBox extends StatelessWidget {
  const ScrollableTextBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 800,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
              'Cras commodo condimentum turpis, at feugiat ipsum tempus eget. '
              'Sed ac enim vitae eros venenatis lacinia quis ut risus. '
              'Nunc at viverra eros, at commodo justo. Nunc at rhoncus lectus. '
              'Nullam interdum sagittis orci, nec commodo metus bibendum non. '
              'Sed non pulvinar augue, a placerat odio. Aliquam cursus enim a '
              'tristique ullamcorper. Vestibulum vestibulum tellus at tempor '
              'consectetur. Nullam tempor dui eget risus euismod aliquam et '
              'eget erat.\n\n(…continua conforme necessário…)',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
