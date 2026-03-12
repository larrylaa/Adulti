import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme.dart';
import '../../providers/stage_focus_provider.dart';
import '../../widgets/tactical_stage/tactical_stage.dart';
import 'chapter0_gender.dart';
import 'chapter1_class_selection.dart';
import 'chapter2_loadout.dart';
import 'chapter3_roi_oracle.dart';

class OnboardingShell extends ConsumerStatefulWidget {
  const OnboardingShell({super.key});

  @override
  ConsumerState<OnboardingShell> createState() => _OnboardingShellState();
}

class _OnboardingShellState extends ConsumerState<OnboardingShell> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      final page = (_pageController.page ?? 0).round();
      if (page != _currentPage) {
        setState(() => _currentPage = page);
        // Clear stage focus when leaving chapter 2
        if (page != 2) {
          ref.read(stageFocusProvider.notifier).state = null;
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    // Clear focus when leaving chapter 2
    if (_currentPage == 2) {
      ref.read(stageFocusProvider.notifier).state = null;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  void _prevPage() {
    // Clear focus when leaving chapter 2
    if (_currentPage == 2) {
      ref.read(stageFocusProvider.notifier).state = null;
    }
    _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentPage == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _prevPage();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              // ── Top 40%: Tactical Stage ────────────────────────────
              Expanded(
                flex: 2,
                child: ClipRect(
                  child: Stack(
                    children: [
                      const TacticalStage(),
                      // Chapter progress indicator
                      Positioned(
                        top: 12,
                        left: 0,
                        right: 0,
                        child: _ChapterIndicator(controller: _pageController),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                height: 1,
                color: AppColors.navy.withValues(alpha: 0.06),
              ),

              // ── Bottom 60%: Mission Console ────────────────────────
              Expanded(
                flex: 3,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Chapter0Gender(onNext: _nextPage),
                    Chapter1ClassSelection(onNext: _nextPage),
                    Chapter2Loadout(onNext: _nextPage, onBack: _prevPage),
                    Chapter3RoiOracle(onBack: _prevPage),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChapterIndicator extends StatelessWidget {
  final PageController controller;

  const _ChapterIndicator({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final page = controller.hasClients
            ? (controller.page ?? 0).round().clamp(0, 3)
            : 0;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (i) {
            final isActive = i == page;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.navy
                    : AppColors.navy.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        );
      },
    );
  }
}
