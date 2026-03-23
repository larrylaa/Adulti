import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/router.dart';
import '../../app/theme.dart';
import '../../providers/user_stats_provider.dart';
import '../../services/firestore_database_service.dart';
import '../../widgets/shared/bento_card.dart';
import '../../widgets/tactical_stage/character_widget.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(userStatsProvider);
    final notifier = ref.read(userStatsProvider.notifier);
    final user = FirebaseAuth.instance.currentUser;
    final username = user?.displayName ?? user?.email?.split('@').first ?? 'Unknown';
    final accountAlias = user?.email ?? 'Not set';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          children: [
            Text('Profile', style: Theme.of(context).textTheme.displaySmall)
                .animate()
                .fadeIn(duration: 300.ms)
                .slideY(begin: 0.2, end: 0, duration: 300.ms),
            const SizedBox(height: 4),
            Text(
              'Update your character, finances, and account settings in one place.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ).animate().fadeIn(duration: 300.ms, delay: 80.ms),
            const SizedBox(height: 18),
            BentoCard(
              child: Column(
                children: [
                  CharacterWidget(
                    characterClass: stats.characterClass,
                    gender: stats.gender,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    stats.name?.isNotEmpty == true ? stats.name! : 'Your Profile',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stats.characterClass?.displayName ?? 'Choose your path',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonal(
                      onPressed: () => _confirmOpenSetupEditor(context),
                      child: const Text('Edit Character'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            BentoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your Firebase sign-in and account controls live here.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _AccountInfoRow(label: 'Username', value: username),
                  const SizedBox(height: 8),
                  _AccountInfoRow(label: 'Firebase email alias', value: accountAlias),
                  const SizedBox(height: 12),
                  _ActionOption(
                    icon: Icons.badge_outlined,
                    title: 'Change username',
                    subtitle: 'Update the sign-in alias and display name.',
                    onTap: () => _changeUsername(context),
                  ),
                  const SizedBox(height: 10),
                  _ActionOption(
                    icon: Icons.password_rounded,
                    title: 'Change password',
                    subtitle: 'Update the Firebase password for this account.',
                    onTap: () => _changePassword(context),
                  ),
                  const SizedBox(height: 10),
                  _ActionOption(
                    icon: Icons.logout_rounded,
                    title: 'Sign out',
                    subtitle: 'Return to the Firebase sign-in screen.',
                    onTap: () => _signOut(context, ref),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _confirmResetCharacter(context, notifier),
                      child: const Text('Reset character'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _ActionOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.12)),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textSecondary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                onTap == null ? 'Soon' : 'Now',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _AccountInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _signOut(BuildContext context, WidgetRef ref) async {
  await FirebaseAuth.instance.signOut();
  ref.invalidate(userStatsProvider);
  if (!context.mounted) return;
  Navigator.pushNamedAndRemoveUntil(context, AppRouter.auth, (route) => false);
}

Future<void> _confirmOpenSetupEditor(BuildContext context) async {
  final shouldOpen = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Open setup editor?'),
        content: const Text(
          'This takes you back into the onboarding-style editor. You can cancel here and stay on Profile.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Continue'),
          ),
        ],
      );
    },
  );

  if (shouldOpen == true && context.mounted) {
    Navigator.pushReplacementNamed(context, AppRouter.onboarding);
  }
}

Future<void> _changeUsername(BuildContext context) async {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final shouldUpdate = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Change username'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'New username'),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.length < 3) return 'Use at least 3 characters.';
                  if (text.length > 20) return 'Keep it under 20 characters.';
                  if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(text)) {
                    return 'Use only letters, numbers, and underscore.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Current password'),
                validator: (value) {
                  if ((value ?? '').length < 6) {
                    return 'Enter your current password.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.pop(dialogContext, true);
              }
            },
            child: const Text('Update'),
          ),
        ],
      );
    },
  );

  if (shouldUpdate != true || !context.mounted) return;

  final user = FirebaseAuth.instance.currentUser;
  if (user == null || user.email == null) return;

  final newUsername = usernameController.text.trim().toLowerCase();
  final newEmail = '$newUsername@adulti.local';
  final credential = EmailAuthProvider.credential(
    email: user.email!,
    password: passwordController.text,
  );

  await user.reauthenticateWithCredential(credential);
  // ignore: deprecated_member_use
  await user.updateEmail(newEmail);
  await user.updateDisplayName(newUsername);
  await user.reload();

  await FirestoreDatabaseService().updateUserStats(user.uid, {
    'authUsername': newUsername,
    'authEmailAlias': newEmail,
  });

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Username updated.')),
    );
  }
}

Future<void> _changePassword(BuildContext context) async {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final shouldUpdate = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Change password'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Current password'),
                validator: (value) {
                  if ((value ?? '').length < 6) return 'Enter your current password.';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New password'),
                validator: (value) {
                  if ((value ?? '').length < 6) return 'Use at least 6 characters.';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.pop(dialogContext, true);
              }
            },
            child: const Text('Update'),
          ),
        ],
      );
    },
  );

  if (shouldUpdate != true || !context.mounted) return;

  final user = FirebaseAuth.instance.currentUser;
  if (user == null || user.email == null) return;

  final credential = EmailAuthProvider.credential(
    email: user.email!,
    password: currentPasswordController.text,
  );

  await user.reauthenticateWithCredential(credential);
  await user.updatePassword(newPasswordController.text);

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password updated.')),
    );
  }
}

Future<void> _confirmResetCharacter(
  BuildContext context,
  UserStatsNotifier notifier,
) async {
  final shouldReset = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Reset character?'),
        content: const Text(
          'This clears your current profile and returns you to setup. You can rebuild your character from scratch after this.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Reset'),
          ),
        ],
      );
    },
  );

  if (shouldReset == true && context.mounted) {
    await notifier.reset();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, AppRouter.onboarding);
    }
  }
}
