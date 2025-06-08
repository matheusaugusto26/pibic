import 'package:flutter/material.dart';

class FinalizacaoTesteConcentrado extends StatelessWidget {
  const FinalizacaoTesteConcentrado({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blue.shade100,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                'Parabéns! Você terminou o Teste de Atenção Concentrada!',
                style: TextStyle(fontSize: 38),
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/modelotestedividido');
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue, backgroundColor: Colors.white),
              child: const Text('Vamos para o Próximo Teste!'),
            ),
          ],
        ),
      ),
    );
  }
}

class NextTestButton extends StatelessWidget {
  const NextTestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/modelotestedividido');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('Prepare-se para a Aplicação do Teste de Atenção Dividida!'),
        ));
      },
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blue, backgroundColor: Colors.white),
      child: const Text('Vamos para o Modelo do Teste!'),
    );
  }
}
