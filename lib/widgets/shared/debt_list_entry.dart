import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/debt_entry.dart';
import '../../app/theme.dart';

class DebtListEntry extends StatefulWidget {
  final DebtEntry entry;
  final ValueChanged<DebtEntry> onChanged;
  final VoidCallback onDelete;

  const DebtListEntry({
    super.key,
    required this.entry,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<DebtListEntry> createState() => _DebtListEntryState();
}

class _DebtListEntryState extends State<DebtListEntry> {
  late final TextEditingController _labelController;
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.entry.label);
    _amountController = TextEditingController(
      text: widget.entry.amount > 0
          ? widget.entry.amount.toStringAsFixed(2)
          : '',
    );
  }

  @override
  void dispose() {
    _labelController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.12),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Type pill toggle
              _TypeToggle(
                selected: widget.entry.type,
                onChanged: (t) {
                  widget.onChanged(widget.entry.copyWith(type: t));
                },
              ),
              const SizedBox(width: 10),
              // Label
              Expanded(
                child: TextFormField(
                  controller: _labelController,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g. Chase Sapphire',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.border.withValues(alpha: 0.15),
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.border.withValues(alpha: 0.15),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.navy,
                        width: 1.5,
                      ),
                    ),
                  ),
                  onChanged: (v) {
                    HapticFeedback.lightImpact();
                    widget.onChanged(widget.entry.copyWith(label: v));
                  },
                ),
              ),
              const SizedBox(width: 10),
              // Delete
              GestureDetector(
                onTap: widget.onDelete,
                child: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Amount
          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
            ],
            style: GoogleFonts.spaceGrotesk(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: '0.00',
              prefixText: '\$ ',
              prefixStyle: GoogleFonts.spaceGrotesk(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.15),
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.15),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.navy, width: 1.5),
              ),
            ),
            onChanged: (v) {
              HapticFeedback.lightImpact();
              final parsed = double.tryParse(v) ?? 0.0;
              widget.onChanged(widget.entry.copyWith(amount: parsed));
            },
          ),
        ],
      ),
    );
  }
}

class _TypeToggle extends StatelessWidget {
  final DebtType selected;
  final ValueChanged<DebtType> onChanged;

  const _TypeToggle({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: DebtType.values.map((t) {
        final isSelected = t == selected;
        return GestureDetector(
          onTap: () => onChanged(t),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.navy : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isSelected
                    ? AppColors.navy
                    : AppColors.border.withValues(alpha: 0.25),
              ),
            ),
            child: Text(
              t == DebtType.creditCard ? 'Card' : 'Loan',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
