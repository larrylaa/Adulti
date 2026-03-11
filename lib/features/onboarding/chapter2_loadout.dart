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
  bool _hasTriggeredVaultHaptic = false;

  void _focusStage(StageFocus? focus) {
    ref.read(stageFocusProvider.notifier).state = focus;
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(userStatsProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      children: [
        // Header
        Text('Load your gear.', style: Theme.of(context).textTheme.displaySmall)
            .animate()
            .fadeIn(duration: 300.ms)
            .slideY(
              begin: 0.3,
              end: 0,
              duration: 300.ms,
              curve: Curves.easeOutCubic,
            ),

        const SizedBox(height: 4),
        Text(
          'Enter your real numbers — the stage updates in real time.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ).animate().fadeIn(duration: 300.ms, delay: 80.ms),

        const SizedBox(height: 20),

        // ── 1. THE VAULT (Savings) ────────────────────────────────
        _SectionLabel(
          icon: '🔒',
          label: 'THE VAULT',
          subtitle: 'Emergency Fund',
        ).animate().fadeIn(duration: 300.ms, delay: 120.ms),
        const SizedBox(height: 10),
        BentoCard(
          borderColor: stats.savings >= 1000
              ? AppColors.success.withValues(alpha: 0.4)
              : AppColors.border.withValues(alpha: 0.15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Focus(
                onFocusChange: (hasFocus) {
                  if (hasFocus) _focusStage(StageFocus.vault);
                },
                child: CurrencyTextField(
                  label: 'Savings Balance',
                  initialValue: stats.savings,
                  onChanged: (v) async {
                    await ref.read(userStatsProvider.notifier).setSavings(v);
                    if (v >= 1000 && !_hasTriggeredVaultHaptic) {
                      _hasTriggeredVaultHaptic = true;
                      HapticFeedback.mediumImpact();
                    }
                    if (v < 1000) _hasTriggeredVaultHaptic = false;
                  },
                ),
              ),
              const SizedBox(height: 16),
              AppProgressBar(
                progress: stats.vaultProgress,
                label: 'Emergency Fund Milestone',
                valueLabel: '\$1,000',
                height: 8,
              ),
              if (stats.savings >= 1000)
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
                        'Vault Sealed ⚡',
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
        ).animate().fadeIn(duration: 300.ms, delay: 160.ms),

        const SizedBox(height: 18),

        // ── 2. THE DESK (Checking) ────────────────────────────────
        _SectionLabel(
          icon: '💵',
          label: 'THE DESK',
          subtitle: 'Operating Funds',
        ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
        const SizedBox(height: 10),
        BentoCard(
          child: Focus(
            onFocusChange: (hasFocus) {
              if (hasFocus) _focusStage(StageFocus.desk);
            },
            child: CurrencyTextField(
              label: 'Operating Funds (Checking)',
              initialValue: stats.checking,
              onChanged: (v) =>
                  ref.read(userStatsProvider.notifier).setChecking(v),
            ),
          ),
        ).animate().fadeIn(duration: 300.ms, delay: 240.ms),

        const SizedBox(height: 18),

        // ── 3. THE DEBT SHADOW (Liabilities) ─────────────────────
        _SectionLabel(
          icon: '👻',
          label: 'THE SHADOW',
          subtitle: 'Liabilities',
        ).animate().fadeIn(duration: 300.ms, delay: 280.ms),
        const SizedBox(height: 10),
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
                    if (hasFocus) _focusStage(StageFocus.shadow);
                  },
                  child: DebtListEntry(
                    entry: debt,
                    onChanged: (updated) => ref
                        .read(userStatsProvider.notifier)
                        .updateDebt(updated),
                    onDelete: () => ref
                        .read(userStatsProvider.notifier)
                        .removeDebt(debt.id),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _focusStage(StageFocus.shadow);
                  ref
                      .read(userStatsProvider.notifier)
                      .addDebt(
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
                    Icon(
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
        ).animate().fadeIn(duration: 300.ms, delay: 320.ms),

        const SizedBox(height: 18),

        // ── 4. THE TIME MACHINE (Investments) ────────────────────
        _SectionLabel(
          icon: '⌚',
          label: 'THE TIME MACHINE',
          subtitle: 'Active Investments',
        ).animate().fadeIn(duration: 300.ms, delay: 360.ms),
        const SizedBox(height: 10),
        BentoCard(
          borderColor: stats.anyInvestmentActive
              ? AppColors.shadowBlue.withValues(alpha: 0.3)
              : AppColors.border.withValues(alpha: 0.15),
          child: Column(
            children: [
              _InvestmentToggle(
                label: 'Roth IRA',
                icon: '📈',
                value: stats.hasRothIra,
                onChanged: (v) {
                  _focusStage(StageFocus.watch);
                  ref.read(userStatsProvider.notifier).setHasRothIra(v);
                },
              ),
              const Divider(height: 20),
              _InvestmentToggle(
                label: '401(k)',
                icon: '🏦',
                value: stats.has401k,
                onChanged: (v) {
                  _focusStage(StageFocus.watch);
                  ref.read(userStatsProvider.notifier).setHas401k(v);
                },
              ),
              const Divider(height: 20),
              _InvestmentToggle(
                label: 'Brokerage Account',
                icon: '💹',
                value: stats.hasBrokerage,
                onChanged: (v) {
                  _focusStage(StageFocus.watch);
                  ref.read(userStatsProvider.notifier).setHasBrokerage(v);
                },
              ),
            ],
          ),
        ).animate().fadeIn(duration: 300.ms, delay: 400.ms),

        const SizedBox(height: 28),

        // Navigation row
        Row(
          children: [
            OutlinedButton(
              onPressed: widget.onBack,
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
                onPressed: () {
                  _focusStage(null);
                  widget.onNext();
                },
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
                      'VIEW BATTLE STATS',
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
        ).animate().fadeIn(duration: 300.ms, delay: 440.ms),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String icon;
  final String label;
  final String subtitle;

  const _SectionLabel({
    required this.icon,
    required this.label,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '/ $subtitle',
          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _InvestmentToggle extends StatelessWidget {
  final String label;
  final String icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _InvestmentToggle({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.shadowBlue,
          activeTrackColor: AppColors.shadowBlue.withValues(alpha: 0.2),
        ),
      ],
    );
  }
}
