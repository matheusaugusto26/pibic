import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void appLog(String message) {
    if (kDebugMode) {
      print('[FirebaseService] $message');
    }
  }

  Future<String> saveSession(Map<String, dynamic> sessionData) async {
    try {
      final doc = await _db.collection('sessions').add({
        ...sessionData,
        'createdAt': kIsWeb
            ? DateTime.now().toIso8601String()
            : FieldValue.serverTimestamp(),
      });

      appLog('Sessão salva com ID: ${doc.id}');
      return doc.id;
    } catch (e) {
      appLog('Erro ao salvar sessão: $e');
      rethrow;
    }
  }

  Future<void> saveResults(
    String sessionId,
    List<Map<String, dynamic>> results,
    String tipoTeste,
  ) async {
    if (results.isEmpty) {
      appLog('Nenhum resultado para salvar no teste $tipoTeste da sessão $sessionId');
      return;
    }

    try {
      final batch = _db.batch();
      final resultsCol =
          _db.collection('sessions').doc(sessionId).collection('results');

      for (var result in results) {
        final sanitizedResult = Map<String, dynamic>.from(result);

        if (sanitizedResult['numEsquerda'] is List) {
          sanitizedResult['numEsquerda'] =
              List<int>.from(sanitizedResult['numEsquerda']);
        }

        final ref = resultsCol.doc();
        batch.set(ref, {
          ...sanitizedResult,
          'tipoTeste': tipoTeste,
          'timestamp': kIsWeb
              ? DateTime.now().toIso8601String()
              : FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
      appLog('Resultados salvos para $tipoTeste (sessão $sessionId)');
    } catch (e) {
      appLog('Erro ao salvar resultados do teste $tipoTeste: $e');
      rethrow;
    }
  }
}