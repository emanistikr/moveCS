import 'package:flutter/material.dart';
import '../controller/info_stops.dart';
import '../controller/info_lines.dart';
import '../models/search_result.dart';
import '../models/search_category.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../secret.dart';

class SearchRepository {
  String? _sessionToken;
  final String _apiKey = Secret.googleApiKey;

  // Metodo richiamato per effettuare la ricerca
  Future<List<SearchResult>> search({
    required String query,
    required SearchCategory category,
  }) async {
    if (query.trim().isEmpty) return [];

    try {
      switch (category) {
        case SearchCategory.places:
          return await _searchPlaces(query);
        case SearchCategory.stops:
          return _searchStops(query);
        case SearchCategory.lines:
          return _searchLines(query);
      }
    } catch (e) {
      print("Errore di ricerca $query: $e");
      return [];
    }
  }

  //RICERCA LUOGHI (Con le api di Google places)
  Future<List<SearchResult>> _searchPlaces(String query) async {
    // Genera un token se non lo ho già
    _sessionToken ??= const Uuid().v4();

    final results = await _fetchPlacesSuggestions(query);

    return results.map((prediction) {
      final structuredFormatting = prediction['structured_formatting'] ?? {};

      return SearchResult(
        id: prediction['place_id'],
        title: structuredFormatting['main_text'] ?? prediction['description'],
        subtitle: structuredFormatting['secondary_text'] ?? 'Cosenza',

        type: SearchCategory.places,
        lat: null,
        lng: null,
      );
    }).toList();
  }

  // Chiamata alle API per l'autocompletamento
  Future<List<dynamic>> _fetchPlacesSuggestions(String query) async {
    //dati di cosenza
    const String cosenzaLat = '39.30675240718467';
    const String cosenzaLng = '16.247687777562174';
    const String radius = '10000';

    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=$query'
        '&key=$_apiKey'
        '&sessiontoken=$_sessionToken' //usando la stessa sessione faccio meno richieste
        '&language=it'
        '&location=$cosenzaLat,$cosenzaLng'
        '&radius=$radius'
        '&strictbounds' //solo risultati entro il raggio
        '&components=country:it';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        debugPrint('Response body: ${response.body}');
        final data = json.decode(response.body);
        if (data['status'] == 'OK' || data['status'] == 'ZERO_RESULTS') {
          return data['predictions'];
        }
      }
      return [];
    } catch (e) {
      print('Errore API Places: $e');
      return [];
    }
  }

  // RICERCA FERMATE (cached in infoStops)
  List<SearchResult> _searchStops(String query) {
    final docs = infoStops.getCachedMarkers();

    return docs
        .where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final name = (data['name'] ?? '').toLowerCase();

          return name.contains(query.toLowerCase());
        })
        .map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return SearchResult(
            id: doc.id,
            title: data['name'],
            subtitle: data['city'],
            type: SearchCategory.stops,
            lat: data['lat'].toString(),
            lng: data['lng'].toString(),
            data: data,
          );
        })
        .toList();
  }

  // 3. RICERCA LINEE (da infoLines)
  Future<List<SearchResult>> _searchLines(String query) async {
    final busData = await InfoLines.getBusLines();

    return busData
        .where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final longName = (data['long_name'] ?? '').toString().toLowerCase();
          final shortName = (data['short_name'] ?? '').toString().toLowerCase();

          return longName.contains(query.toLowerCase()) ||
              shortName.contains(query.toLowerCase());
        })
        .map((doc) {
          final data = doc.data() as Map<String, dynamic>;

          return SearchResult(
            id: doc.id,
            title: data['long_name'],
            subtitle: data['destination'],
            type: SearchCategory.lines,
          );
        })
        .toList();
  }

  Future<(String, String)?> getPlaceDetails(String placeId) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json'
        '?place_id=$placeId'
        '&fields=geometry' // Scarichiamo SOLO la geometria per risparmiare
        '&key=$_apiKey'
        '&sessiontoken=$_sessionToken'; // Usiamo lo stesso token!

    try {
      final response = await http.get(Uri.parse(url));

      _sessionToken = null;
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['result'] != null) {
          final location = data['result']['geometry']['location'];
          return (location['lat'].toString(), location['lng'].toString());
        }
      }
    } catch (e) {
      print('Errore Dettagli Place: $e');
    }
    return null;
  }
}
