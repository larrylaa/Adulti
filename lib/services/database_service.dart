/// Abstract database interface.
/// Mirrors the Firestore call signature so swapping in
/// FirestoreDatabaseService later requires zero changes in providers/UI.
abstract class DatabaseService {
  /// Persist a partial or full [statsMap] for the given [uid].
  Future<void> updateUserStats(String uid, Map<String, dynamic> statsMap);

  /// Retrieve the latest stats map for [uid]. Returns null if not found.
  Future<Map<String, dynamic>?> getUserStats(String uid);
}
