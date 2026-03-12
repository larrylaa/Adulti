import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme.dart';
import '../../models/debt_entry.dart';
import '../../providers/user_stats_provider.dart';
import '../../providers/stage_focus_provider.dart';
import '../../widgets/shared/bento_card.dart';
import '../../widgets/shared/currency_text_field.dart';
import '../../widgets/shared/progress_bar.dart';
import '../../widgets/shared/debt_list_entry.dart';

class Chapter2Loadout extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Chapter2Loadout({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<Chapter2Loadout> createState() => _Chapter2LoadoutState();
}

class _Chapter2LoadoutState extends ConsumerState<Chapter2Loadout> {
  late final PageController _subPageController = PageController();
  int _subStep = 0;
  bool _hasTriggeredVaultHaptic = false;

  static const _subStepTitles = [
    'Operating Funds',
    'The Vault',
    'The Shadow',
    'The Time Machine',
  ];
  static const _subStepIcons = [
    '\u{1F4B5}',
    '\u{1F512}',
    '\u{1F47B}',
    '\u23F1',
  ];
  static const _subStepFocus = [
    StageFocus.desk,
    StageFocus.vault,
    StageFocus.shadow,
    StageFocus.watch,
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _focusStage(StageFocus.desk));
  }

  @override
  void deactivate() {
    // Clear focus when leaving this screen
    ref.read(stageFocusProvider.notifier).state = null;
    super.deactivate();
  }

  @override
  void dispose() {
    _subPageController.dispose();
    super.dispose();
  }

  void _focusStage(StageFocus? focus) {
    ref.read(stageFocusProvider.notifier).state = focus;
  }

  void _nextSubStep() {
    final next = _subStep + 1;
    if (next <= 3) {
      setState(() => _subStep = next);
      _focusStage(_subStepFocus[next]);
      _subPageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _focusStage(null);
      widget.onNext();
    }
  }

  void _prevSubStep() {
    if (_subStep > 0) {
      final prev = _subStep - 1;
      setState(() => _subStep = prev);
      _focusStage(_subStepFocus[prev]);
      _subPageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _focusStage(null);
      widget.onBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _subStep == 3;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(
                  4,
                  (i) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      width: i == _subStep ? 20 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: i <= _subStep
                            ? AppColors.navy
                            : AppColors.border.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                    'Load your gear.',
                    style: Theme.of(context).textTheme.displaySmall,
                  )
                  .animate(key: ValueKey('ch2-title-$_subStep'))
                  .fadeIn(duration: 250.ms)
                  .slideY(
                    begin: 0.2,
                    end: 0,
                    duration: 250.ms,
                    curve: Curves.easeOutCubic,
                  ),
              const SizedBox(height: 4),
              Text(
                    '${_subStepIcons[_subStep]}  ${_subStepTitles[_subStep]}',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                  .animate(key: ValueKey('ch2-sub-$_subStep'))
                  .fadeIn(duration: 250.ms, delay: 60.ms),
            ],
          ),
        ),
        Expanded(
          child: PageView(
            controller: _subPageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _SubStepDesk(onFocus: () => _focusStage(StageFocus.desk)),
              _SubStepVault(
                hasTriggeredHaptic: _hasTriggeredVaultHaptic,
                onHapticTriggered: () =>
                    setState(() => _hasTriggeredVaultHaptic = true),
                onHapticReset: () =>
                    setState(() => _hasTriggeredVaultHaptic = false),
                onFocus: () => _focusStage(StageFocus.vault),
              ),
              _SubStepShadow(onFocus: () => _focusStage(StageFocus.shadow)),
              _SubStepWatch(onFocus: () => _focusStage(StageFocus.watch)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Row(
            children: [
              OutlinedButton(
                onPressed: _prevSubStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  side: const BorderSide(color: AppColors.navy, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.navy,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _nextSubStep,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLast ? 'VIEW BATTLE STATS' : 'NEXT',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Sub-step 0: Operating Funds ────────────────────────────────────────────

class _SubStepDesk extends ConsumerWidget {
  final VoidCallback onFocus;

  const _SubStepDesk({required this.onFocus});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(userStatsProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      children: [
        BentoCard(
          child: Focus(
            onFocusChange: (hasFocus) {
              if (hasFocus) onFocus();
            },
            child: CurrencyTextField(
              label: 'Checking Account Balance',
              initialValue: stats.checking,
              onChanged: (v) =>
                  ref.read(userStatsProvider.notifier).setChecking(v),
            ),
          ),
        ).animate().fadeIn(duration: 300.ms, delay: 60.ms),
        const SizedBox(height: 16),
        Text(
          'This is your everyday spending money — bills, groceries, gas. The Desk on stage shows your cash flow. Keep 1-3 months of expenses here.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ).animate().fadeIn(duration: 300.ms, delay: 120.ms),
      ],
    );
  }
}

// ── Sub-step 1: The Vault ──────────────────────────────────────────────────

class _SubStepVault extends ConsumerWidget {
  final bool hasTriggeredHaptic;
  final VoidCallback onHapticTriggered;
  final VoidCallback onHapticReset;
  final VoidCallback onFocus;

  const _SubStepVault({
    required this.hasTriggeredHaptic,
    required this.onHapticTriggered,
    required this.onHapticReset,
    required this.onFocus,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(userStatsProvider);
    final notifier = ref.read(userStatsProvider.notifier);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      children: [
        BentoCard(
          borderColor: stats.vaultSealed
              ? AppColors.success.withValues(alpha: 0.4)
              : AppColors.border.withValues(alpha: 0.15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Focus(
                onFocusChange: (hasFocus) {
                  if (hasFocus) onFocus();
                },
                child: CurrencyTextField(
                  label: 'Savings Balance',
                  initialValue: stats.savings,
                  onChanged: (v) async {
                    await notifier.setSavings(v);
                    if (v >= stats.savingsGoal && !hasTriggeredHaptic) {
                      onHapticTriggered();
                      HapticFeedback.mediumImpact();
                    }
                    if (v < stats.savingsGoal) onHapticReset();
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(
                    value: stats.savingsGoalUnknown,
                    onChanged: (v) =>
                        notifier.setSavingsGoalUnknown(v ?? false),
                    activeColor: AppColors.shadowBlue,
                  ),
                  Expanded(
                    child: Text(
                      "I don't know my goal yet",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AnimatedOpacity(
                opacity: stats.savingsGoalUnknown ? 0.5 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: IgnorePointer(
                  ignoring: stats.savingsGoalUnknown,
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      if (hasFocus) onFocus();
                    },
                    child: CurrencyTextField(
                      label: 'Savings Goal',
                      initialValue: stats.savingsGoal,
                      onChanged: (v) => notifier.setSavingsGoal(v),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AppProgressBar(
                progress: stats.vaultProgress,
                label: 'Emergency Fund Milestone',
                valueLabel: _formatGoal(stats.savingsGoal),
                height: 8,
              ),
              if (stats.vaultSealed)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.success,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Vault Sealed',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8)),
                ),
            ],
          ),
        ).animate().fadeIn(duration: 300.ms, delay: 60.ms),
      ],
    );
  }

  String _formatGoal(double v) {
    if (v >= 1000) return '\$${(v / 1000).toStringAsFixed(0)}k';
    return '\$${v.toStringAsFixed(0)}';
  }
}

// ── Sub-step 2: The Shadow ─────────────────────────────────────────────────

class _SubStepShadow extends ConsumerWidget {
  final VoidCallback onFocus;

  const _SubStepShadow({required this.onFocus});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(userStatsProvider);
    final notifier = ref.read(userStatsProvider.notifier);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      children: [
        Text(
          'The Shadow is the ghost of your debt — credit cards, loans, anything you owe. It grows stronger the more you owe, haunting your finances until you pay it off.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ).animate().fadeIn(duration: 300.ms),
        const SizedBox(height: 12),
        BentoCard(
          borderColor: stats.totalDebt > 0
              ? AppColors.warning.withValues(alpha: 0.3)
              : AppColors.border.withValues(alpha: 0.15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...stats.debts.map(
                (debt) => Focus(
                  onFocusChange: (hasFocus) {
                    if (hasFocus) onFocus();
                  },
                  child: DebtListEntry(
                    entry: debt,
                    onChanged: (updated) => notifier.updateDebt(updated),
                    onDelete: () => notifier.removeDebt(debt.id),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onFocus();
                  notifier.addDebt(
                    DebtEntry(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      type: DebtType.creditCard,
                      label: '',
                      amount: 0,
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add_circle_outline_rounded,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Add debt entry',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (stats.totalDebt > 0) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Shadow Power',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '\$${stats.totalDebt.toStringAsFixed(2)}',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ).animate().fadeIn(duration: 300.ms, delay: 60.ms),
      ],
    );
  }
}

// ── Sub-step 3: The Time Machine ───────────────────────────────────────────

class _SubStepWatch extends ConsumerWidget {
  final VoidCallback onFocus;

  const _SubStepWatch({required this.onFocus});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(userStatsProvider);
    final notifier = ref.read(userStatsProvider.notifier);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      children: [
        Text(
          'The Time Machine represents your investments — retirement accounts and brokerage accounts that grow over time through compound interest.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Checkbox(
              value: stats.investmentsUnknown,
              onChanged: (v) => notifier.setInvestmentsUnknown(v ?? false),
              activeColor: AppColors.shadowBlue,
            ),
            Expanded(
              child: Text(
                "I don't know what these are yet",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        AnimatedOpacity(
          opacity: stats.investmentsUnknown ? 0.5 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: IgnorePointer(
            ignoring: stats.investmentsUnknown,
            child: BentoCard(
              borderColor: stats.anyInvestmentActive
                  ? AppColors.shadowBlue.withValues(alpha: 0.3)
                  : AppColors.border.withValues(alpha: 0.15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InvestmentRow(
                    icon: '\u{1F4C8}',
                    label: 'Roth IRA',
                    active: stats.hasRothIra,
                    balance: stats.rothIraBalance,
                    onToggle: (v) {
                      onFocus();
                      notifier.setHasRothIra(v);
                    },
                    onBalanceChanged: (v) => notifier.setRothIraBalance(v),
                  ),
                  const Divider(height: 20, indent: 4, endIndent: 4),
                  _InvestmentRow(
                    icon: '\u{1F3E6}',
                    label: '401(k)',
                    active: stats.has401k,
                    balance: stats.balance401k,
                    onToggle: (v) {
                      onFocus();
                      notifier.setHas401k(v);
                    },
                    onBalanceChanged: (v) => notifier.set401kBalance(v),
                  ),
                  const Divider(height: 20, indent: 4, endIndent: 4),
                  _InvestmentRow(
                    icon: '\u{1F4C9}',
                    label: 'Brokerage Account',
                    active: stats.hasBrokerage,
                    balance: stats.brokerageBalance,
                    onToggle: (v) {
                      onFocus();
                      notifier.setHasBrokerage(v);
                    },
                    onBalanceChanged: (v) => notifier.setBrokerageBalance(v),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 60.ms),
          ),
        ),
      ],
    );
  }
}

// ── Shared helpers ─────────────────────────────────────────────────────────

class _InvestmentRow extends StatelessWidget {
  final String icon;
  final String label;
  final bool active;
  final double balance;
  final ValueChanged<bool> onToggle;
  final ValueChanged<double> onBalanceChanged;

  const _InvestmentRow({
    required this.icon,
    required this.label,
    required this.active,
    required this.balance,
    required this.onToggle,
    required this.onBalanceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Switch(
              value: active,
              onChanged: onToggle,
              activeThumbColor: AppColors.shadowBlue,
              activeTrackColor: AppColors.shadowBlue.withValues(alpha: 0.2),
            ),
          ],
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: active
              ? Padding(
                  padding: const EdgeInsets.only(top: 8, left: 30),
                  child: CurrencyTextField(
                    label: 'Current Balance',
                    initialValue: balance,
                    onChanged: onBalanceChanged,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
