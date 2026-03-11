import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme.dart';
import '../../models/user_stats.dart';
import '../../providers/user_stats_provider.dart';

class Chapter0Gender extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const Chapter0Gender({super.key, required this.onNext});

  @override
  ConsumerState<Chapter0Gender> createState() => _Chapter0GenderState();
}

class _Chapter0GenderState extends ConsumerState<Chapter0Gender> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: ref.read(userStatsProvider).name ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedGender = ref.watch(userStatsProvider).gender;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
                'First — who\'s playing?',
                style: Theme.of(context).textTheme.displaySmall,
              )
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
            'Your character will reflect your choice on the stage.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

          const SizedBox(height: 20),

          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Your Name (optional)',
              labelStyle: GoogleFonts.inter(
                color: AppColors.textMuted,
                fontSize: 14,
              ),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.15),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.15),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.navy, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
            onChanged: (value) {
              ref
                  .read(userStatsProvider.notifier)
                  .setName(value.isEmpty ? null : value);
            },
          ).animate().fadeIn(duration: 400.ms, delay: 180.ms),

          const SizedBox(height: 24),

          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _GenderTile(
                    gender: CharacterGender.male,
                    label: 'Male',
                    symbol: '♂',
                    emoji: '🧑',
                    delay: 150.ms,
                    isSelected: selectedGender == CharacterGender.male,
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      await ref
                          .read(userStatsProvider.notifier)
                          .setGender(CharacterGender.male);
                      await Future.delayed(const Duration(milliseconds: 300));
                      widget.onNext();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _GenderTile(
                    gender: CharacterGender.female,
                    label: 'Female',
                    symbol: '♀',
                    emoji: '🧑',
                    delay: 230.ms,
                    isSelected: selectedGender == CharacterGender.female,
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      await ref
                          .read(userStatsProvider.notifier)
                          .setGender(CharacterGender.female);
                      await Future.delayed(const Duration(milliseconds: 300));
                      widget.onNext();
                    },
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

class _GenderTile extends StatelessWidget {
  final CharacterGender gender;
  final String label;
  final String symbol;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;
  final Duration delay;

  const _GenderTile({
    required this.gender,
    required this.label,
    required this.symbol,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
    this.delay = Duration.zero,
  });

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
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                symbol,
                style: TextStyle(
                  fontSize: 48,
                  color: isSelected ? Colors.white : AppColors.navy,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                label,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
