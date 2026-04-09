import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme.dart';
import '../../models/debt_entry.dart';
import '../../models/user_stats.dart';
import '../../providers/user_stats_provider.dart';
import '../../widgets/shared/bento_card.dart';
import '../../widgets/shared/currency_text_field.dart';
import '../../widgets/shared/debt_list_entry.dart';
import '../../widgets/tactical_stage/tactical_stage.dart';

class DashboardScreen extends ConsumerWidget {
  final VoidCallback onOpenRoadmap;

  const DashboardScreen({super.key, required this.onOpenRoadmap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(userStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: ClipRect(
                child: Stack(
                  children: [
                    const TacticalStage(),
                    Positioned(
                      top: 12,
                      left: 16,
                      right: 16,
                      child: _DashboardTopBar(
                        characterClass: stats.characterClass?.displayName,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(height: 1, color: AppColors.navy.withValues(alpha: 0.06)),
            Expanded(
              flex: 3,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                children: [
                  Text('Home', style: Theme.of(context).textTheme.displaySmall)
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.2, end: 0, duration: 400.ms),
                  const SizedBox(height: 4),
                  Text(
                    'A quick look at where you are right now.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 80.ms),
                  const SizedBox(height: 12),
                  _QuickFinanceRow(
                    first: _QuickFinanceCard(
                      label: 'Checking',
                      value: _formatCurrency(stats.checking),
                      subtitle: stats.checking > 500
                          ? 'Buffer looks healthy'
                          : 'Build your cash buffer',
                      icon: Icons.account_balance_wallet_rounded,
                      accent: AppColors.navy,
                      onTap: () => _openQuickSheet(
                        context,
                        _QuickFinanceSection.checking,
                      ),
                    ),
                    second: _QuickFinanceCard(
                      label: 'Savings',
                      value: _formatCurrency(stats.savings),
                      subtitle: 'Goal ${_formatCurrency(stats.savingsGoal)}',
                      icon: Icons.savings_rounded,
                      accent: AppColors.success,
                      onTap: () => _openQuickSheet(
                        context,
                        _QuickFinanceSection.savings,
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 120.ms),
                  const SizedBox(height: 10),
                  _QuickFinanceRow(
                    first: _QuickFinanceCard(
                      label: 'Debt',
                      value: stats.totalDebt > 0
                          ? _formatCurrency(stats.totalDebt)
                          : 'None',
                      subtitle: stats.totalDebt > 0
                          ? '${stats.debts.length} item${stats.debts.length == 1 ? '' : 's'}'
                          : 'No balances recorded',
                      icon: Icons.trending_down_rounded,
                      accent: stats.totalDebt > 0
                          ? AppColors.warning
                          : AppColors.textMuted,
                      onTap: () =>
                          _openQuickSheet(context, _QuickFinanceSection.debt),
                    ),
                    second: _QuickFinanceCard(
                      label: 'Investments',
                      value: stats.totalInvestments > 0
                          ? _formatCurrency(stats.totalInvestments)
                          : 'None',
                      subtitle: stats.anyInvestmentActive
                          ? 'IRA, 401(k), HSA, or brokerage'
                          : 'Set up retirement next',
                      icon: Icons.show_chart_rounded,
                      accent: AppColors.navyLight,
                      onTap: () => _openQuickSheet(
                        context,
                        _QuickFinanceSection.investments,
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 120.ms),
                  const SizedBox(height: 14),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onOpenRoadmap,
                      borderRadius: BorderRadius.circular(16),
                      child: BentoCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Your next step',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.route_rounded,
                                  color: AppColors.navy,
                                  size: 18,
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Tap to open Roadmap.',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                height: 1.45,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (stats.activeRoadmapSteps.isEmpty)
                              Text(
                                'You are all caught up for now.',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  height: 1.5,
                                  color: AppColors.textSecondary,
                                ),
                              )
                            else
                              Column(
                                children: stats.activeRoadmapSteps
                                    .take(2)
                                    .map(
                                      (step) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: _RoadmapStepRow(
                                          title: step.title,
                                          actionLabel: step.actionLabel,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: 160.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardTopBar extends StatelessWidget {
  final String? characterClass;

  const _DashboardTopBar({this.characterClass});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.06),
                blurRadius: 4,
              ),
            ],
          ),
          child: Text(
            characterClass != null ? characterClass! : 'Hero',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.circle, size: 6, color: AppColors.success),
              const SizedBox(width: 5),
              Text(
                'ACTIVE',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum _QuickFinanceSection { checking, savings, debt, investments }

void _openQuickSheet(BuildContext context, _QuickFinanceSection section) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _FinanceQuickSheet(section: section),
  );
}

class _QuickFinanceCard extends StatelessWidget {
  static const double _cardHeight = 170;

  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  const _QuickFinanceCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: _cardHeight,
          child: BentoCard(
            borderColor: accent.withValues(alpha: 0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 18, color: accent),
                    const Spacer(),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  label,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: accent,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    height: 1.35,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickFinanceRow extends StatelessWidget {
  final Widget first;
  final Widget second;

  const _QuickFinanceRow({required this.first, required this.second});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: first),
        const SizedBox(width: 10),
        Expanded(child: second),
      ],
    );
  }
}

class _RoadmapStepRow extends StatelessWidget {
  final String title;
  final String actionLabel;

  const _RoadmapStepRow({required this.title, required this.actionLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.navy.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.navy.withValues(alpha: 0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            actionLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FinanceQuickSheet extends ConsumerWidget {
  final _QuickFinanceSection section;

  const _FinanceQuickSheet({required this.section});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(userStatsProvider);
    final notifier = ref.read(userStatsProvider.notifier);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + bottomInset),
        child: SingleChildScrollView(
          child: BentoCard(
            borderRadius: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _titleForSection(section),
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _subtitleForSection(section),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 18),
                _buildSection(stats, notifier),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Done'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(UserStats stats, UserStatsNotifier notifier) {
    switch (section) {
      case _QuickFinanceSection.checking:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CurrencyTextField(
              label: 'Checking balance',
              initialValue: stats.checking,
              autofocus: true,
              onChanged: notifier.setChecking,
            ),
            const SizedBox(height: 10),
            Text(
              'Use this for cash you can spend immediately.',
              style: GoogleFonts.inter(
                fontSize: 12,
                height: 1.45,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        );
      case _QuickFinanceSection.savings:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CurrencyTextField(
              label: 'Savings balance',
              initialValue: stats.savings,
              autofocus: true,
              onChanged: notifier.setSavings,
            ),
            const SizedBox(height: 12),
            CurrencyTextField(
              label: 'Savings goal',
              initialValue: stats.savingsGoal,
              onChanged: notifier.setSavingsGoal,
            ),
            const SizedBox(height: 10),
            Text(
              'The goal stays visible here so you can see progress quickly.',
              style: GoogleFonts.inter(
                fontSize: 12,
                height: 1.45,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        );
      case _QuickFinanceSection.debt:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stats.totalDebt > 0
                  ? 'Total debt: ${_formatCurrency(stats.totalDebt)}'
                  : 'No debt recorded yet.',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            if (stats.debts.isEmpty)
              Text(
                'Add a debt entry to track balances, labels, and payoff order.',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  height: 1.45,
                  color: AppColors.textSecondary,
                ),
              )
            else
              ...stats.debts.map(
                (debt) => DebtListEntry(
                  entry: debt,
                  onChanged: notifier.updateDebt,
                  onDelete: () => notifier.removeDebt(debt.id),
                ),
              ),
            TextButton.icon(
              onPressed: () => notifier.addDebt(
                DebtEntry(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  type: DebtType.creditCard,
                  label: '',
                  amount: 0,
                ),
              ),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add debt entry'),
            ),
          ],
        );
      case _QuickFinanceSection.investments:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('IRA'),
              value: stats.hasRothIra,
              onChanged: notifier.setHasRothIra,
            ),
            if (stats.hasRothIra) ...[
              DropdownButtonFormField<IraType>(
                initialValue: stats.iraType ?? IraType.roth,
                decoration: const InputDecoration(labelText: 'IRA type'),
                items: IraType.values
                    .map(
                      (type) => DropdownMenuItem<IraType>(
                        value: type,
                        child: Text(type.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    notifier.setIraType(value);
                  }
                },
              ),
              const SizedBox(height: 10),
              CurrencyTextField(
                label: 'IRA balance',
                initialValue: stats.rothIraBalance,
                onChanged: notifier.setRothIraBalance,
              ),
              const SizedBox(height: 12),
            ],
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('401(k)'),
              value: stats.has401k,
              onChanged: notifier.setHas401k,
            ),
            if (stats.has401k) ...[
              CurrencyTextField(
                label: '401(k) balance',
                initialValue: stats.balance401k,
                onChanged: notifier.set401kBalance,
              ),
              const SizedBox(height: 12),
            ],
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('HSA'),
              value: stats.hasHsa,
              onChanged: notifier.setHasHsa,
            ),
            if (stats.hasHsa) ...[
              CurrencyTextField(
                label: 'HSA balance',
                initialValue: stats.hsaBalance,
                onChanged: notifier.setHsaBalance,
              ),
              const SizedBox(height: 12),
            ],
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Brokerage account'),
              value: stats.hasBrokerage,
              onChanged: notifier.setHasBrokerage,
            ),
            if (stats.hasBrokerage) ...[
              CurrencyTextField(
                label: 'Brokerage balance',
                initialValue: stats.brokerageBalance,
                onChanged: notifier.setBrokerageBalance,
              ),
              const SizedBox(height: 12),
            ],
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('I do not know these yet'),
              value: stats.investmentsUnknown,
              onChanged: notifier.setInvestmentsUnknown,
            ),
            const SizedBox(height: 8),
            Text(
              'Mark what exists now; the roadmap will adapt as the balances grow.',
              style: GoogleFonts.inter(
                fontSize: 12,
                height: 1.45,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        );
    }
  }

  String _titleForSection(_QuickFinanceSection section) {
    switch (section) {
      case _QuickFinanceSection.checking:
        return 'Checking';
      case _QuickFinanceSection.savings:
        return 'Savings';
      case _QuickFinanceSection.debt:
        return 'Debt';
      case _QuickFinanceSection.investments:
        return 'Investments';
    }
  }

  String _subtitleForSection(_QuickFinanceSection section) {
    switch (section) {
      case _QuickFinanceSection.checking:
        return 'Update the cash you can use right away.';
      case _QuickFinanceSection.savings:
        return 'Keep the balance and target together.';
      case _QuickFinanceSection.debt:
        return 'Track balances, labels, and payoff order.';
      case _QuickFinanceSection.investments:
        return 'Turn on the accounts you already use and enter balances.';
    }
  }
}

String _formatCurrency(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts[0];
  final decimal = parts[1];

  final sign = whole.startsWith('-') ? '-' : '';
  final digits = sign.isEmpty ? whole : whole.substring(1);
  final buffer = StringBuffer();

  for (var i = 0; i < digits.length; i++) {
    final idxFromEnd = digits.length - i;
    buffer.write(digits[i]);
    if (idxFromEnd > 1 && idxFromEnd % 3 == 1) {
      buffer.write(',');
    }
  }

  return '\$$sign${buffer.toString()}.$decimal';
}
