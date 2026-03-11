import 'package:flutter/material.dart';
import '../../app/theme.dart';

class AppProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double height;
  final Color? activeColor;
  final Color? trackColor;
  final String? label;
  final String? valueLabel;

  const AppProgressBar({
    super.key,
    required this.progress,
    this.height = 8,
    this.activeColor,
    this.trackColor,
    this.label,
    this.valueLabel,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || valueLabel != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null)
                  Text(label!, style: Theme.of(context).textTheme.labelMedium),
                if (valueLabel != null)
                  Text(
                    valueLabel!,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: Stack(
            children: [
              Container(
                height: height,
                decoration: BoxDecoration(
                  color: trackColor ?? AppColors.navy.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
              AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                widthFactor: clamped,
                child: Container(
                  height: height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        activeColor ?? AppColors.success,
                        (activeColor ?? AppColors.success).withValues(
                          alpha: 0.75,
                        ),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(height / 2),
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
