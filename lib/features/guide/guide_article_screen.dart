import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme.dart';
import 'guide_content.dart';

class GuideArticleScreen extends StatelessWidget {
  final GuideArticle article;

  const GuideArticleScreen({super.key, required this.article});

  Color _accentColorForArticle() {
    switch (article.id) {
      case 'starter_buffer':
      case 'seal_vault':
        return AppColors.success;
      case 'dispel_shadow':
        return AppColors.warning;
      case 'credit_shield':
        return AppColors.shadowBlue;
      case 'career_roi':
        return AppColors.navyLight;
      default:
        return AppColors.navy;
    }
  }

  IconData _headerIconForArticle() {
    switch (article.id) {
      case 'starter_buffer':
      case 'seal_vault':
        return Icons.savings_rounded;
      case 'dispel_shadow':
        return Icons.trending_down_rounded;
      case 'credit_shield':
        return Icons.verified_user_rounded;
      case 'career_roi':
        return Icons.work_history_rounded;
      case 'invest_hsa':
        return Icons.health_and_safety_rounded;
      default:
        return Icons.menu_book_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accentColorForArticle();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_headerIconForArticle(), size: 18, color: accent),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                article.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -70,
              right: -60,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -30,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.shadowBlue.withValues(alpha: 0.08),
                ),
              ),
            ),
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              children: [
                Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                          colors: [
                            accent.withValues(alpha: 0.16),
                            AppColors.shadowBlue.withValues(alpha: 0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: accent.withValues(alpha: 0.22),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: accent.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  'Quick take',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: accent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            article.summary,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              height: 1.55,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 260.ms)
                    .slideY(begin: 0.08, end: 0),
                const SizedBox(height: 12),
                _GuideSectionBlock(
                  title: 'Why it matters',
                  icon: Icons.lightbulb_outline_rounded,
                  accent: AppColors.shadowBlue,
                  child: Text(
                    article.whyItMatters,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      height: 1.55,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _GuideSectionBlock(
                  title: 'How to do it',
                  icon: Icons.playlist_add_check_rounded,
                  accent: AppColors.success,
                  child: _StepList(items: article.actionSteps),
                ),
                const SizedBox(height: 12),
                _GuideSectionBlock(
                  title: 'Watch out for',
                  icon: Icons.warning_amber_rounded,
                  accent: AppColors.warning,
                  child: _BulletList(items: article.watchOutFor),
                ),
                const SizedBox(height: 12),
                _GuideSectionBlock(
                  title: 'Next step',
                  icon: Icons.arrow_circle_right_outlined,
                  accent: accent,
                  child: Text(
                    article.nextMove,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      height: 1.55,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideSectionBlock extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accent;
  final Widget child;

  const _GuideSectionBlock({
    required this.title,
    required this.icon,
    required this.accent,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.22), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: accent),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),
          DefaultTextStyle(
            style: GoogleFonts.inter(
              fontSize: 13.5,
              height: 1.5,
              color: AppColors.textPrimary,
            ),
            child: child,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 260.ms, delay: 40.ms);
  }
}

class _BulletList extends StatelessWidget {
  final List<String> items;

  const _BulletList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•', style: GoogleFonts.inter(fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        height: 1.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _StepList extends StatelessWidget {
  final List<String> items;

  const _StepList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .asMap()
          .entries
          .map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.navy.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${entry.key + 1}',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        height: 1.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
