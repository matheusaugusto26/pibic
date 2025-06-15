import 'package:flutter/material.dart';

class TermosECondicoes extends StatelessWidget {
  const TermosECondicoes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Termos e Condições'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade100,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Estes são os termos e condições para continuar a Aplicação do Teste.\n'
              'Leia-os atentamente, e prossiga com cautela.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const ScrollableTextBox(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/cadastrosessaoteste');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.white,
              ),
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
      height: 300, // Altura da caixa
      width: 800, // Largura ajustável
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              // Insira aqui o texto dos termos e condições
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
              'Cras commodo condimentum turpis, at feugiat ipsum tempus eget. '
              'Sed ac enim vitae eros venenatis lacinia quis ut risus. '
              'Nunc at viverra eros, at commodo justo. Nunc at rhoncus lectus. '
              'Nullam interdum sagittis orci, nec commodo metus bibendum non. '
              'Sed non pulvinar augue, a placerat odio. Aliquam cursus enim a '
              'tristique ullamcorper. Vestibulum vestibulum tellus at tempor '
              'consectetur. Nullam tempor dui eget risus euismod aliquam et '
              'eget erat.'
              '\n\nSuspendisse iaculis eu lorem convallis iaculis. '
              'In porttitor porttitor mi eu condimentum. Praesent ac varius leo. '
              'Morbi feugiat dui eget diam elementum viverra. Nunc in sodales '
              'neque, et semper mi. Sed ut tristique dolor. Vestibulum at '
              'tortor non odio ullamcorper pharetra non vel erat. Donec molestie '
              'massa ut lobortis dictum. Nam ac urna vitae nisi hendrerit '
              'facilisis. Fusce feugiat est sed venenatis viverra. Duis iaculis '
              'nibh elementum blandit condimentum.'
              '\n\n(…continua conforme necessário…)',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
