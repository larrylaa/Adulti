import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_service.dart';

/// Mock database backed by SharedPreferences.
/// Stores one JSON blob per uid under the key "user_stats_{uid}".
/// Drop-in replacement: implement [DatabaseService] with FirestoreDatabaseService
/// and swap the provider binding — no other code changes needed.
class MockDatabaseService implements DatabaseService {
  static const _prefix = 'user_stats_';

  @override
  Future<void> updateUserStats(
    String uid,
    Map<String, dynamic> statsMap,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    // Merge with existing data so partial updates don't wipe fields
    final existing = await getUserStats(uid) ?? {};
    final merged = {...existing, ...statsMap};
    await prefs.setString('$_prefix$uid', jsonEncode(merged));
  }

  @override
  Future<Map<String, dynamic>?> getUserStats(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_prefix$uid');
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}
