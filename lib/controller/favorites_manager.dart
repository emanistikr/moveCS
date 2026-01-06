import 'package:shared_preferences/shared_preferences.dart';

class FavoritesManager {
  static const _keyFavorites = 'favorite_bus_lines';

  /// Recupera la lista dei preferiti salvata
  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyFavorites) ?? [];
    /*     Future.delayed(const Duration(milliseconds: 5000));
    return ['CVR', 'CVC', 'CVRO']; */
  }

  Future<void> toggleFavorite(String busLineId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> currentFavorites =
        prefs.getStringList(_keyFavorites) ?? [];

    if (currentFavorites.contains(busLineId)) {
      currentFavorites.remove(busLineId); // Rimuovi se c'è già
    } else {
      currentFavorites.add(busLineId); // Aggiungi se non c'è
    }

    await prefs.setStringList(_keyFavorites, currentFavorites);
  }

  Future<bool> isFavorite(String busLineId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_keyFavorites) ?? [];
    return favorites.contains(busLineId);
  }
}
