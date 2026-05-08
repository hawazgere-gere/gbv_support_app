import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthNotifier extends StateNotifier<bool> {
  final _storage = const FlutterSecureStorage();

  static const _usersKey = "users_db"; // all users stored here

  AuthNotifier() : super(false);

  /// =========================
  /// REGISTER USER
  /// =========================
  Future<void> register(String username, String password) async {
    final users = await _getUsers();

    // prevent duplicate accounts
    if (users.containsKey(username)) {
      throw Exception("User already exists");
    }

    users[username] = password;

    await _saveUsers(users);
  }

  /// =========================
  /// LOGIN USER
  /// =========================
  Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final users = await _getUsers();

    // master login (for testing)
    if (username == "admin" && password == "123456") {
      state = true;
      return true;
    }

    if (users.containsKey(username) && users[username] == password) {
      state = true;
      return true;
    }

    return false;
  }

  /// =========================
  /// CHECK IF USER EXISTS
  /// =========================
  Future<bool> userExists(String username) async {
    final users = await _getUsers();
    return users.containsKey(username);
  }

  /// =========================
  /// LOGOUT
  /// =========================
  void logout() {
    state = false;
  }

  /// =========================
  /// CLEAR ALL DATA
  /// =========================
  Future<void> clearAllData() async {
    await _storage.deleteAll();
    state = false;
  }

  /// =========================
  /// INTERNAL: LOAD USERS
  /// =========================
  Future<Map<String, String>> _getUsers() async {
    final data = await _storage.read(key: _usersKey);

    if (data == null) return {};

    final decoded = jsonDecode(data) as Map<String, dynamic>;

    return decoded.map((key, value) => MapEntry(
          key,
          value.toString(),
        ));
  }

  /// =========================
  /// INTERNAL: SAVE USERS
  /// =========================
  Future<void> _saveUsers(Map<String, String> users) async {
    await _storage.write(
      key: _usersKey,
      value: jsonEncode(users),
    );
  }
}

/// Provider
final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});
