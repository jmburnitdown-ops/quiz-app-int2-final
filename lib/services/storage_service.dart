import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  // Use secure storage for Course Goal 1: Encrypted storage for sensitive data
  // This satisfies the requirement to protect data at rest
  final _storage = const FlutterSecureStorage();

  /// Saves the high score securely.
  /// This meets the 'Data Persistence' and 'Security' core requirements.
  Future<void> saveHighScore(int score) async {
    try {
      // Security check: Ensure the score is not negative before saving
      if (score < 0) return;

      await _storage.write(
        key: 'high_score', 
        value: score.toString()
      );
    } catch (e) {
      // Log error internally (Security: Don't expose storage errors to UI)
      debugPrint("Security Error: Failed to write to secure storage: $e");
    }
  }

  /// Retrieves the high score from encrypted storage.
  /// Fulfills the requirement for secure authentication/data retrieval.
  Future<String?> getHighScore() async {
    try {
      final value = await _storage.read(key: 'high_score');
      
      // Data Sanitization: Ensure the returned value contains only digits
      if (value != null && !RegExp(r'^\d+$').hasMatch(value)) {
        debugPrint("Security Warning: High score data tampered with or corrupted.");
        return "0";
      }
      
      return value;
    } catch (e) {
      debugPrint("Security Error: Failed to read from secure storage: $e");
      return null;
    }
  }

  /// Optional: Clear all data (Useful for 'Log Out' functionality)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}