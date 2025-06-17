// lib/services/firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Função simples de log que só executa no modo debug
  void appLog(String message) {
    if (kDebugMode) {
      print(message);
    }
  }

  /// Salva os dados da sessão e retorna o ID gerado
  Future<String> saveSession(Map<String, dynamic> sessionData) async {
    final doc = await _db.collection('sessions').add({
      ...sessionData,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  /// Salva uma lista de resultados como subcoleção 'results' dentro da sessão
  /// Inclui o tipo do teste e timestamp em cada resultado
  Future<void> saveResults(
      String sessionId, List<Map<String, dynamic>> results, String tipoTeste) async {
    if (results.isEmpty) {
      appLog('Nenhum resultado para salvar no teste $tipoTeste da sessão $sessionId');
      return;
    }

    final batch = _db.batch();
    final resultsCol = _db.collection('sessions').doc(sessionId).collection('results');

    for (var result in results) {
      // Garantir que campos tipo List estejam serializáveis
      final sanitizedResult = Map<String, dynamic>.from(result);
      if (sanitizedResult['numEsquerda'] is List) {
        sanitizedResult['numEsquerda'] =
            List<int>.from(sanitizedResult['numEsquerda']);
      }

      final ref = resultsCol.doc();
      batch.set(ref, {
        ...sanitizedResult,
        'tipoTeste': tipoTeste,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }
}
