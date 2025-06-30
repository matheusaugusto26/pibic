import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:aplicacao/services/relatorio_pdf.dart';
import 'package:aplicacao/services/recuperar_dados_testes.dart';
import 'package:aplicacao/services/excluir_sessao.dart';

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
    final resultados = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();

    resultados.sort((a, b) {
      final dataA = DateTime.tryParse(a['dataAplicacao'] ?? '') ?? DateTime(0);
      final dataB = DateTime.tryParse(b['dataAplicacao'] ?? '') ?? DateTime(0);
      return dataB.compareTo(dataA);
    });

    final idsVistos = <String>{};
    final unicos = resultados.where((e) => idsVistos.add(e['id'])).toList();

    return unicos;
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

                    final dataRaw = resultado['dataAplicacao'] ?? '';
                    final dataFormatada = () {
                      try {
                        final dt = DateTime.parse(dataRaw);
                        return DateFormat('dd/MM/yyyy HH:mm').format(dt);
                      } catch (_) {
                        return 'Data inválida';
                      }
                    }();

                    return ListTile(
                      title: Text(nome),
                      subtitle: Text('Data: $dataFormatada'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.picture_as_pdf),
                            onPressed: () async {
                              final sessionId = resultado['id'];
                              final dadosTeste =
                                  await recuperarDadosCalculados(sessionId);
                              final dadosCompletos = {
                                ...resultado,
                                ...dadosTeste
                              };
                              if (!context.mounted) return;
                              await exportarRelatorioPdf(
                                  dadosCompletos, context);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final sessionId = resultado['id'];

                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirmar exclusão'),
                                  content: const Text(
                                      'Tem certeza que deseja excluir esta sessão?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancelar'),
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                    ),
                                    ElevatedButton(
                                      child: const Text('Excluir'),
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                if (!context.mounted) return;
                                await excluirSessaoComResultados(
                                    sessionId, context);
                                if (context.mounted) setState(() {});
                              }
                            },
                          ),
                        ],
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
