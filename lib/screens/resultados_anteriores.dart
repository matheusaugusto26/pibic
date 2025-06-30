import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aplicacao/services/relatorio_pdf.dart';

class ResultadosAnteriores extends StatefulWidget {
  const ResultadosAnteriores({super.key});

  @override
  State<ResultadosAnteriores> createState() => _ResultadosAnterioresState();
}

class _ResultadosAnterioresState extends State<ResultadosAnteriores> {
  String filtroBusca = '';

  Future<List<Map<String, dynamic>>> listarTodosResultados() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('sessions').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: listarTodosResultados(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Nenhum resultado encontrado.'));
                }

                final resultados = snapshot.data!;
                final filtrados = resultados.where((r) {
                  final nome =
                      (r['nomePaciente'] ?? '').toString().toLowerCase();
                  return nome.contains(filtroBusca.toLowerCase());
                }).toList();

                return ListView.builder(
                  itemCount: filtrados.length,
                  itemBuilder: (context, index) {
                    final resultado = filtrados[index];
                    final nome = resultado['nomePaciente'] ?? 'Sem nome';
                    final data = resultado['dataAplicacao']?.substring(0, 10) ??
                        'Desconhecida';

                    return ListTile(
                      title: Text(nome),
                      subtitle: Text('Data: $data'),
                      trailing: IconButton(
                        icon: const Icon(Icons.picture_as_pdf),
                        onPressed: () {
                          exportarRelatorioPdf(resultado, context);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
