import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  final _storage = const FlutterSecureStorage();

  // Platform options
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  Future<void> saveSession(String key, String value) async {
    await _storage.write(
      key: key,
      value: value,
      aOptions: _getAndroidOptions(),
    );
  }

  Future<String?> getSession(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> removeSession(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> clearAllSessions() async {
    await _storage.deleteAll();
  }
}
