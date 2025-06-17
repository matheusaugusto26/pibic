import 'package:flutter/material.dart';

class FinalizacaoTesteConcentrado extends StatelessWidget {
  const FinalizacaoTesteConcentrado({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Finalização: Atenção Concentrada'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Parabéns! Você terminou o Teste de Atenção Concentrada!',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/modelotestedividido');
              },
              child: const Text('Vamos para o Modelo do Teste Dividido!'),
            ),
          ],
        ),
      ),
    );
  }
}
