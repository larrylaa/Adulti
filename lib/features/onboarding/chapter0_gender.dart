import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../models/user_stats.dart';
import '../../providers/user_stats_provider.dart';

class Chapter0Gender extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const Chapter0Gender({super.key, required this.onNext});

  @override
  ConsumerState<Chapter0Gender> createState() => _Chapter0GenderState();
}

class _Chapter0GenderState extends ConsumerState<Chapter0Gender> {
  late final TextEditingController _nameController;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: ref.read(userStatsProvider).name ?? '',
    );
    _nameController.addListener(() {
      if (!mounted) return;
      setState(() => _nameError = null);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(userStatsProvider);
    final selectedGender = stats.gender;
    final canContinue =
        _nameController.text.trim().isNotEmpty && selectedGender != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Let\'s set up your profile.',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Tell us a little about you so the app can adapt.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Your Name',
              errorText: _nameError,
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: Row(
              children: [
                Expanded(
                  child: _GenderTile(
                    label: 'Male',
                    symbol: '♂',
                    selected: selectedGender == CharacterGender.male,
                    onTap: () => ref
                        .read(userStatsProvider.notifier)
                        .setGender(CharacterGender.male),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _GenderTile(
                    label: 'Female',
                    symbol: '♀',
                    selected: selectedGender == CharacterGender.female,
                    onTap: () => ref
                        .read(userStatsProvider.notifier)
                        .setGender(CharacterGender.female),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (selectedGender == null)
            Text(
              'Choose a profile to continue.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
            ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: canContinue ? _submit : _validateName,
              child: const Text('CONTINUE'),
            ),
          ),
        ],
      ),
    );
  }

  void _validateName() {
    setState(() {
      _nameError = _nameController.text.trim().isEmpty
          ? 'Name is required.'
          : null;
    });
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _validateName();
      return;
    }

    await ref.read(userStatsProvider.notifier).setName(name);
    widget.onNext();
  }
}

class _GenderTile extends StatelessWidget {
  final String label;
  final String symbol;
  final bool selected;
  final VoidCallback onTap;

  const _GenderTile({
    required this.label,
    required this.symbol,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: selected ? AppColors.navy : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? AppColors.navy
                : AppColors.border.withValues(alpha: 0.15),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              symbol,
              style: TextStyle(
                fontSize: 48,
                color: selected ? Colors.white : AppColors.navy,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: selected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
