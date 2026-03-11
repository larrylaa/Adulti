import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme.dart';
import '../../app/router.dart';
import '../../providers/user_stats_provider.dart';
import '../../widgets/tactical_stage/tactical_stage.dart';
import '../../widgets/shared/mission_card.dart';
import '../../widgets/shared/bento_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(userStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            Navigator.pushReplacementNamed(context, AppRouter.onboarding),
        backgroundColor: AppColors.navy,
        icon: const Icon(Icons.edit_rounded, color: Colors.white, size: 18),
        label: Text(
          'Edit Stats',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        elevation: 2,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top 40%: Tactical Stage ──────────────────────────
            Expanded(
              flex: 2,
              child: ClipRect(
                child: Stack(
                  children: [
                    const TacticalStage(),
                    // Top bar with name + class
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

            // ── Bottom 60%: Mission Console ──────────────────────
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                              'Priority Queue',
                              style: Theme.of(context).textTheme.headlineMedium,
                            )
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.2, end: 0, duration: 400.ms),
                        const SizedBox(height: 4),
                        Text(
                          'Your active missions, ranked by impact.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ).animate().fadeIn(duration: 400.ms, delay: 80.ms),
                        const SizedBox(height: 16),

                        // ── Quick Stats Strip ─────────────────────
                        _QuickStatsStrip(
                          savings: stats.savings,
                          checking: stats.checking,
                          totalDebt: stats.totalDebt,
                        ).animate().fadeIn(duration: 400.ms, delay: 120.ms),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // Mission Cards List
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      itemCount: stats.priorityMissions.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, i) => MissionCard(
                        mission: stats.priorityMissions[i],
                        animationDelay: 180 + i * 80,
                      ),
                    ),
                  ),
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
            characterClass != null ? '🎮 ${characterClass!}' : '🎮 Hero',
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

class _QuickStatsStrip extends StatelessWidget {
  final double savings;
  final double checking;
  final double totalDebt;

  const _QuickStatsStrip({
    required this.savings,
    required this.checking,
    required this.totalDebt,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MiniStatCard(
          label: 'Vault',
          value: _fmt(savings),
          color: AppColors.success,
          icon: '🔒',
        ),
        const SizedBox(width: 8),
        _MiniStatCard(
          label: 'Operating',
          value: _fmt(checking),
          color: AppColors.navy,
          icon: '💵',
        ),
        const SizedBox(width: 8),
        _MiniStatCard(
          label: 'Shadow',
          value: totalDebt > 0 ? _fmt(totalDebt) : 'None',
          color: totalDebt > 0 ? AppColors.warning : AppColors.textMuted,
          icon: '👻',
        ),
      ],
    );
  }

  String _fmt(double v) {
    if (v >= 1000000) return '\$${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '\$${(v / 1000).toStringAsFixed(1)}K';
    return '\$${v.toStringAsFixed(0)}';
  }
}

class _MiniStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final String icon;

  const _MiniStatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BentoCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        borderColor: color.withValues(alpha: 0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
