class GuideArticle {
  final String id;
  final String title;
  final String summary;
  final List<String> bullets;
  final String whyItMatters;
  final List<String> actionSteps;
  final List<String> watchOutFor;
  final String nextMove;

  const GuideArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.bullets,
    required this.whyItMatters,
    required this.actionSteps,
    required this.watchOutFor,
    required this.nextMove,
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
    whyItMatters:
        'A starter buffer protects your monthly plan from small shocks. Without it, even a minor car repair, fee, or urgent purchase can push you back into debt and undo progress.',
    actionSteps: [
      'Pick one account for this buffer so the money is easy to find when needed.',
      'Set a starter target that feels achievable in your current season.',
      'Automate a small transfer every payday until the target is reached.',
      'Use the buffer only for true unplanned costs, then refill it right away.',
    ],
    watchOutFor: [
      'Do not park the buffer in risky investments or accounts that take days to access.',
      'Do not wait for a perfect amount before starting. Momentum matters more.',
      'Do not treat the buffer as extra spending money during normal weeks.',
    ],
    nextMove:
        'Once your starter buffer feels stable, transition to building your emergency fund while keeping this account available for quick access.',
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
    whyItMatters:
        'An emergency fund gives you time and options when life changes fast. It reduces panic decisions and helps you avoid new debt when income drops or costs spike unexpectedly.',
    actionSteps: [
      'Define what counts as an emergency before you need to decide under stress.',
      'Choose a target range that matches your living costs and current job stability.',
      'Send automatic transfers to a separate high-yield savings account.',
      'Review your target every few months as rent, bills, or responsibilities change.',
    ],
    watchOutFor: [
      'Do not keep this in your daily spending account where it is easy to drain.',
      'Do not pause all progress after one setback. Restart with a smaller transfer.',
      'Do not use it for planned events like holidays or upgrades.',
    ],
    nextMove:
        'When your emergency fund habit is consistent, redirect extra cash toward debt payoff or investing based on your current priorities.',
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
    whyItMatters:
        'Debt becomes manageable when it is visible and ranked. A clear payoff plan lowers stress, improves cash flow over time, and helps you build confidence from small wins.',
    actionSteps: [
      'List every debt with balance, minimum payment, and interest rate in one place.',
      'Pick a single payoff strategy and stick with it for at least one full cycle.',
      'Automate minimum payments so you avoid late fees and credit damage.',
      'Put all extra money toward one target debt until it is cleared, then roll that payment forward.',
    ],
    watchOutFor: [
      'Do not switch strategies every month. Consistency beats constant tweaking.',
      'Do not ignore interest rates when comparing two similar balances.',
      'Do not close useful accounts in a rush without understanding score impact.',
    ],
    nextMove:
        'After one debt is gone, keep the same total payment amount and apply it to the next debt to accelerate momentum.',
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
    whyItMatters:
        'Credit affects more than loans. It can influence housing options, interest costs, and approval odds for major life steps. Building good habits early usually saves money later.',
    actionSteps: [
      'Pay every required bill on time, even if the amount is small.',
      'Keep credit utilization low by not carrying high balances month to month.',
      'Review your credit report regularly and dispute obvious errors quickly.',
      'Treat new credit applications intentionally instead of opening accounts impulsively.',
    ],
    watchOutFor: [
      'Do not miss due dates because of avoidable setup issues. Use reminders or autopay.',
      'Do not max out cards during one rough month without a clear payback plan.',
      'Do not apply for several new accounts in a short window unless necessary.',
    ],
    nextMove:
        'Once your payment rhythm is stable, keep monitoring credit monthly and focus on long-term consistency rather than short-term score swings.',
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
    whyItMatters:
        'Your earning power is often your strongest financial lever. Better role fit, stronger skills, and smart early decisions can compound for years and make every other money goal easier.',
    actionSteps: [
      'Map a few career paths and compare compensation, growth, and required credentials.',
      'Prioritize skills that are transferable across industries, not just one job title.',
      'Use projects, internships, and networking to shorten the gap to better opportunities.',
      'Reassess your path every quarter to see whether your effort is improving future options.',
    ],
    watchOutFor: [
      'Do not focus only on starting salary while ignoring growth potential and fit.',
      'Do not delay skill-building because you are waiting for perfect conditions.',
      'Do not compare your timeline too closely to others. Progress is personal.',
    ],
    nextMove:
        'Pick one concrete career upgrade this month, such as a certification module, portfolio piece, or networking target, and schedule it.',
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
    whyItMatters:
        'Investing helps your money work while you focus on life and career. Starting with simple systems early is usually more valuable than waiting to feel perfectly prepared.',
    actionSteps: [
      'Get clear on account order: workplace plan, IRA options, then brokerage as needed.',
      'Choose a straightforward diversified approach you can explain in one sentence.',
      'Set a recurring contribution schedule, even if the amount starts small.',
      'Review progress occasionally and rebalance only when your plan requires it.',
    ],
    watchOutFor: [
      'Do not invest emergency cash you may need soon.',
      'Do not chase trends or switch plans based on short-term headlines.',
      'Do not overcomplicate your setup with too many overlapping funds.',
    ],
    nextMove:
        'After your first automated contributions are active, focus on staying consistent for several months before making big changes.',
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
    whyItMatters:
        'Automation removes friction and decision fatigue. It turns investing into a repeatable system instead of a mood-based task, which improves follow-through over time.',
    actionSteps: [
      'Choose a fixed amount that fits your normal budget, not your best month.',
      'Schedule contributions right after payday to reduce missed transfers.',
      'Keep one default allocation so new deposits are invested automatically.',
      'Do a lightweight monthly check to confirm transfers happened and accounts look normal.',
    ],
    watchOutFor: [
      'Do not set aggressive amounts you cannot sustain through routine expenses.',
      'Do not pause automation after temporary market drops unless your goals changed.',
      'Do not check the account daily. That usually adds stress without helping outcomes.',
    ],
    nextMove:
        'Once automation feels stable, increase contributions slowly when income improves instead of making one large jump.',
  ),
  GuideArticle(
    id: 'invest_401k_match',
    title: '401(k) / 403(b): capture the match first',
    summary:
        'If you have a workplace plan, your first priority is usually contributing enough to get the full employer match.',
    bullets: [
      'A match means your employer adds money when you contribute.',
      'Traditional contributions usually reduce taxable income now.',
      'Roth contributions are taxed now, then qualified withdrawals are tax-free later.',
    ],
    whyItMatters:
        'Match dollars are part of your compensation. Missing a match can be like turning down money you already earned.',
    actionSteps: [
      'Check your plan details and find the contribution rate needed for the full match.',
      'Set your payroll contribution to at least that rate if your budget allows.',
      'Pick Traditional vs Roth based on your tax strategy and timeline.',
      'Re-check your contribution after raises so your savings rate keeps improving.',
    ],
    watchOutFor: [
      'Do not contribute below the match level for long periods if you can avoid it.',
      'Do not confuse Traditional and Roth tax treatment. They are not interchangeable.',
      'Do not ignore vesting rules or plan fees in your benefits documents.',
    ],
    nextMove:
        'After your match is covered, your next priority is usually HSA or IRA depending on what you have available.',
  ),
  GuideArticle(
    id: 'invest_hsa',
    title: 'HSA: tax-advantaged health investing',
    summary:
        'If you are eligible, an HSA can be one of the most tax-efficient accounts in your stack.',
    bullets: [
      'HSA eligibility depends on your health plan type.',
      'Contributions can reduce taxable income in many cases.',
      'Qualified medical withdrawals are tax-free.',
    ],
    whyItMatters:
        'An HSA can support current medical costs or be invested for future healthcare expenses, while keeping strong tax advantages.',
    actionSteps: [
      'Confirm that your health plan makes you HSA-eligible this year.',
      'Set a recurring contribution amount that fits your monthly cash flow.',
      'Decide whether to spend from the HSA now or let more of it stay invested long-term.',
      'Track receipts and medical expenses carefully if you plan reimbursement strategies.',
    ],
    watchOutFor: [
      'Do not contribute if you are not eligible for the year.',
      'Do not assume every expense is automatically qualified. Check current rules.',
      'Do not forget that contribution limits apply and can change over time.',
    ],
    nextMove:
        'After your 401(k)/403(b) match and HSA plan are in place, move to IRA contributions if available.',
  ),
  GuideArticle(
    id: 'invest_ira',
    title: 'IRA: Traditional vs Roth basics',
    summary:
        'IRAs are strong long-term accounts, but Traditional IRA and Roth IRA have different tax and withdrawal behavior.',
    bullets: [
      'Traditional IRA may offer tax deduction now, with taxable withdrawals later.',
      'Roth IRA uses after-tax money, but qualified withdrawals are tax-free later.',
      'Roth IRA contributions (not earnings) can generally be withdrawn anytime without tax or penalty.',
    ],
    whyItMatters:
        'Knowing the differences helps you avoid tax surprises and choose an IRA that matches your current income and future expectations.',
    actionSteps: [
      'Check annual IRA contribution limits for the current tax year.',
      'Decide whether Traditional or Roth IRA fits your tax situation better.',
      'Automate monthly contributions so progress does not depend on motivation.',
      'Keep your investment mix simple and review once in a while, not constantly.',
    ],
    watchOutFor: [
      'Do not mix up contribution limits across different IRA types.',
      'Do not assume all withdrawals are penalty-free. Earnings have stricter rules.',
      'Do not delay contributions all year and expect consistency to happen automatically.',
    ],
    nextMove:
        'Once IRA contributions are stable, revisit your workplace plan contribution rate and increase it over time.',
  ),
  GuideArticle(
    id: 'invest_401k_more',
    title: '401(k)/403(b): increase contributions over time',
    summary:
        'After match and core priorities are handled, gradually increasing your contribution rate can materially improve long-term outcomes.',
    bullets: [
      'Small percentage increases can be easier than large jumps.',
      'Raises and bonuses are common moments to increase savings rate.',
      'Rollovers can preserve momentum when switching jobs.',
    ],
    whyItMatters:
        'Contribution growth compounds over decades. Even incremental increases can add up meaningfully without requiring a dramatic lifestyle cut.',
    actionSteps: [
      'Set a calendar checkpoint every 3-6 months to review your contribution rate.',
      'Increase by a small amount you can keep consistent.',
      'If you change jobs, compare rollover options so retirement assets stay organized.',
      'Keep your contribution plan aligned with your broader savings and debt goals.',
    ],
    watchOutFor: [
      'Do not increase contributions so aggressively that you create short-term cash stress.',
      'Do not leave old accounts unmanaged after a job change.',
      'Do not overreact to market volatility by turning contributions off.',
    ],
    nextMove:
        'When your tax-advantaged plan is stable, fund brokerage for additional flexible long-term goals.',
  ),
  GuideArticle(
    id: 'invest_brokerage',
    title: 'Brokerage: usually after tax-advantaged accounts',
    summary:
        'Brokerage accounts are flexible and useful, but often come after 401(k)/403(b), HSA, and IRA priorities.',
    bullets: [
      'Brokerage has flexibility with fewer account-specific restrictions.',
      'It usually lacks the same tax advantages as retirement or HSA contributions.',
      'Use it when your higher-priority account contributions are already on track.',
    ],
    whyItMatters:
        'Brokerage fills the gap for additional long-term investing and goal-based flexibility once tax-advantaged accounts are handled.',
    actionSteps: [
      'Define a clear purpose for brokerage contributions so risk matches timeline.',
      'Set a recurring transfer only after your core account priorities are funded.',
      'Keep your investment approach broad and simple.',
      'Review contribution amount first before making major strategy changes.',
    ],
    watchOutFor: [
      'Do not use this account as a short-term spending pool.',
      'Do not chase hype assets just because they are trending.',
      'Do not prioritize brokerage over match/HSA/IRA unless your situation clearly calls for it.',
    ],
    nextMove:
        'Keep brokerage as a deliberate final layer in your contribution order, not the first place you start.',
  ),
];

GuideArticle? guideArticleForStep(String stepId) {
  for (final article in guideArticles) {
    if (article.id == stepId) return article;
  }
  return null;
}
