import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme.dart';
import '../../models/user_stats.dart';
import '../../providers/user_stats_provider.dart';

class Chapter1ClassSelection extends ConsumerWidget {
  final VoidCallback onNext;

  const Chapter1ClassSelection({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedClass = ref.watch(userStatsProvider).characterClass;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Who are you?', style: Theme.of(context).textTheme.displaySmall)
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(
                begin: 0.3,
                end: 0,
                duration: 400.ms,
                curve: Curves.easeOutCubic,
              ),

          const SizedBox(height: 4),

          Text(
            'Pick your class to initialize your character.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

          const SizedBox(height: 20),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: CharacterClass.values
                  .asMap()
                  .entries
                  .map(
                    (entry) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: entry.key == 0 ? 0 : 6,
                          right: entry.key == CharacterClass.values.length - 1
                              ? 0
                              : 6,
                        ),
                        child:
                            _ClassTile(
                                  cls: entry.value,
                                  isSelected: selectedClass == entry.value,
                                  onTap: () async {
                                    HapticFeedback.lightImpact();
                                    await ref
                                        .read(userStatsProvider.notifier)
                                        .setClass(entry.value);
                                    await Future.delayed(
                                      const Duration(milliseconds: 300),
                                    );
                                    onNext();
                                  },
                                )
                                .animate()
                                .fadeIn(
                                  duration: 400.ms,
                                  delay: Duration(
                                    milliseconds: 150 + entry.key * 80,
                                  ),
                                )
                                .slideY(
                                  begin: 0.4,
                                  end: 0,
                                  duration: 400.ms,
                                  delay: Duration(
                                    milliseconds: 150 + entry.key * 80,
                                  ),
                                  curve: Curves.easeOutCubic,
                                ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClassTile extends StatelessWidget {
  final CharacterClass cls;
  final bool isSelected;
  final VoidCallback onTap;

  const _ClassTile({
    required this.cls,
    required this.isSelected,
    required this.onTap,
  });

  String get _icon {
    switch (cls) {
      case CharacterClass.student:
        return '🎒';
      case CharacterClass.graduate:
        return '🎓';
      case CharacterClass.professional:
        return '💼';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.navy : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.navy
                : AppColors.border.withValues(alpha: 0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.navy.withValues(alpha: 0.2)
                  : AppColors.navy.withValues(alpha: 0.05),
              blurRadius: isSelected ? 12 : 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_icon, style: const TextStyle(fontSize: 30)),
              const SizedBox(height: 12),
              Text(
                cls.displayName,
                textAlign: TextAlign.center,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                cls.tagline,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.7)
                      : AppColors.textMuted,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
