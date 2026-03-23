import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_stats.dart';
import '../models/debt_entry.dart';
import '../services/firestore_database_service.dart';

final _db = FirestoreDatabaseService();

final userStatsProvider = StateNotifierProvider<UserStatsNotifier, UserStats>((
  ref,
) {
  final notifier = UserStatsNotifier(FirebaseAuth.instance.currentUser?.uid);
  notifier.loadFromDb();
  return notifier;
});

class UserStatsNotifier extends StateNotifier<UserStats> {
  UserStatsNotifier(this._uid) : super(const UserStats());

  final String? _uid;

  Future<void> loadFromDb() async {
    final uid = _uid;
    if (uid == null || uid.isEmpty) {
      return;
    }

    final map = await _db.getUserStats(uid);
    if (map != null) {
      state = UserStats.fromMap(map);
    }
  }

  Future<void> _persist() async {
    final uid = _uid;
    if (uid == null || uid.isEmpty) {
      return;
    }

    await _db.updateUserStats(uid, state.toMap());
  }

  Future<void> setName(String? n) async {
    state = state.copyWith(name: n);
    await _persist();
  }

  Future<void> setGender(CharacterGender g) async {
    state = state.copyWith(gender: g);
    await _persist();
  }

  Future<void> setClass(CharacterClass cls) async {
    state = state.copyWith(characterClass: cls);
    await _persist();
  }

  Future<void> setSavings(double value) async {
    state = state.copyWith(savings: value.clamp(0, double.infinity));
    await _persist();
  }

  Future<void> setSavingsGoal(double value) async {
    state = state.copyWith(savingsGoal: value.clamp(100, double.infinity));
    await _persist();
  }

  Future<void> setSavingsGoalUnknown(bool value) async {
    state = state.copyWith(savingsGoalUnknown: value);
    await _persist();
  }

  Future<void> setChecking(double value) async {
    state = state.copyWith(checking: value.clamp(0, double.infinity));
    await _persist();
  }

  Future<void> addDebt(DebtEntry entry) async {
    state = state.copyWith(debts: [...state.debts, entry]);
    await _persist();
  }

  Future<void> updateDebt(DebtEntry updated) async {
    state = state.copyWith(
      debts: state.debts.map((d) => d.id == updated.id ? updated : d).toList(),
    );
    await _persist();
  }

  Future<void> removeDebt(String id) async {
    state = state.copyWith(
      debts: state.debts.where((d) => d.id != id).toList(),
    );
    await _persist();
  }

  Future<void> setHasRothIra(bool value) async {
    state = state.copyWith(hasRothIra: value);
    await _persist();
  }

  Future<void> setInvestmentsUnknown(bool value) async {
    state = state.copyWith(investmentsUnknown: value);
    await _persist();
  }

  Future<void> setRothIraBalance(double value) async {
    state = state.copyWith(rothIraBalance: value.clamp(0, double.infinity));
    await _persist();
  }

  Future<void> setHas401k(bool value) async {
    state = state.copyWith(has401k: value);
    await _persist();
  }

  Future<void> set401kBalance(double value) async {
    state = state.copyWith(balance401k: value.clamp(0, double.infinity));
    await _persist();
  }

  Future<void> setHasBrokerage(bool value) async {
    state = state.copyWith(hasBrokerage: value);
    await _persist();
  }

  Future<void> setBrokerageBalance(double value) async {
    state = state.copyWith(brokerageBalance: value.clamp(0, double.infinity));
    await _persist();
  }

  Future<void> setAnnualSalary(double value) async {
    state = state.copyWith(annualSalary: value.clamp(0, double.infinity));
    await _persist();
  }

  Future<void> setCreditScoreStatus(String? value) async {
    state = state.copyWith(creditScoreStatus: value);
    await _persist();
  }

  Future<void> completeRoadmapStep(String stepId) async {
    if (state.completedRoadmapStepIds.contains(stepId)) {
      return;
    }

    state = state.copyWith(
      completedRoadmapStepIds: [...state.completedRoadmapStepIds, stepId],
    );
    await _persist();
  }

  Future<void> uncompleteRoadmapStep(String stepId) async {
    if (!state.completedRoadmapStepIds.contains(stepId)) {
      return;
    }

    state = state.copyWith(
      completedRoadmapStepIds: state.completedRoadmapStepIds
          .where((id) => id != stepId)
          .toList(),
    );
    await _persist();
  }

  Future<void> resetRoadmapProgress() async {
    state = state.copyWith(completedRoadmapStepIds: const []);
    await _persist();
  }

  Future<void> mint() async {
    state = state.copyWith(hasMinted: true);
    await _persist();
  }

  Future<void> reset() async {
    state = const UserStats();
    await _persist();
  }
}
