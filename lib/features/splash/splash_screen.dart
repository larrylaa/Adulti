import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme.dart';
import '../../app/router.dart';
import '../../services/firestore_database_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isCheckingProfile = true;

  @override
  void initState() {
    super.initState();
    _checkProfile();
  }

  Future<void> _checkProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      if (!mounted) return;
      setState(() => _isCheckingProfile = false);
      return;
    }

    try {
      final stats = await FirestoreDatabaseService().getUserStats(uid);
      final hasCharacter =
          stats != null &&
          (stats['hasMinted'] == true ||
              (stats['characterClass'] != null && stats['gender'] != null));

      if (!mounted) return;

      if (hasCharacter) {
        Navigator.pushReplacementNamed(context, AppRouter.dashboard);
        return;
      }
    } catch (_) {
      // Fall through to the splash screen if profile loading fails.
    }

    if (!mounted) return;
    setState(() => _isCheckingProfile = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo Badge
              Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.navy.withValues(alpha: 0.18),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.border.withValues(alpha: 0.12),
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Image.asset('demo_photos/adulti_logo.png', fit: BoxFit.contain),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .scale(
                    begin: const Offset(0.7, 0.7),
                    duration: 600.ms,
                    curve: Curves.easeOutBack,
                  ),

              const SizedBox(height: 28),

              // App Name
              Text(
                    'ADULTI',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -1.5,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 400.ms)
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    duration: 500.ms,
                    curve: Curves.easeOutCubic,
                  ),

              const SizedBox(height: 12),

              Text(
                'Your financial life,\nmade clearer.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 600.ms),

              const Spacer(flex: 1),

              _StatsStrip().animate().fadeIn(duration: 500.ms, delay: 800.ms),

              const Spacer(flex: 2),

              if (_isCheckingProfile)
                const SizedBox(
                  width: double.infinity,
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                          context,
                          AppRouter.onboarding,
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.navy,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'GET STARTED',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 1000.ms)
                    .slideY(
                      begin: 0.4,
                      end: 0,
                      duration: 500.ms,
                      delay: 1000.ms,
                      curve: Curves.easeOutCubic,
                    ),

              const SizedBox(height: 12),

              Text(
                'No credit card required',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 1200.ms),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatChip(label: 'Students', value: '2.4K'),
        const SizedBox(width: 10),
        _StatChip(label: 'Debt Slayed', value: '\$1.2M'),
        const SizedBox(width: 10),
        _StatChip(label: 'Vaults Sealed', value: '890'),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.12),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.navy.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
