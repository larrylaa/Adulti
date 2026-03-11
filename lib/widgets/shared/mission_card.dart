import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/mission.dart';
import '../../app/theme.dart';
import 'bento_card.dart';

class MissionCard extends StatelessWidget {
  final Mission mission;
  final int animationDelay;

  const MissionCard({
    super.key,
    required this.mission,
    this.animationDelay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(
          duration: 400.ms,
          delay: Duration(milliseconds: animationDelay),
        ),
        SlideEffect(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
          duration: 400.ms,
          delay: Duration(milliseconds: animationDelay),
          curve: Curves.easeOutCubic,
        ),
      ],
      child: BentoCard(
        padding: EdgeInsets.zero,
        borderColor: mission.priority.color.withValues(alpha: 0.25),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Colored left accent bar
                Container(width: 4, color: mission.priority.color),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _PriorityBadge(priority: mission.priority),
                            const Spacer(),
                            _PriorityIcon(priority: mission.priority),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          mission.title,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mission.subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                            height: 1.5,
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
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  final MissionPriority priority;
  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: priority.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        priority.label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: priority.color,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _PriorityIcon extends StatelessWidget {
  final MissionPriority priority;
  const _PriorityIcon({required this.priority});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    switch (priority) {
      case MissionPriority.high:
        icon = Icons.lock_open_rounded;
      case MissionPriority.medium:
        icon = Icons.cloud_outlined;
      case MissionPriority.utility:
        icon = Icons.shield_outlined;
      case MissionPriority.endgame:
        icon = Icons.bolt_rounded;
    }
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: priority.bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 16, color: priority.color),
    );
  }
}
