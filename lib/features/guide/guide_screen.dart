import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme.dart';
import '../../services/analytics_service.dart';
import '../../widgets/shared/bento_card.dart';
import 'guide_article_screen.dart';
import 'guide_content.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  void _openArticle(BuildContext context, GuideArticle article) {
    AnalyticsService.logEvent(
      'guide_article_open',
      parameters: {
        'article_id': article.id,
        'source': 'guide_tab',
      },
    );
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => GuideArticleScreen(article: article),
      ),
    );
  }

  IconData _iconForArticle(String id) {
    switch (id) {
      case 'starter_buffer':
      case 'seal_vault':
        return Icons.savings_rounded;
      case 'dispel_shadow':
        return Icons.trending_down_rounded;
      case 'credit_shield':
        return Icons.verified_user_rounded;
      case 'career_roi':
        return Icons.work_history_rounded;
      case 'time_machine':
      case 'automate_investing':
        return Icons.auto_graph_rounded;
      case 'invest_401k_match':
      case 'invest_401k_more':
        return Icons.account_balance_rounded;
      case 'invest_hsa':
        return Icons.health_and_safety_rounded;
      case 'invest_ira':
        return Icons.pie_chart_rounded;
      case 'invest_brokerage':
        return Icons.show_chart_rounded;
      default:
        return Icons.menu_book_rounded;
    }
  }

  Color _accentForArticle(String id) {
    switch (id) {
      case 'starter_buffer':
      case 'seal_vault':
        return AppColors.success;
      case 'dispel_shadow':
        return AppColors.warning;
      case 'credit_shield':
        return AppColors.shadowBlue;
      case 'career_roi':
        return AppColors.navyLight;
      case 'time_machine':
      case 'automate_investing':
      case 'invest_401k_match':
      case 'invest_hsa':
      case 'invest_ira':
      case 'invest_401k_more':
      case 'invest_brokerage':
        return AppColors.navy;
      default:
        return AppColors.navy;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -40,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.shadowBlue.withValues(alpha: 0.12),
                ),
              ),
            ),
            Positioned(
              bottom: -90,
              left: -40,
              child: Container(
                width: 210,
                height: 210,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success.withValues(alpha: 0.1),
                ),
              ),
            ),
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              children: [
                Text('Guide', style: Theme.of(context).textTheme.displaySmall)
                    .animate()
                    .fadeIn(duration: 300.ms)
                    .slideY(begin: 0.2, end: 0, duration: 300.ms),
                const SizedBox(height: 4),
                Text(
                  'Short finance explanations you can open from the roadmap.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: 80.ms),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.navy.withValues(alpha: 0.15),
                        AppColors.shadowBlue.withValues(alpha: 0.12),
                      ],
                    ),
                    border: Border.all(
                      color: AppColors.navy.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.auto_stories_rounded,
                        size: 18,
                        color: AppColors.navy,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${guideArticles.length} guides available',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ...guideArticles.map((article) {
                  final accent = _accentForArticle(article.id);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: BentoCard(
                      borderColor: accent.withValues(alpha: 0.28),
                      backgroundColor: accent.withValues(alpha: 0.05),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withValues(alpha: 0.14),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      accent.withValues(alpha: 0.92),
                                      AppColors.navy.withValues(alpha: 0.86),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _iconForArticle(article.id),
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  article.title,
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            article.summary,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              height: 1.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...article.bullets.map(
                            (bullet) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.bolt_rounded,
                                    size: 14,
                                    color: accent,
                                  ),
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
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: FilledButton.icon(
                              onPressed: () => _openArticle(context, article),
                              style: FilledButton.styleFrom(
                                backgroundColor: accent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                minimumSize: const Size(0, 32),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                textStyle: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              icon: const Icon(Icons.menu_book_rounded, size: 15),
                              label: const Text('Read Full Guide'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
