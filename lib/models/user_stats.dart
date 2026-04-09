import 'package:flutter/foundation.dart';
import 'mission.dart';
import 'debt_entry.dart';
import 'roadmap_step.dart';

enum CharacterGender { male, female }

enum IraType {
  roth,
  traditional;

  String get label {
    switch (this) {
      case IraType.roth:
        return 'Roth IRA';
      case IraType.traditional:
        return 'Traditional IRA';
    }
  }
}

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
        return 'Career';
    }
  }

  String get tagline {
    switch (this) {
      case student:
        return 'Learning the basics';
      case graduate:
        return 'Starting the next chapter';
      case professional:
        return 'Building momentum';
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
  final IraType? iraType;
  final bool has401k;
  final double balance401k;
  final bool hasHsa;
  final double hsaBalance;
  final bool hasBrokerage;
  final double brokerageBalance;
  final double annualSalary;
  final String? creditScoreStatus;
  final bool hasMinted;
  final List<String> completedRoadmapStepIds;

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
    this.iraType,
    this.has401k = false,
    this.balance401k = 0.0,
    this.hasHsa = false,
    this.hsaBalance = 0.0,
    this.hasBrokerage = false,
    this.brokerageBalance = 0.0,
    this.annualSalary = 0.0,
    this.creditScoreStatus,
    this.hasMinted = false,
    this.completedRoadmapStepIds = const [],
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

  bool get anyInvestmentActive =>
      hasRothIra || has401k || hasHsa || hasBrokerage;

  double get totalInvestments =>
      rothIraBalance + balance401k + hsaBalance + brokerageBalance;

  List<RoadmapStep> get roadmapSteps => _buildRoadmapSteps();

  List<RoadmapStep> get activeRoadmapSteps => roadmapSteps
      .where((step) => !completedRoadmapStepIds.contains(step.id))
      .toList();

  int get completedRoadmapStepsCount {
    final validIds = roadmapSteps.map((step) => step.id).toSet();
    return completedRoadmapStepIds.where(validIds.contains).length;
  }

  bool canCompleteRoadmapStep(String stepId) {
    switch (stepId) {
      case 'starter_buffer':
        return checking >= 500;
      case 'seal_vault':
        return vaultSealed;
      case 'dispel_shadow':
        return totalDebt <= 0;
      case 'credit_shield':
        return creditScoreStatus != null;
      case 'career_roi':
        return true;
      case 'time_machine':
        return anyInvestmentActive && totalInvestments > 0;
      case 'invest_401k_match':
        return has401k && balance401k > 0;
      case 'invest_hsa':
        return hasHsa && hsaBalance > 0;
      case 'invest_ira':
        return hasRothIra && rothIraBalance > 0;
      case 'invest_401k_more':
        return has401k && balance401k > 0;
      case 'invest_brokerage':
        return hasBrokerage && brokerageBalance > 0;
      case 'automate_investing':
        return anyInvestmentActive && totalInvestments >= 1000;
      case 'maintain_momentum':
        return true;
      default:
        return true;
    }
  }

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
          title: 'Build your emergency fund',
          subtitle:
              'Build a \$${savingsGoal.toStringAsFixed(0)} emergency fund so surprise costs do not derail you.',
          priority: MissionPriority.high,
        ),
      );
    }

    if (vaultSealed && totalDebt > 0) {
      missions.add(
        const Mission(
          id: 'dispel_shadow',
          title: 'Reduce debt',
          subtitle:
              'Pay down your balances and keep track of each debt clearly.',
          priority: MissionPriority.medium,
        ),
      );
    }

    if (vaultSealed && creditScoreStatus == null) {
      missions.add(
        const Mission(
          id: 'credit_shield',
          title: 'Start credit tracking',
          subtitle:
              'Keep an eye on your credit so you understand what lenders see.',
          priority: MissionPriority.utility,
        ),
      );
    }

    if (vaultSealed && totalDebt <= 0 && creditScoreStatus != null) {
      missions.add(
        const Mission(
          id: 'time_machine',
          title: 'Start investing',
          subtitle:
              'Open or fund retirement accounts so your money can grow over time.',
          priority: MissionPriority.endgame,
        ),
      );
    }

    if (missions.isEmpty) {
      missions.add(
        Mission(
          id: 'seal_vault',
          title: 'Build your emergency fund',
          subtitle:
              'Build a \$${savingsGoal.toStringAsFixed(0)} emergency fund so surprise costs do not derail you.',
          priority: MissionPriority.high,
        ),
      );
    }

    return missions;
  }

  List<RoadmapStep> _buildRoadmapSteps() {
    final steps = <RoadmapStep>[];

    if (checking < 500) {
      steps.add(
        const RoadmapStep(
          id: 'starter_buffer',
          title: 'Build a starter buffer',
          summary:
              'Keep a small cash cushion so surprise expenses do not force debt.',
          whyItMatters:
              'A starter buffer buys you breathing room while you build your bigger emergency fund.',
          actionLabel: 'Set a \$500 cash target',
          resourceHint:
              'Use your checking account as a holding zone, not spending fuel.',
          priority: MissionPriority.high,
        ),
      );
    }

    if (!vaultSealed) {
      steps.add(
        RoadmapStep(
          id: 'seal_vault',
          title: 'Build your emergency fund',
          summary:
              'Grow your emergency fund until it reaches the goal you picked.',
          whyItMatters:
              'Emergency savings keep one bad week from becoming a long debt cycle.',
          actionLabel: 'Hit your savings goal',
          resourceHint:
              'Start with automatic transfers from checking into savings every payday.',
          priority: MissionPriority.high,
        ),
      );
    }

    if (totalDebt > 0) {
      steps.add(
        const RoadmapStep(
          id: 'dispel_shadow',
          title: 'Reduce debt',
          summary: 'Attack debt with a simple payoff plan.',
          whyItMatters:
              'Debt drains future choices, especially for teens and young adults just getting started.',
          actionLabel: 'List every debt and its APR',
          resourceHint:
              'Small balances still matter; the goal is to stop the debt spiral early.',
          priority: MissionPriority.medium,
        ),
      );
    }

    if (creditScoreStatus == null) {
      steps.add(
        const RoadmapStep(
          id: 'credit_shield',
          title: 'Track credit',
          summary:
              'Start watching your credit so lenders see a reliable profile.',
          whyItMatters:
              'Credit history affects rentals, loans, and car financing before people expect it to.',
          actionLabel: 'Open a credit monitoring habit',
          resourceHint:
              'Even if you do not have a card yet, learn the basics before you need credit.',
          priority: MissionPriority.utility,
        ),
      );
    }

    if (characterClass == CharacterClass.student && annualSalary <= 0) {
      steps.add(
        const RoadmapStep(
          id: 'career_roi',
          title: 'Map career ROI',
          summary:
              'Pick a major, internship path, or skill stack that grows earning power.',
          whyItMatters:
              'For students, your biggest financial lever is often the first high-value job you get.',
          actionLabel: 'Choose a career direction',
          resourceHint:
              'Use internships, portfolio work, and salary research to compare options.',
          priority: MissionPriority.utility,
        ),
      );
    }

    if (vaultSealed && totalDebt <= 0 && !anyInvestmentActive) {
      steps.add(
        const RoadmapStep(
          id: 'time_machine',
          title: 'Start investing',
          summary:
              'Open your first retirement account and invest for the long run.',
          whyItMatters:
              'When savings and debt are handled, investing is how money starts working for you.',
          actionLabel: 'Open your first investing account',
          resourceHint:
              'For young adults, this is usually the point where compound growth becomes the main story.',
          priority: MissionPriority.endgame,
        ),
      );
    }

    if (anyInvestmentActive) {
      if (has401k) {
        steps.add(
          RoadmapStep(
            id: 'invest_401k_match',
            title: 'Priority 1: Capture your 401(k)/403(b) match',
            summary: balance401k > 0
                ? 'Confirm you are contributing enough to get the full employer match.'
                : 'Start contributing to your workplace plan, especially if a match is offered.',
            whyItMatters:
                'Employer match is usually the highest-return first step because it boosts your contribution immediately.',
            actionLabel: balance401k > 0
                ? 'Check your match threshold and contribution rate'
                : 'Enroll and set your first contribution rate',
            resourceHint:
                'Traditional 401(k) lowers taxable income now; Roth 401(k) gives tax-free qualified withdrawals later.',
            priority: MissionPriority.endgame,
          ),
        );
      }

      if (hasHsa) {
        steps.add(
          RoadmapStep(
            id: 'invest_hsa',
            title: 'Priority 2: Build your HSA contribution habit',
            summary: hsaBalance > 0
                ? 'Keep HSA contributions steady if the account fits your medical strategy.'
                : 'Start your first HSA contribution and keep it consistent.',
            whyItMatters:
                'HSAs can be highly tax-efficient and can support both current and future medical costs.',
            actionLabel: hsaBalance > 0
                ? 'Set or confirm recurring HSA contributions'
                : 'Fund your HSA for the first time',
            resourceHint:
                'HSA eligibility depends on your health plan type; confirm eligibility before increasing contributions.',
            priority: MissionPriority.endgame,
          ),
        );
      }

      if (hasRothIra) {
        final iraLabel = (iraType ?? IraType.roth).label;
        steps.add(
          RoadmapStep(
            id: 'invest_ira',
            title: 'Priority 3: Build your IRA contribution rhythm',
            summary: rothIraBalance > 0
                ? 'Keep IRA contributions steady and aligned with your plan.'
                : 'Make your first IRA contribution and start your investing rhythm.',
            whyItMatters:
              iraType == IraType.traditional
              ? 'Traditional IRA contributions may reduce taxable income now, with taxable withdrawals later.'
              : 'Roth IRA contributions use after-tax dollars and qualified withdrawals are tax-free later.',
            actionLabel: rothIraBalance > 0
                ? 'Schedule recurring IRA deposits'
              : 'Fund your $iraLabel for the first time',
            resourceHint:
                'Know annual contribution limits and income eligibility so your plan stays compliant.',
            priority: MissionPriority.endgame,
          ),
        );
      }

      if (has401k) {
        steps.add(
          RoadmapStep(
            id: 'invest_401k_more',
            title: 'Priority 4: Increase 401(k)/403(b) contributions over time',
            summary: balance401k > 0
                ? 'After capturing match, raise your contribution rate gradually.'
                : 'Once your first contribution is live, plan your next increase.',
            whyItMatters:
                'Small increases after raises can meaningfully improve long-term outcomes without major budget shock.',
            actionLabel: 'Set your next contribution increase checkpoint',
            resourceHint:
                'Traditional and Roth 401(k) both can be rolled over when changing jobs, but tax treatment differs.',
            priority: MissionPriority.endgame,
          ),
        );
      }

      if (hasBrokerage) {
        steps.add(
          RoadmapStep(
            id: 'invest_brokerage',
            title: 'Priority 5: Fund brokerage after tax-advantaged accounts',
            summary: brokerageBalance > 0
                ? 'Keep brokerage contributions predictable and goal-based.'
                : 'Start brokerage contributions after your higher-priority accounts are on track.',
            whyItMatters:
                'Brokerage accounts are flexible and useful, but usually come after match and tax-advantaged contribution priorities.',
            actionLabel: brokerageBalance > 0
                ? 'Set a recurring brokerage transfer'
                : 'Fund your brokerage account',
            resourceHint:
                'Keep your investment approach simple and avoid frequent strategy switches.',
            priority: MissionPriority.endgame,
          ),
        );
      }
    }

    if (steps.isEmpty) {
      steps.add(
        const RoadmapStep(
          id: 'maintain_momentum',
          title: 'Maintain momentum',
          summary: 'You are in a strong position. Keep your plan running.',
          whyItMatters:
              'At this stage, the best move is usually consistency instead of big changes.',
          actionLabel: 'Review your plan monthly',
          resourceHint:
              'Keep checking savings, debt, and investments so you do not drift backward.',
          priority: MissionPriority.utility,
        ),
      );
    }

    return steps;
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
    'iraType': iraType?.name,
    'has401k': has401k,
    'balance401k': balance401k,
    'hasHsa': hasHsa,
    'hsaBalance': hsaBalance,
    'hasBrokerage': hasBrokerage,
    'brokerageBalance': brokerageBalance,
    'annualSalary': annualSalary,
    'creditScoreStatus': creditScoreStatus,
    'hasMinted': hasMinted,
    'completedRoadmapStepIds': completedRoadmapStepIds,
  };

  factory UserStats.fromMap(Map<String, dynamic> map) {
    final hasIra = map['hasRothIra'] as bool? ?? false;
    final iraTypeRaw = map['iraType'] as String?;

    IraType? parsedIraType;
    if (iraTypeRaw != null) {
      for (final type in IraType.values) {
        if (type.name == iraTypeRaw) {
          parsedIraType = type;
          break;
        }
      }
    }
    parsedIraType ??= hasIra ? IraType.roth : null;

    return UserStats(
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
      hasRothIra: hasIra,
      rothIraBalance: (map['rothIraBalance'] as num?)?.toDouble() ?? 0.0,
      iraType: parsedIraType,
      has401k: map['has401k'] as bool? ?? false,
      balance401k: (map['balance401k'] as num?)?.toDouble() ?? 0.0,
      hasHsa: map['hasHsa'] as bool? ?? false,
      hsaBalance: (map['hsaBalance'] as num?)?.toDouble() ?? 0.0,
      hasBrokerage: map['hasBrokerage'] as bool? ?? false,
      brokerageBalance: (map['brokerageBalance'] as num?)?.toDouble() ?? 0.0,
      annualSalary: (map['annualSalary'] as num?)?.toDouble() ?? 0.0,
      creditScoreStatus: map['creditScoreStatus'] as String?,
      hasMinted: map['hasMinted'] as bool? ?? false,
      completedRoadmapStepIds:
          (map['completedRoadmapStepIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

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
    Object? iraType = _sentinel,
    bool? has401k,
    double? balance401k,
    bool? hasHsa,
    double? hsaBalance,
    bool? hasBrokerage,
    double? brokerageBalance,
    double? annualSalary,
    Object? creditScoreStatus = _sentinel,
    bool? hasMinted,
    List<String>? completedRoadmapStepIds,
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
    iraType: iraType == _sentinel ? this.iraType : iraType as IraType?,
    has401k: has401k ?? this.has401k,
    balance401k: balance401k ?? this.balance401k,
    hasHsa: hasHsa ?? this.hasHsa,
    hsaBalance: hsaBalance ?? this.hsaBalance,
    hasBrokerage: hasBrokerage ?? this.hasBrokerage,
    brokerageBalance: brokerageBalance ?? this.brokerageBalance,
    annualSalary: annualSalary ?? this.annualSalary,
    creditScoreStatus: creditScoreStatus == _sentinel
        ? this.creditScoreStatus
        : creditScoreStatus as String?,
    hasMinted: hasMinted ?? this.hasMinted,
    completedRoadmapStepIds:
        completedRoadmapStepIds ?? this.completedRoadmapStepIds,
  );
}

// Sentinel used so copyWith can explicitly set nullable fields to null
const _sentinel = Object();
