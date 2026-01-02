import 'search_category.dart';

class SearchResult {
  final String id;
  final String title;
  final String subtitle;
  final SearchCategory type;
  final String? lat;
  final String? lng;
  final Map<String, dynamic>? data;

  SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    this.lat,
    this.lng,
    this.data,
  });
}
