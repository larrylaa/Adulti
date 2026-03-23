import 'package:cloud_firestore/cloud_firestore.dart';

import 'database_service.dart';

class FirestoreDatabaseService implements DatabaseService {
  FirestoreDatabaseService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<void> updateUserStats(
    String uid,
    Map<String, dynamic> statsMap,
  ) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .set(statsMap, SetOptions(merge: true));
  }

  @override
  Future<Map<String, dynamic>?> getUserStats(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();
    final data = snapshot.data();
    if (data == null) {
      return null;
    }
    return Map<String, dynamic>.from(data);
  }
}
