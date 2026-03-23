class GuideArticle {
  final String id;
  final String title;
  final String summary;
  final List<String> bullets;

  const GuideArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.bullets,
  });
}

const guideArticles = <GuideArticle>[
  GuideArticle(
    id: 'starter_buffer',
    title: 'Starter buffer',
    summary:
        'A small cash cushion helps you handle surprise expenses without using debt.',
    bullets: [
      'Keep it in checking or a savings account you can access easily.',
      'Start small if needed and build over time.',
      'The goal is breathing room, not perfect optimization.',
    ],
  ),
  GuideArticle(
    id: 'seal_vault',
    title: 'Emergency fund',
    summary:
        'Your emergency fund keeps one bad week from becoming a long financial setback.',
    bullets: [
      'Set a target that feels realistic for your current stage.',
      'Automate transfers so progress keeps moving.',
      'Use it for real emergencies, not everyday spending.',
    ],
  ),
  GuideArticle(
    id: 'dispel_shadow',
    title: 'Debt payoff',
    summary:
        'Debt is easier to handle when you know every balance and the cost of each one.',
    bullets: [
      'Write down each debt, balance, and interest rate.',
      'Decide whether to focus on the smallest balance or highest interest rate first.',
      'Keep minimum payments current while you attack the target.',
    ],
  ),
  GuideArticle(
    id: 'credit_shield',
    title: 'Credit basics',
    summary:
        'Credit matters earlier than many people expect, especially for rentals, cars, and loans.',
    bullets: [
      'Learn how credit scores are built.',
      'Pay bills on time and keep balances manageable.',
      'Check your score or credit report periodically.',
    ],
  ),
  GuideArticle(
    id: 'career_roi',
    title: 'Career ROI',
    summary:
        'For students and young adults, career choices often have the biggest long-term money impact.',
    bullets: [
      'Compare majors, jobs, internships, and salary ranges.',
      'Think about skills that create optionality later.',
      'A slightly better first role can matter more than a small monthly budget tweak.',
    ],
  ),
  GuideArticle(
    id: 'time_machine',
    title: 'Investing basics',
    summary:
        'Investing becomes important once your cash buffer and debt situation are under control.',
    bullets: [
      'Learn the purpose of Roth IRA, 401(k), and brokerage accounts.',
      'Use automation if you can.',
      'Consistency matters more than perfect timing.',
    ],
  ),
  GuideArticle(
    id: 'automate_investing',
    title: 'Automated investing',
    summary:
        'Automation makes it easier to invest regularly without relying on memory or motivation.',
    bullets: [
      'Pick an amount you can keep up consistently.',
      'Let contributions happen on a schedule.',
      'Review occasionally, but do not overcomplicate it.',
    ],
  ),
];

GuideArticle? guideArticleForStep(String stepId) {
  for (final article in guideArticles) {
    if (article.id == stepId) return article;
  }
  return null;
}
