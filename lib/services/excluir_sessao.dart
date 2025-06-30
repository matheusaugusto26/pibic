import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> excluirSessaoComResultados(String sessionId) async {
  final db = FirebaseFirestore.instance;
  final batch = db.batch();

  final resultadosSnapshot = await db
      .collection('sessions')
      .doc(sessionId)
      .collection('results')
      .get();

  for (final doc in resultadosSnapshot.docs) {
    batch.delete(doc.reference);
  }

  final sessaoRef = db.collection('sessions').doc(sessionId);
  batch.delete(sessaoRef);

  await batch.commit();
}
