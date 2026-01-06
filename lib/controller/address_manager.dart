import 'package:shared_preferences/shared_preferences.dart';

class AddressManager {
  static const _keyHome = 'address_home';
  static const _keyWork = 'address_work';

  Future<String?> getHomeAddress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyHome);
  }

  Future<String?> getWorkAddress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyWork);
  }

  Future<void> saveAddresses({String? home, String? work}) async {
    final prefs = await SharedPreferences.getInstance();

    if (home != null && home.isNotEmpty) {
      await prefs.setString(_keyHome, home);
    }

    if (work != null && work.isNotEmpty) {
      await prefs.setString(_keyWork, work);
    }
  }
}
