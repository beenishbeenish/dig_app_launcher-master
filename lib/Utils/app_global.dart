import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppGlobal {
  ///Local URL
  // static String baseUrl = 'http://192.168.1.37:3011/';

  ///Live URL
  static String baseUrl = 'https://dig-app.thecbt.live/';


  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    )
  );

  Future<String> retrieveId() async {
    return await storage.read(key: 'id') ?? '';
  }

  Future<String> accessToken() async {
    return await storage.read(key: 'access_token') ?? '';
  }

  Future<void> setTokenValue(String tokenValue) async {
    await storage.write(key: 'access_token', value: tokenValue);
  }

  Future<void> setUserRole(String role) async {
    await storage.write(key: 'user_role', value: role);
  }

  Future<String?> getUserRole() async {
    return await storage.read(key: 'user_role');
  }

}