import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme.dart';
import '../../providers/user_stats_provider.dart';
import '../../widgets/shared/bento_card.dart';
import '../../widgets/shared/roadmap_step_card.dart';
import '../guide/guide_content.dart';

class RoadmapScreen extends ConsumerWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(userStatsProvider);
    final steps = stats.roadmapSteps;

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
            BentoCard(
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
                ],
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
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => _LearnSheet(article: article),
                      );
                    },
                    onToggleComplete: () async {
                      final notifier = ref.read(userStatsProvider.notifier);
                      final completed = stats.completedRoadmapStepIds.contains(
                        entry.value.id,
                      );
                      if (completed) {
                        await notifier.uncompleteRoadmapStep(entry.value.id);
                      } else {
                        await notifier.completeRoadmapStep(entry.value.id);
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

class _LearnSheet extends StatelessWidget {
  final GuideArticle article;

  const _LearnSheet({required this.article});

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
            ],
          ),
        ),
      ),
    );
  }
}
