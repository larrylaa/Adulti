import 'package:flutter/foundation.dart';
import 'mission.dart';
import 'debt_entry.dart';

enum CharacterGender { male, female }

enum CharacterClass {
  student,
  graduate,
  professional;

  String get displayName {
    switch (this) {
      case student:
        return 'Student';
      case graduate:
        return 'Graduate';
      case professional:
        return 'Pro';
    }
  }

  String get tagline {
    switch (this) {
      case student:
        return 'Building the foundation';
      case graduate:
        return 'Starting the grind';
      case professional:
        return 'Playing the long game';
    }
  }
}

@immutable
class UserStats {
  final String? name;
  final CharacterClass? characterClass;
  final CharacterGender? gender;
  final double savings;
  final double savingsGoal;
  final bool savingsGoalUnknown;
  final double checking;
  final bool investmentsUnknown;
  final List<DebtEntry> debts;
  final bool hasRothIra;
  final double rothIraBalance;
  final bool has401k;
  final double balance401k;
  final bool hasBrokerage;
  final double brokerageBalance;
  final double annualSalary;
  final String? creditScoreStatus;
  final bool hasMinted;

  const UserStats({
    this.name,
    this.characterClass,
    this.gender,
    this.savings = 0.0,
    this.savingsGoal = 10000.0,
    this.savingsGoalUnknown = false,
    this.checking = 0.0,
    this.investmentsUnknown = false,
    this.debts = const [],
    this.hasRothIra = false,
    this.rothIraBalance = 0.0,
    this.has401k = false,
    this.balance401k = 0.0,
    this.hasBrokerage = false,
    this.brokerageBalance = 0.0,
    this.annualSalary = 0.0,
    this.creditScoreStatus,
    this.hasMinted = false,
  });

  // ── Computed getters ──────────────────────────────────────────────────────

  double get totalDebt => debts.fold(0.0, (sum, e) => sum + e.amount);

  double get monthlySalary => annualSalary / 12.0;

  /// Debt-to-income ratio: total debt / annual salary (0.0 if no salary)
  double get debtToIncomeRatio =>
      annualSalary > 0 ? (totalDebt / annualSalary).clamp(0.0, 10.0) : 0.0;

  /// Progress toward the user-set savings goal (0.0–1.0)
  double get vaultProgress => (savings / savingsGoal).clamp(0.0, 1.0);

  bool get vaultSealed => savings >= savingsGoal;

  bool get anyInvestmentActive => hasRothIra || has401k || hasBrokerage;

  double get totalInvestments =>
      rothIraBalance + balance401k + brokerageBalance;

  /// Months until debt is paid off at 20% of monthly salary
  int get monthsToDebtFree {
    if (totalDebt <= 0) return 0;
    final monthlyPayment = monthlySalary * 0.20;
    if (monthlyPayment <= 0) return 999;
    return (totalDebt / monthlyPayment).ceil();
  }

  List<Mission> get priorityMissions {
    final missions = <Mission>[];

    if (!vaultSealed) {
      missions.add(
        Mission(
          id: 'seal_vault',
          title: 'Seal the Vault',
          subtitle:
              'Build a \$${savingsGoal.toStringAsFixed(0)} emergency fund — your first line of defense.',
          priority: MissionPriority.high,
        ),
      );
    }

    if (vaultSealed && totalDebt > 0) {
      missions.add(
        const Mission(
          id: 'dispel_shadow',
          title: 'Dispel the Shadow',
          subtitle:
              'Eliminate all debt. The Shadow loses power every dollar you pay.',
          priority: MissionPriority.medium,
        ),
      );
    }

    if (vaultSealed && creditScoreStatus == null) {
      missions.add(
        const Mission(
          id: 'credit_shield',
          title: 'Equip Credit Shield',
          subtitle: 'Track your credit score — invisibility is not a strategy.',
          priority: MissionPriority.utility,
        ),
      );
    }

    if (vaultSealed && totalDebt <= 0 && creditScoreStatus != null) {
      missions.add(
        const Mission(
          id: 'time_machine',
          title: 'Overload the Time Machine',
          subtitle:
              'Max your Roth IRA and 401k. Compound interest is the final boss.',
          priority: MissionPriority.endgame,
        ),
      );
    }

    if (missions.isEmpty) {
      missions.add(
        Mission(
          id: 'seal_vault',
          title: 'Seal the Vault',
          subtitle:
              'Build a \$${savingsGoal.toStringAsFixed(0)} emergency fund — your first line of defense.',
          priority: MissionPriority.high,
        ),
      );
    }

    return missions;
  }

  // ── Serialization ────────────────────────────────────────────────────────

  Map<String, dynamic> toMap() => {
    'name': name,
    'characterClass': characterClass?.index,
    'gender': gender?.index,
    'savings': savings,
    'savingsGoal': savingsGoal,
    'savingsGoalUnknown': savingsGoalUnknown,
    'checking': checking,
    'investmentsUnknown': investmentsUnknown,
    'debts': debts.map((d) => d.toMap()).toList(),
    'hasRothIra': hasRothIra,
    'rothIraBalance': rothIraBalance,
    'has401k': has401k,
    'balance401k': balance401k,
    'hasBrokerage': hasBrokerage,
    'brokerageBalance': brokerageBalance,
    'annualSalary': annualSalary,
    'creditScoreStatus': creditScoreStatus,
    'hasMinted': hasMinted,
  };

  factory UserStats.fromMap(Map<String, dynamic> map) => UserStats(
    name: map['name'] as String?,
    characterClass: map['characterClass'] != null
        ? CharacterClass.values[map['characterClass'] as int]
        : null,
    gender: map['gender'] != null
        ? CharacterGender.values[map['gender'] as int]
        : null,
    savings: (map['savings'] as num?)?.toDouble() ?? 0.0,
    savingsGoal: (map['savingsGoal'] as num?)?.toDouble() ?? 10000.0,
    savingsGoalUnknown: map['savingsGoalUnknown'] as bool? ?? false,
    checking: (map['checking'] as num?)?.toDouble() ?? 0.0,
    investmentsUnknown: map['investmentsUnknown'] as bool? ?? false,
    debts:
        (map['debts'] as List<dynamic>?)
            ?.map((d) => DebtEntry.fromMap(d as Map<String, dynamic>))
            .toList() ??
        [],
    hasRothIra: map['hasRothIra'] as bool? ?? false,
    rothIraBalance: (map['rothIraBalance'] as num?)?.toDouble() ?? 0.0,
    has401k: map['has401k'] as bool? ?? false,
    balance401k: (map['balance401k'] as num?)?.toDouble() ?? 0.0,
    hasBrokerage: map['hasBrokerage'] as bool? ?? false,
    brokerageBalance: (map['brokerageBalance'] as num?)?.toDouble() ?? 0.0,
    annualSalary: (map['annualSalary'] as num?)?.toDouble() ?? 0.0,
    creditScoreStatus: map['creditScoreStatus'] as String?,
    hasMinted: map['hasMinted'] as bool? ?? false,
  );

  UserStats copyWith({
    Object? name = _sentinel,
    CharacterClass? characterClass,
    Object? gender = _sentinel,
    double? savings,
    double? savingsGoal,
    bool? savingsGoalUnknown,
    double? checking,
    bool? investmentsUnknown,
    List<DebtEntry>? debts,
    bool? hasRothIra,
    double? rothIraBalance,
    bool? has401k,
    double? balance401k,
    bool? hasBrokerage,
    double? brokerageBalance,
    double? annualSalary,
    Object? creditScoreStatus = _sentinel,
    bool? hasMinted,
  }) => UserStats(
    name: name == _sentinel ? this.name : name as String?,
    characterClass: characterClass ?? this.characterClass,
    gender: gender == _sentinel ? this.gender : gender as CharacterGender?,
    savings: savings ?? this.savings,
    savingsGoal: savingsGoal ?? this.savingsGoal,
    savingsGoalUnknown: savingsGoalUnknown ?? this.savingsGoalUnknown,
    checking: checking ?? this.checking,
    investmentsUnknown: investmentsUnknown ?? this.investmentsUnknown,
    debts: debts ?? this.debts,
    hasRothIra: hasRothIra ?? this.hasRothIra,
    rothIraBalance: rothIraBalance ?? this.rothIraBalance,
    has401k: has401k ?? this.has401k,
    balance401k: balance401k ?? this.balance401k,
    hasBrokerage: hasBrokerage ?? this.hasBrokerage,
    brokerageBalance: brokerageBalance ?? this.brokerageBalance,
    annualSalary: annualSalary ?? this.annualSalary,
    creditScoreStatus: creditScoreStatus == _sentinel
        ? this.creditScoreStatus
        : creditScoreStatus as String?,
    hasMinted: hasMinted ?? this.hasMinted,
  );
}

// Sentinel used so copyWith can explicitly set nullable fields to null
const _sentinel = Object();
