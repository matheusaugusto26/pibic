import 'package:flutter/material.dart';
import 'package:aplicacao/services/resultados_cache.dart';
import 'package:aplicacao/services/pdf_generator.dart';

class ResultadosAnteriores extends StatefulWidget {
  const ResultadosAnteriores({super.key});

  @override
  State<ResultadosAnteriores> createState() => _ResultadosAnterioresState();
}

class _ResultadosAnterioresState extends State<ResultadosAnteriores> {
  String filtroBusca = '';

  @override
  Widget build(BuildContext context) {
    final resultados = ResultadosCache().listarTodosResultados();
    final filtrados = resultados.where((r) {
      final nome = r['nome']?.toLowerCase() ?? '';
      return nome.contains(filtroBusca.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados Anteriores'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar por nome...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (valor) {
                setState(() {
                  filtroBusca = valor;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtrados.length,
              itemBuilder: (context, index) {
                final resultado = filtrados[index];
                return ListTile(
                  title: Text(resultado['nome'] ?? 'Sem nome'),
                  subtitle: Text('Data: ${resultado['data'] ?? 'Desconhecida'}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.picture_as_pdf),
                    onPressed: () {
                      gerarPdfComDados(resultado);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void gerarPdfComDados(Map<String, dynamic> dados) {
  gerarPDF(dados); // função existente que já gera PDF com os dados passados
}
