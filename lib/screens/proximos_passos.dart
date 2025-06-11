// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';

class ProximosPassos extends StatelessWidget {
  const ProximosPassos({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Próximos Passos'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade100,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                'Estes são os Próximos Passos para continuar a sua Avaliação Neuropsicológica.\nApós a leitura minuciosa e qualquer questão sanada com seu neuropsicólogo, você pode fechar esta janela.',
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
            const ScrollableTextBox(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue, backgroundColor: Colors.white),
              child: const Text('Começar Nova Sessão de Teste'),
            )
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
      height: 300, // Set the height of the text box
      width: 800, // You can adjust the width as needed
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras commodo condimentum turpis, at feugiat ipsum tempus eget. Sed ac enim vitae eros venenatis lacinia quis ut risus. Nunc at viverra eros, at commodo justo. Nunc at rhoncus lectus. Nullam interdum sagittis orci, nec commodo metus bibendum non. Sed non pulvinar augue, a placerat odio. Aliquam cursus enim a tristique ullamcorper. Vestibulum vestibulum tellus at tempor consectetur. Nullam tempor dui eget risus euismod aliquam et eget erat.'
                      '\n\nSuspendisse iaculis eu lorem convallis iaculis. In porttitor porttitor mi eu condimentum. Praesent ac varius leo. Morbi feugiat dui eget diam elementum viverra. Nunc in sodales neque, et semper mi. Sed ut tristique dolor. Vestibulum at tortor non odio ullamcorper pharetra non vel erat. Donec molestie massa ut lobortis dictum. Nam ac urna vitae nisi hendrerit facilisis. Fusce feugiat est sed venenatis viverra. Duis iaculis nibh elementum blandit condimentum.'
                      '\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas in luctus nunc. Morbi a nunc at felis pellentesque auctor in a sapien. Nulla sollicitudin rhoncus ipsum vitae varius. Nunc a lorem aliquam, suscipit nisl sit amet, dignissim augue. Maecenas consectetur ex sed arcu convallis, venenatis iaculis eros pellentesque. Aliquam quis venenatis purus. Nullam vitae gravida urna, sit amet molestie turpis. Nulla vestibulum elit vel erat rhoncus finibus. Suspendisse dictum pretium blandit. Curabitur consectetur ligula tortor, vitae scelerisque dolor faucibus id.'
                      '\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas in luctus nunc. Morbi a nunc at felis pellentesque auctor in a sapien. Nulla sollicitudin rhoncus ipsum vitae varius. Nunc a lorem aliquam, suscipit nisl sit amet, dignissim augue. Maecenas consectetur ex sed arcu convallis, venenatis iaculis eros pellentesque. Aliquam quis venenatis purus. Nullam vitae gravida urna, sit amet molestie turpis. Nulla vestibulum elit vel erat rhoncus finibus. Suspendisse dictum pretium blandit. Curabitur consectetur ligula tortor, vitae scelerisque dolor faucibus id.'
                      '\n\nNunc condimentum odio nec massa commodo ullamcorper. Nam eu eleifend quam. Sed non elit nec ex molestie pretium. Aliquam accumsan, diam ac pretium dapibus, nisi purus fermentum urna, imperdiet tincidunt sem dui nec nulla. Fusce in pulvinar magna. Nulla id odio dapibus, hendrerit ex nec, volutpat arcu. Sed sodales eget neque eu pharetra. Nullam posuere turpis in tortor sodales, in placerat tellus mattis.' *
                  1, // Example text to demonstrate scrolling
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
