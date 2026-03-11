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
                child: _FocusGlow(
                  active: focus == StageFocus.shadow,
                  color: AppColors.warning,
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
                child: _FocusGlow(
                  active: focus == StageFocus.watch,
                  color: AppColors.shadowBlue,
                  child: WatchBeamWidget(active: stats.anyInvestmentActive),
                ),
              ),

              // ── Vault (left of character) ───────────────────────────────
              Positioned(
                bottom: 24,
                left: 12,
                child: _FocusGlow(
                  active: focus == StageFocus.vault,
                  color: AppColors.success,
                  child: VaultWidget(savings: stats.savings)
                      .animate(target: stats.savings >= 1000 ? 1 : 0)
                      .shake(hz: 3, duration: 400.ms),
                ),
              ),

              // ── Desk (right of character) ───────────────────────────────
              Positioned(
                bottom: 16,
                right: 8,
                child: _FocusGlow(
                  active: focus == StageFocus.desk,
                  color: AppColors.success,
                  child: DeskWidget(checking: stats.checking),
                ),
              ),

              // ── Character (center) ──────────────────────────────────────
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: CharacterWidget(characterClass: stats.characterClass),
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

/// Animated glow ring that surrounds a stage element when it's in focus.
class _FocusGlow extends StatelessWidget {
  final bool active;
  final Color color;
  final Widget child;

  const _FocusGlow({
    required this.active,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: active
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.35),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ]
            : [],
      ),
      child: active
          ? child
                .animate(onPlay: (c) => c.repeat())
                .shimmer(duration: 1500.ms, color: color.withValues(alpha: 0.3))
          : child,
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
