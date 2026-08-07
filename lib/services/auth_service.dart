import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/constants.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();

  Future<void> login(String token) async {
    await _storage.write(key: AppConstants.secureStorageKey, value: token);
  }

  Future<void> logout() async {
    await _storage.delete(key: AppConstants.secureStorageKey);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: AppConstants.secureStorageKey);
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
