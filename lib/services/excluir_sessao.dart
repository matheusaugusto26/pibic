import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> excluirSessaoComResultados(String sessionId, BuildContext context) async {
  final db = FirebaseFirestore.instance;

  try {
    final resultadosSnapshot = await db
        .collection('sessions')
        .doc(sessionId)
        .collection('results')
        .get();

    for (final doc in resultadosSnapshot.docs) {
      await doc.reference.delete();
    }

    await db.collection('sessions').doc(sessionId).delete();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sessão excluída com sucesso.')),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir sessão: $e')),
      );
    }
    rethrow;
  }
}
