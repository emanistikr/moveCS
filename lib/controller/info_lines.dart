import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InfoLines {
  static List<QueryDocumentSnapshot>? _cachedLines;

  //scarica le linee dal database
  static Future<List<QueryDocumentSnapshot>> getBusLines() async {
    // Scarichiamo i dati solo se la cache è vuota
    if (_cachedLines == null) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('lines')
            .get();
        _cachedLines = snapshot.docs;
      } catch (e) {
        debugPrint('Errore durante il download delle linee: $e');
        return [];
      }
    }
    return _cachedLines!;
  }

  static Future<void> loadLinesData() async {
    await getBusLines();
  }

  // Metodo getter per i dettagli di una singola linea tramite ID
  static Map<String, dynamic>? getLineDetails(String lineId) {
    if (_cachedLines == null) return null;

    try {
      final doc = _cachedLines!.firstWhere((doc) => doc.id == lineId);
      return doc.data() as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  // HEX to Color
  static Color hexToColor(String? hexString) {
    if (hexString == null || hexString.isEmpty) return Colors.grey;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
