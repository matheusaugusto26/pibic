import 'package:flutter/material.dart';

class FinalizacaoTesteDividido extends StatelessWidget {
  const FinalizacaoTesteDividido({super.key});

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
            const Text('Parabéns! Você terminou Todos os Testes!',
                style: TextStyle(fontSize: 38), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/proximospassos');
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue, backgroundColor: Colors.white),
              child: const Text('Vamos para os Próximos Passos!'),
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
        Navigator.pushReplacementNamed(context, '/proximospassos');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Parabéns! Você terminou Todos os Testes!'),
        ));
      },
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blue, backgroundColor: Colors.white),
      child: const Text('Vamos para os Próximos Passos!'),
    );
  }
}

class ElevatedButtonShows extends StatefulWidget {
  const ElevatedButtonShows({super.key});

  @override
  ElevatedButtonShowsState createState() => ElevatedButtonShowsState();
}

class ElevatedButtonShowsState extends State<ElevatedButtonShows> {
  final bool _isButtonVisible = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isButtonVisible
          ? const NextTestButton()
          : const CircularProgressIndicator(), // Show a loading indicator while waiting
    );
  }
}
