import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme.dart';
import '../../models/user_stats.dart';
import '../../providers/user_stats_provider.dart';
import '../../services/analytics_service.dart';
import '../../widgets/shared/bento_card.dart';
import '../../widgets/shared/roadmap_step_card.dart';
import '../guide/guide_content.dart';

class _FlowStage {
  final String title;
  final String subtitle;
  final IconData icon;
  final Set<String> stepIds;

  const _FlowStage({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.stepIds,
  });
}

const _genericRoadmapStages = <_FlowStage>[
  _FlowStage(
    title: 'Checking',
    subtitle: 'Create a stable starter cash buffer.',
    icon: Icons.account_balance_wallet_rounded,
    stepIds: {'starter_buffer'},
  ),
  _FlowStage(
    title: 'Debt',
    subtitle: 'Tackle debt balances and reduce interest drag.',
    icon: Icons.trending_down_rounded,
    stepIds: {'dispel_shadow'},
  ),
  _FlowStage(
    title: 'Savings',
    subtitle: 'Build emergency reserves for security.',
    icon: Icons.savings_rounded,
    stepIds: {'seal_vault'},
  ),
  _FlowStage(
    title: 'Credit',
    subtitle: 'Build score habits and protect access.',
    icon: Icons.verified_user_rounded,
    stepIds: {'credit_shield'},
  ),
  _FlowStage(
    title: 'Investing',
    subtitle: 'Start and grow long-term investing accounts.',
    icon: Icons.auto_graph_rounded,
    stepIds: {
      'time_machine',
      'invest_401k_match',
      'invest_hsa',
      'invest_ira',
      'invest_401k_more',
      'invest_brokerage',
      'automate_investing',
    },
  ),
  _FlowStage(
    title: 'Maintain',
    subtitle: 'Review monthly and keep momentum.',
    icon: Icons.insights_rounded,
    stepIds: {'maintain_momentum', 'career_roi'},
  ),
];

class RoadmapScreen extends ConsumerWidget {
  final VoidCallback? onOpenGuide;

  const RoadmapScreen({super.key, this.onOpenGuide});

  int _currentStageIndex(UserStats stats) {
    final activeIds = stats.activeRoadmapSteps.map((step) => step.id).toSet();
    for (var i = 0; i < _genericRoadmapStages.length; i++) {
      if (_genericRoadmapStages[i].stepIds.any(activeIds.contains)) {
        return i;
      }
    }
    return _genericRoadmapStages.length - 1;
  }

  void _openGenericRoadmapSheet(BuildContext context, UserStats stats) {
    final currentStage = _currentStageIndex(stats);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _GenericRoadmapSheet(currentStage: currentStage),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(userStatsProvider);
    final steps = stats.roadmapSteps;
    final currentStage = _currentStageIndex(stats);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          children: [
            Text('Roadmap', style: Theme.of(context).textTheme.displaySmall)
                .animate()
                .fadeIn(duration: 300.ms)
                .slideY(begin: 0.2, end: 0, duration: 300.ms),
            const SizedBox(height: 4),
            Text(
              'Your next steps, ranked by what matters most right now.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ).animate().fadeIn(duration: 300.ms, delay: 80.ms),
            const SizedBox(height: 18),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _openGenericRoadmapSheet(context, stats),
                child: BentoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${stats.completedRoadmapStepsCount} of ${steps.length} completed',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Tap a card to learn more or mark it done.',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          height: 1.45,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.navy.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.route_rounded,
                              size: 16,
                              color: AppColors.navy,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Generic roadmap view: ${_genericRoadmapStages[currentStage].title}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.navy,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.expand_more_rounded,
                              size: 18,
                              color: AppColors.navy,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            if (steps.isEmpty)
              BentoCard(
                child: Text(
                  'You are all caught up. Revisit Home or Profile if you want to update your details.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            else
              ...steps.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: RoadmapStepCard(
                    step: entry.value,
                    completed: stats.completedRoadmapStepIds.contains(
                      entry.value.id,
                    ),
                    canComplete: stats.canCompleteRoadmapStep(entry.value.id),
                    onLearn: () {
                      final article = guideArticleForStep(entry.value.id);
                      if (article == null) return;
                      AnalyticsService.logEvent(
                        'roadmap_learn_open',
                        parameters: {
                          'step_id': entry.value.id,
                          'article_id': article.id,
                        },
                      );
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => _LearnSheet(
                          article: article,
                          stepId: entry.value.id,
                          onOpenGuide: onOpenGuide,
                        ),
                      );
                    },
                    onToggleComplete: () async {
                      final notifier = ref.read(userStatsProvider.notifier);
                      final completed = stats.completedRoadmapStepIds.contains(
                        entry.value.id,
                      );
                      if (completed) {
                        await notifier.uncompleteRoadmapStep(entry.value.id);
                        await AnalyticsService.logEvent(
                          'roadmap_step_uncompleted',
                          parameters: {'step_id': entry.value.id},
                        );
                      } else {
                        await notifier.completeRoadmapStep(entry.value.id);
                        await AnalyticsService.logEvent(
                          'roadmap_step_completed',
                          parameters: {'step_id': entry.value.id},
                        );
                      }
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GenericRoadmapSheet extends StatelessWidget {
  final int currentStage;

  const _GenericRoadmapSheet({required this.currentStage});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                    color: AppColors.border.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Generic Roadmap',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'High-level order for most users. Your current position is highlighted.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  height: 1.45,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              ..._genericRoadmapStages.asMap().entries.map((entry) {
                final index = entry.key;
                final stage = entry.value;
                final isCurrent = index == currentStage;
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? AppColors.success.withValues(alpha: 0.14)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCurrent
                              ? AppColors.success.withValues(alpha: 0.45)
                              : AppColors.border.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: isCurrent
                                  ? AppColors.success.withValues(alpha: 0.2)
                                  : AppColors.navy.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              stage.icon,
                              size: 16,
                              color: isCurrent ? AppColors.success : AppColors.navy,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  stage.title,
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  stage.subtitle,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isCurrent) const SizedBox(width: 10),
                          if (isCurrent)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'You are here',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (index < _genericRoadmapStages.length - 1)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: AppColors.textMuted,
                        ),
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _LearnSheet extends StatelessWidget {
  final GuideArticle article;
  final String stepId;
  final VoidCallback? onOpenGuide;

  const _LearnSheet({
    required this.article,
    required this.stepId,
    this.onOpenGuide,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
              Text(
                article.title,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                article.summary,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 18),
              ...article.bullets.map(
                (bullet) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('•', style: GoogleFonts.inter(fontSize: 16)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          bullet,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            height: 1.45,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    AnalyticsService.logEvent(
                      'roadmap_learn_more_tap',
                      parameters: {
                        'step_id': stepId,
                        'article_id': article.id,
                      },
                    );
                    Navigator.of(context).pop();
                    onOpenGuide?.call();
                  },
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: const Text('Learn more in Guide'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
