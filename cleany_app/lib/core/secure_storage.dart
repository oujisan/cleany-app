import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const storage = FlutterSecureStorage();

  static Future<void> write(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  static Future<String?> read(String key) async {
    return await storage.read(key: key);
  }

  static Future<void> delete(String key) async {
    await storage.delete(key: key);
  }

  static Future<void> clear() async {
    await storage.deleteAll();
  }
}