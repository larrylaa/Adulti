import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/router.dart';
import '../../app/theme.dart';
import '../../services/firestore_database_service.dart';
import '../../widgets/shared/bento_card.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  bool _isRegisterMode = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _normalizedUsername(String value) => value.trim().toLowerCase();

  String _usernameToEmail(String value) =>
      '${_normalizedUsername(value)}@adulti.local';

  Future<void> _submit() async {
    if (_isSubmitting) return;

    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    final username = _normalizedUsername(_usernameController.text);
    final password = _passwordController.text;

    setState(() => _isSubmitting = true);
    try {
      final auth = FirebaseAuth.instance;
      final email = _usernameToEmail(username);

      UserCredential credential;
      if (_isRegisterMode) {
        credential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await credential.user?.updateDisplayName(username);
        await credential.user?.reload();

        final uid = credential.user?.uid;
        if (uid != null) {
          await FirestoreDatabaseService().updateUserStats(uid, {
            'authUsername': username,
            'authEmailAlias': email,
          });
        }
      } else {
        credential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      if (!mounted || credential.user == null) return;
      Navigator.pushReplacementNamed(context, AppRouter.splash);
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Could not sign in.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            children: [
              const Spacer(flex: 1),
              Container(
                    width: 96,
                    height: 96,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.border.withValues(alpha: 0.12),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.navy.withValues(alpha: 0.18),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Image.asset('adultinlogo.png', fit: BoxFit.contain),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 120.ms)
                  .scale(
                    begin: const Offset(0.7, 0.7),
                    duration: 600.ms,
                    curve: Curves.easeOutBack,
                  ),
              const SizedBox(height: 24),
              Text(
                'Welcome to Adulti',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall,
              ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
              const SizedBox(height: 8),
              Text(
                'Sign in with a username and password to save your profile to Firebase.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 280.ms),
              const SizedBox(height: 20),
              BentoCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isRegisterMode
                            ? 'Create your account'
                            : 'Welcome back',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _usernameController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                        ),
                        validator: (value) {
                          final text = value?.trim() ?? '';
                          if (text.isEmpty) {
                            return 'Username is required.';
                          }
                          if (text.length < 3) {
                            return 'Use at least 3 characters.';
                          }
                          if (text.length > 20) {
                            return 'Keep it under 20 characters.';
                          }
                          final valid = RegExp(
                            r'^[a-zA-Z0-9_]+$',
                          ).hasMatch(text);
                          if (!valid) {
                            return 'Use only letters, numbers, and underscore.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        validator: (value) {
                          if ((value ?? '').length < 6) {
                            return 'Password must be at least 6 characters.';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _isRegisterMode
                                  ? 'Already have an account?'
                                  : 'New here?',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: _isSubmitting
                                ? null
                                : () => setState(() {
                                    _isRegisterMode = !_isRegisterMode;
                                  }),
                            child: Text(
                              _isRegisterMode ? 'Sign in' : 'Create one',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 360.ms),
              const Spacer(flex: 1),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_isRegisterMode ? 'Create account' : 'Sign in'),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Firebase Auth uses an internal email alias behind the username.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
