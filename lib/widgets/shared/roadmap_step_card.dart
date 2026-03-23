import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme.dart';
import '../../models/mission.dart';
import '../../models/roadmap_step.dart';
import 'bento_card.dart';

class RoadmapStepCard extends StatelessWidget {
  final RoadmapStep step;
  final bool completed;
  final bool canComplete;
  final VoidCallback onLearn;
  final VoidCallback onToggleComplete;

  const RoadmapStepCard({
    super.key,
    required this.step,
    required this.completed,
    required this.canComplete,
    required this.onLearn,
    required this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(duration: 320.ms),
        SlideEffect(
          begin: const Offset(0, 0.16),
          end: Offset.zero,
          duration: 320.ms,
          curve: Curves.easeOutCubic,
        ),
      ],
      child: GestureDetector(
        onTap: onLearn,
        child: BentoCard(
          borderColor: step.priority.color.withValues(alpha: 0.25),
          backgroundColor: completed
              ? step.priority.bgColor.withValues(alpha: 0.55)
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _PriorityBadge(
                          priority: step.priority,
                          completed: completed,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          step.title,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          step.summary,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            height: 1.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    completed
                        ? Icons.check_circle_rounded
                        : Icons.tips_and_updates_rounded,
                    color: completed ? AppColors.success : step.priority.color,
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.navy.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  step.whyItMatters,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    height: 1.45,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                step.actionLabel,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      step.resourceHint,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        height: 1.4,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: onLearn,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.navy,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'LEARN',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    onPressed: onToggleComplete,
                    style: FilledButton.styleFrom(
                      backgroundColor: completed
                          ? AppColors.success
                          : step.priority.color,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      completed ? 'UNDO' : 'MARK DONE',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  final MissionPriority priority;
  final bool completed;

  const _PriorityBadge({required this.priority, required this.completed});

  @override
  Widget build(BuildContext context) {
    final color = completed ? AppColors.success : priority.color;
    final label = completed ? 'COMPLETED' : priority.label;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
