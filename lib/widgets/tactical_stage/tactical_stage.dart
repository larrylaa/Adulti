import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_stats_provider.dart';
import '../../providers/stage_focus_provider.dart';
import '../../app/theme.dart';
import 'character_widget.dart';
import 'vault_widget.dart';
import 'desk_widget.dart';
import 'shadow_widget.dart';
import 'watch_beam_widget.dart';

class TacticalStage extends ConsumerWidget {
  const TacticalStage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(userStatsProvider);
    final focus = ref.watch(stageFocusProvider);

    return Container(
      color: AppColors.background,
      child: Center(
        child: SizedBox(
          width: 360,
          height: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Ground / platform
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _GroundPlatform(),
              ),

              // ── Shadow Wisp (behind character) ─────────────────────────
              Positioned(
                bottom: 30,
                left: 80,
                child: _ZoomableProp(
                  isFocused: focus == StageFocus.shadow,
                  anyFocused: focus != null,
                  focusedScale: 1.75,
                  focusedTranslateX: 60,
                  focusedTranslateY: -20,
                  glowColor: AppColors.warning,
                  child: ShadowWidget(
                    totalDebt: stats.totalDebt,
                    debtToIncomeRatio: stats.debtToIncomeRatio,
                  ),
                ),
              ),

              // ── Watch Beam (behind character, elevated) ─────────────────
              Positioned(
                bottom: 55,
                right: 80,
                child: _ZoomableProp(
                  isFocused: focus == StageFocus.watch,
                  anyFocused: focus != null,
                  focusedScale: 1.75,
                  focusedTranslateX: -60,
                  focusedTranslateY: -20,
                  glowColor: AppColors.shadowBlue,
                  child: WatchBeamWidget(active: stats.anyInvestmentActive),
                ),
              ),

              // ── Vault (left of character) ───────────────────────────────
              Positioned(
                bottom: 24,
                left: 12,
                child: _ZoomableProp(
                  isFocused: focus == StageFocus.vault,
                  anyFocused: focus != null,
                  focusedScale: 2.0,
                  focusedTranslateX: 80,
                  focusedTranslateY: -30,
                  glowColor: AppColors.success,
                  child:
                      VaultWidget(
                            savings: stats.savings,
                            savingsGoal: stats.savingsGoal,
                          )
                          .animate(target: stats.vaultSealed ? 1 : 0)
                          .shake(hz: 3, duration: 400.ms),
                ),
              ),

              // ── Desk (right of character) ───────────────────────────────
              Positioned(
                bottom: 16,
                right: 8,
                child: _ZoomableProp(
                  isFocused: focus == StageFocus.desk,
                  anyFocused: focus != null,
                  focusedScale: 2.0,
                  focusedTranslateX: -80,
                  focusedTranslateY: -20,
                  glowColor: AppColors.success,
                  child: DeskWidget(checking: stats.checking),
                ),
              ),

              // ── Character (center) ──────────────────────────────────────
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 350),
                  opacity: focus != null ? 0.25 : 1.0,
                  child: Center(
                    child: CharacterWidget(
                      characterClass: stats.characterClass,
                      gender: stats.gender,
                    ),
                  ),
                ),
              ),

              // ── Spotlight ring beneath character ────────────────────────
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: _SpotlightRing(characterClass: stats.characterClass),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Zooms and dims a stage prop based on focus state.
/// When this prop is focused it scales up and moves toward center.
/// When another prop is focused this one fades back.
class _ZoomableProp extends StatelessWidget {
  final bool isFocused;
  final bool anyFocused;
  final double focusedScale;
  final double focusedTranslateX;
  final double focusedTranslateY;
  final Color glowColor;
  final Widget child;

  const _ZoomableProp({
    required this.isFocused,
    required this.anyFocused,
    required this.focusedScale,
    required this.focusedTranslateX,
    required this.focusedTranslateY,
    required this.glowColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = isFocused ? focusedScale : (anyFocused ? 0.7 : 1.0);
    final double opacity = isFocused ? 1.0 : (anyFocused ? 0.25 : 1.0);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
      opacity: opacity,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: isFocused
                ? [
                    BoxShadow(
                      color: glowColor.withValues(alpha: 0.40),
                      blurRadius: 24,
                      spreadRadius: 6,
                    ),
                  ]
                : [],
          ),
          child: isFocused
              ? child
                    .animate(onPlay: (c) => c.repeat())
                    .shimmer(
                      duration: 1500.ms,
                      color: glowColor.withValues(alpha: 0.25),
                    )
              : child,
        ),
      ),
    );
  }
}

/// Subtle elliptical glow beneath the character's feet.
class _SpotlightRing extends StatelessWidget {
  final dynamic characterClass; // CharacterClass?

  const _SpotlightRing({this.characterClass});

  @override
  Widget build(BuildContext context) {
    final visible = characterClass != null;
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 600),
      child: Container(
        width: 90,
        height: 18,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(50),
          gradient: RadialGradient(
            colors: [
              AppColors.navy.withValues(alpha: 0.15),
              AppColors.navy.withValues(alpha: 0.0),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroundPlatform extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.navy.withValues(alpha: 0.05),
            AppColors.navy.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}
