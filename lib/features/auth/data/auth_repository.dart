import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthRepository {
  final _storage = const FlutterSecureStorage();

  // Keys for the Android Keystore / iOS Keychain (Textbook Ch. 3.6)
  final _tokenKey = 'auth_token';
  final _userKey = 'user_data';

  // 🌐 Connects to your Django Web Version (Textbook Ch. 4.1)
  static const String _baseUrl = 'http://192.168.1.XX:8000/api/auth';

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login/'),
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // 🛡️ Security: Store the JWT Token securely (Chapter 3.6)
        await _storage.write(key: _tokenKey, value: data['token']);
        await _storage.write(key: _userKey, value: json.encode(data['user']));
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Verification logic for the SOS and Settings screens
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // 🔄 Lifecycle Support: Check if user is already logged in (Chapter 1.8)
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }

  Future<void> logout() async {
    // 📝 Data Privacy: Wipe sensitive credentials (Chapter 2.11)
    await _storage.deleteAll();
  }
}
