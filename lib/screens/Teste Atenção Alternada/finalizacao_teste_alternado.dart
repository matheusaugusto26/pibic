import 'package:flutter/material.dart';

class FinalizacaoTesteAlternado extends StatelessWidget {
  const FinalizacaoTesteAlternado({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Finalização: Atenção Alternada'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Parabéns! Você terminou o Teste de Atenção Alternada!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 28),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/modelotesteconcentrado');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text('Vamos para o Modelo do Teste Concentrado!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
