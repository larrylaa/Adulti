import 'package:flutter/foundation.dart';
import 'mission.dart';
import 'debt_entry.dart';

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
        return 'Professional';
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
  final CharacterClass? characterClass;
  final double savings;
  final double checking;
  final List<DebtEntry> debts;
  final bool hasRothIra;
  final bool has401k;
  final bool hasBrokerage;
  final double annualSalary;
  final String? creditScoreStatus;
  final bool hasMinted;

  const UserStats({
    this.characterClass,
    this.savings = 0.0,
    this.checking = 0.0,
    this.debts = const [],
    this.hasRothIra = false,
    this.has401k = false,
    this.hasBrokerage = false,
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

  /// Fraction of the $1,000 emergency fund milestone (0.0–1.0)
  double get vaultProgress => (savings / 1000.0).clamp(0.0, 1.0);

  bool get anyInvestmentActive => hasRothIra || has401k || hasBrokerage;

  /// Months until debt is paid off at 20% of monthly salary
  int get monthsToDebtFree {
    if (totalDebt <= 0) return 0;
    final monthlyPayment = monthlySalary * 0.20;
    if (monthlyPayment <= 0) return 999;
    return (totalDebt / monthlyPayment).ceil();
  }

  List<Mission> get priorityMissions {
    final missions = <Mission>[];

    if (savings < 1000) {
      missions.add(
        const Mission(
          id: 'seal_vault',
          title: 'Seal the Vault',
          subtitle:
              'Build a \$1,000 emergency fund — your first line of defense.',
          priority: MissionPriority.high,
        ),
      );
    }

    if (savings >= 1000 && totalDebt > 0) {
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

    if (savings >= 1000 && creditScoreStatus == null) {
      missions.add(
        const Mission(
          id: 'credit_shield',
          title: 'Equip Credit Shield',
          subtitle: 'Track your credit score — invisibility is not a strategy.',
          priority: MissionPriority.utility,
        ),
      );
    }

    if (savings >= 1000 && totalDebt <= 0 && creditScoreStatus != null) {
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

    // Always show at least one mission
    if (missions.isEmpty) {
      missions.add(
        const Mission(
          id: 'seal_vault',
          title: 'Seal the Vault',
          subtitle:
              'Build a \$1,000 emergency fund — your first line of defense.',
          priority: MissionPriority.high,
        ),
      );
    }

    return missions;
  }

  // ── Serialization ────────────────────────────────────────────────────────

  Map<String, dynamic> toMap() => {
    'characterClass': characterClass?.index,
    'savings': savings,
    'checking': checking,
    'debts': debts.map((d) => d.toMap()).toList(),
    'hasRothIra': hasRothIra,
    'has401k': has401k,
    'hasBrokerage': hasBrokerage,
    'annualSalary': annualSalary,
    'creditScoreStatus': creditScoreStatus,
    'hasMinted': hasMinted,
  };

  factory UserStats.fromMap(Map<String, dynamic> map) => UserStats(
    characterClass: map['characterClass'] != null
        ? CharacterClass.values[map['characterClass'] as int]
        : null,
    savings: (map['savings'] as num?)?.toDouble() ?? 0.0,
    checking: (map['checking'] as num?)?.toDouble() ?? 0.0,
    debts:
        (map['debts'] as List<dynamic>?)
            ?.map((d) => DebtEntry.fromMap(d as Map<String, dynamic>))
            .toList() ??
        [],
    hasRothIra: map['hasRothIra'] as bool? ?? false,
    has401k: map['has401k'] as bool? ?? false,
    hasBrokerage: map['hasBrokerage'] as bool? ?? false,
    annualSalary: (map['annualSalary'] as num?)?.toDouble() ?? 0.0,
    creditScoreStatus: map['creditScoreStatus'] as String?,
    hasMinted: map['hasMinted'] as bool? ?? false,
  );

  UserStats copyWith({
    CharacterClass? characterClass,
    double? savings,
    double? checking,
    List<DebtEntry>? debts,
    bool? hasRothIra,
    bool? has401k,
    bool? hasBrokerage,
    double? annualSalary,
    Object? creditScoreStatus = _sentinel,
    bool? hasMinted,
  }) => UserStats(
    characterClass: characterClass ?? this.characterClass,
    savings: savings ?? this.savings,
    checking: checking ?? this.checking,
    debts: debts ?? this.debts,
    hasRothIra: hasRothIra ?? this.hasRothIra,
    has401k: has401k ?? this.has401k,
    hasBrokerage: hasBrokerage ?? this.hasBrokerage,
    annualSalary: annualSalary ?? this.annualSalary,
    creditScoreStatus: creditScoreStatus == _sentinel
        ? this.creditScoreStatus
        : creditScoreStatus as String?,
    hasMinted: hasMinted ?? this.hasMinted,
  );
}

// Sentinel used so copyWith can explicitly set nullable fields to null
const _sentinel = Object();
