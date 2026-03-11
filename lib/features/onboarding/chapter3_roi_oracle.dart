import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme.dart';
import '../../app/router.dart';
import '../../providers/user_stats_provider.dart';
import '../../widgets/shared/bento_card.dart';
import '../../widgets/shared/currency_text_field.dart';

class Chapter3RoiOracle extends ConsumerWidget {
  final VoidCallback onBack;
  const Chapter3RoiOracle({super.key, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(userStatsProvider);
    final hasSalary = stats.annualSalary > 0;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      children: [
        Text('The ROI Oracle.', style: Theme.of(context).textTheme.displaySmall)
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
          'Tell the Oracle what you\'re worth. It will decide your fate.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ).animate().fadeIn(duration: 300.ms, delay: 80.ms),

        const SizedBox(height: 24),

        BentoCard(
          child: CurrencyTextField(
            label: 'Projected Annual Salary (or Current)',
            initialValue: stats.annualSalary,
            onChanged: (v) =>
                ref.read(userStatsProvider.notifier).setAnnualSalary(v),
          ),
        ).animate().fadeIn(duration: 300.ms, delay: 120.ms),

        const SizedBox(height: 20),

        // ── Combat Summary Card ───────────────────────────────────
        if (hasSalary)
          _CombatSummaryCard(
                characterClass: stats.characterClass?.displayName ?? 'Hero',
                monthlySalary: stats.monthlySalary,
                totalDebt: stats.totalDebt,
                monthsToDebtFree: stats.monthsToDebtFree,
                debtToIncomeRatio: stats.debtToIncomeRatio,
              )
              .animate()
              .fadeIn(duration: 500.ms, delay: 100.ms)
              .slideY(
                begin: 0.4,
                end: 0,
                duration: 500.ms,
                curve: Curves.easeOutCubic,
              )
        else
          _OraclePlaceholder().animate().fadeIn(
            duration: 400.ms,
            delay: 100.ms,
          ),

        const SizedBox(height: 28),

        // ── Mint Button ───────────────────────────────────────────
        SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  await HapticFeedback.heavyImpact();
                  await ref.read(userStatsProvider.notifier).mint();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRouter.dashboard,
                    );
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.success,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('⚡', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 10),
                    Text(
                      'MINT CHARACTER',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 400.ms, delay: 200.ms)
            .scale(
              begin: const Offset(0.95, 0.95),
              end: const Offset(1.0, 1.0),
              duration: 400.ms,
              delay: 200.ms,
              curve: Curves.easeOutBack,
            ),

        const SizedBox(height: 10),
        Text(
          'You can edit your stats anytime from the dashboard.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
        ).animate().fadeIn(duration: 300.ms, delay: 300.ms),

        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded, size: 16),
          label: const Text('Back'),
          style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
        ).animate().fadeIn(duration: 300.ms, delay: 350.ms),
      ],
    );
  }
}

class _CombatSummaryCard extends StatelessWidget {
  final String characterClass;
  final double monthlySalary;
  final double totalDebt;
  final int monthsToDebtFree;
  final double debtToIncomeRatio;

  const _CombatSummaryCard({
    required this.characterClass,
    required this.monthlySalary,
    required this.totalDebt,
    required this.monthsToDebtFree,
    required this.debtToIncomeRatio,
  });

  String get _verdict {
    if (totalDebt <= 0) {
      return '$characterClass is DEBT-FREE. Final form unlocked.';
    }
    if (debtToIncomeRatio < 0.15) {
      return '$characterClass deals CRITICAL DAMAGE. Shadow Exorcism in $monthsToDebtFree months.';
    }
    if (debtToIncomeRatio < 0.40) {
      return '$characterClass is holding the line. Shadow fades in $monthsToDebtFree months.';
    }
    return '$characterClass is outnumbered. Focus all resources — Shadow Exorcism in $monthsToDebtFree months.';
  }

  Color get _verdictColor {
    if (totalDebt <= 0) return AppColors.success;
    if (debtToIncomeRatio < 0.15) return AppColors.success;
    if (debtToIncomeRatio < 0.40) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    return BentoCard(
      borderColor: _verdictColor.withValues(alpha: 0.3),
      backgroundColor: _verdictColor.withValues(alpha: 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('⚔️', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text(
                'COMBAT SUMMARY',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          _StatRow(
            label: 'Attack Power',
            value: '\$${monthlySalary.toStringAsFixed(0)}/mo',
            icon: '⚡',
            valueColor: AppColors.success,
          ),
          const SizedBox(height: 12),
          _StatRow(
            label: 'Shadow HP',
            value: totalDebt > 0
                ? '\$${totalDebt.toStringAsFixed(0)}'
                : 'No Shadow',
            icon: '👻',
            valueColor: totalDebt > 0 ? AppColors.warning : AppColors.textMuted,
          ),
          const SizedBox(height: 12),
          _StatRow(
            label: 'Debt-to-Income',
            value: '${(debtToIncomeRatio * 100).toStringAsFixed(0)}%',
            icon: '📊',
            valueColor: debtToIncomeRatio > 0.3
                ? AppColors.danger
                : AppColors.textPrimary,
          ),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _verdictColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _verdictColor.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Text(
                  totalDebt <= 0
                      ? '🏆'
                      : debtToIncomeRatio < 0.15
                      ? '💥'
                      : debtToIncomeRatio < 0.40
                      ? '⚠️'
                      : '🔴',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _verdict,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _verdictColor,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  final Color valueColor;

  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _OraclePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BentoCard(
      backgroundColor: AppColors.navy.withValues(alpha: 0.03),
      child: Column(
        children: [
          const Text('🔮', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 12),
          Text(
            'The Oracle awaits your salary.',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Enter a number above to reveal your fate.',
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
