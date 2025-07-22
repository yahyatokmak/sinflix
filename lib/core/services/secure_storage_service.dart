import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true, // Android Keystore kullan
    ),
    iOptions: IOSOptions(
      accessibility:
          KeychainAccessibility.first_unlock_this_device, // iOS Keychain
    ),
  );

  // Keys
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _tokenExpiryKey = 'token_expiry';

  /// Token'ı güvenli şekilde kaydet
  static Future<void> saveToken(String token) async {
    try {
      // Token expiry date'i çıkar (JWT ise)
      final expiryDate = _extractTokenExpiry(token);

      await Future.wait([
        _storage.write(key: _tokenKey, value: token),
        if (expiryDate != null)
          _storage.write(
            key: _tokenExpiryKey,
            value: expiryDate.toIso8601String(),
          ),
      ]);
    } catch (e) {
      throw Exception('Token kaydetme hatası: $e');
    }
  }

  /// Token'ı güvenli şekilde al
  static Future<String?> getToken() async {
    try {
      final token = await _storage.read(key: _tokenKey);

      if (token == null) return null;

      // Token expiry kontrolü
      if (await _isTokenExpired()) {
        await clearAll(); // Süresi dolmuş token'ları temizle
        return null;
      }

      return token;
    } catch (e) {
      return null;
    }
  }

  /// User ID kaydet
  static Future<void> saveUserId(String userId) async {
    try {
      await _storage.write(key: _userIdKey, value: userId);
    } catch (e) {
      throw Exception('User ID kaydetme hatası: $e');
    }
  }

  /// User ID al
  static Future<String?> getUserId() async {
    try {
      return await _storage.read(key: _userIdKey);
    } catch (e) {
      return null;
    }
  }

  /// Tüm verileri güvenli şekilde temizle
  static Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      // Hata olursa manuel olarak key'leri sil
      await Future.wait([
        _storage.delete(key: _tokenKey),
        _storage.delete(key: _userIdKey),
        _storage.delete(key: _tokenExpiryKey),
      ]);
    }
  }

  /// Login durumunu kontrol et
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Geçerli token var mı kontrol et
  static Future<bool> hasValidToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Token'ın süresinin dolup dolmadığını kontrol et
  static Future<bool> _isTokenExpired() async {
    try {
      final expiryString = await _storage.read(key: _tokenExpiryKey);
      if (expiryString == null) return false; // Expiry bilgisi yok, valid say

      final expiryDate = DateTime.parse(expiryString);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      return false; // Hata durumunda valid say
    }
  }

  /// JWT token'dan expiry date çıkar
  static DateTime? _extractTokenExpiry(String token) {
    try {
      if (!token.contains('.')) return null; // JWT değil

      final parts = token.split('.');
      if (parts.length != 3) return null; // Geçersiz JWT

      // Payload kısmını decode et
      final payload = parts[1];
      final normalizedPayload = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalizedPayload));
      final payloadMap = json.decode(decoded) as Map<String, dynamic>;

      // 'exp' field'ı JWT expiry timestamp'i
      final exp = payloadMap['exp'] as int?;
      if (exp == null) return null;

      return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    } catch (e) {
      return null; // Parse edilemezse null döndür
    }
  }

  /// Development/Debug için - tüm stored value'ları göster
  static Future<Map<String, String>> getAllStoredValues() async {
    try {
      return await _storage.readAll();
    } catch (e) {
      return {};
    }
  }
}
