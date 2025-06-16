import 'package:flutter/material.dart';

class FinalizacaoTesteConcentrado extends StatelessWidget {
  const FinalizacaoTesteConcentrado({super.key});

  @override
  Widget build(BuildContext context) {
    // Garante que argumentos são do tipo Map<String, dynamic>
    final rawArgs = ModalRoute.of(context)!.settings.arguments;
    final Map<String, dynamic> args =
        rawArgs is Map ? Map<String, dynamic>.from(rawArgs) : {};

    // Extrai listas de resultados
    final List<Map<String, dynamic>> listaAlternado = (args['alternado'] is List)
        ? List<Map<String, dynamic>>.from(args['alternado'])
        : [];
    final List<Map<String, dynamic>> listaConcentrado = (args['concentrado'] is List)
        ? List<Map<String, dynamic>>.from(args['concentrado'])
        : [];

    // Estatísticas para a próxima etapa
    final int totalC = listaConcentrado.length;
    final int somaTemposC = listaConcentrado.fold<int>(
        0, (soma, item) => soma + (item['tempo'] as int));
    final double tempoMedioC = totalC > 0 ? somaTemposC / totalC : 0.0;
    final int acertosC =
        listaConcentrado.where((item) => item['acerto'] == true).length;
    final int errosC = totalC - acertosC;
    final double taxaAcertoC = totalC > 0 ? (acertosC / totalC) * 100 : 0.0;

    final Map<String, dynamic> resultadosCompletos = {
      'alternado': {'resultados': listaAlternado},
      'concentrado': {
        'resultados': listaConcentrado,
        'total': totalC,
        'somaTempos': somaTemposC,
        'tempoMedio': tempoMedioC,
        'acertos': acertosC,
        'erros': errosC,
        'taxaAcerto': taxaAcertoC,
      },
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Finalização: Atenção Concentrada'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade100,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Parabéns! Você terminou o Teste de Atenção Concentrada!',
              style: TextStyle(fontSize: 28),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Vai para o modelo do Teste Dividido levando resultados acumulados
                print('✅ Total no Alternado vindo do anterior: ${listaAlternado.length}');
                print('✅ Total no Concentrado: ${listaConcentrado.length}');
                Navigator.pushReplacementNamed(
                  context,
                  '/modelotestedividido',
                  arguments: resultadosCompletos,
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.white,
              ),
              child: const Text('Vamos para o Modelo do Teste Dividido!'),
            ),
          ],
        ),
      ),
    );
  }
}
