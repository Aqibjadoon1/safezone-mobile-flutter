import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionStore {
  SessionStore({
    FlutterSecureStorage? secureStorage,
    SharedPreferences? preferences,
  })  : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        _preferences = preferences;

  final FlutterSecureStorage _secureStorage;
  SharedPreferences? _preferences;

  static const _tokenKey = 'safezone.jwt';
  static const _demoModeKey = 'safezone.demoMode';

  Future<void> saveToken(String token) =>
      _secureStorage.write(key: _tokenKey, value: token);

  Future<String?> readToken() => _secureStorage.read(key: _tokenKey);

  Future<void> clearToken() => _secureStorage.delete(key: _tokenKey);

  Future<bool> demoMode() async {
    final prefs = await _prefs();
    return prefs.getBool(_demoModeKey) ?? true;
  }

  Future<void> setDemoMode(bool value) async {
    final prefs = await _prefs();
    await prefs.setBool(_demoModeKey, value);
  }

  Future<SharedPreferences> _prefs() async {
    return _preferences ??= await SharedPreferences.getInstance();
  }
}
