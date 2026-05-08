import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  final _key = encrypt.Key.fromUtf8(
    'My32lengthsupersecretnooneknows1',
  ); // 32 chars
  final _iv = encrypt.IV.fromLength(16);

  String encryptText(String plainText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  String decryptText(String encryptedText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final decrypted = encrypter.decrypt64(encryptedText, iv: _iv);
    return decrypted;
  }
}
