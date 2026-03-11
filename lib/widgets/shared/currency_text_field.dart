import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme.dart';

class CurrencyTextField extends StatefulWidget {
  final String label;
  final double initialValue;
  final ValueChanged<double> onChanged;
  final String? hint;
  final bool autofocus;

  const CurrencyTextField({
    super.key,
    required this.label,
    required this.onChanged,
    this.initialValue = 0.0,
    this.hint,
    this.autofocus = false,
  });

  @override
  State<CurrencyTextField> createState() => _CurrencyTextFieldState();
}

class _CurrencyTextFieldState extends State<CurrencyTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue > 0
          ? widget.initialValue.toStringAsFixed(2)
          : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChange(String value) {
    HapticFeedback.lightImpact();
    final parsed = double.tryParse(value.replaceAll(',', '')) ?? 0.0;
    widget.onChanged(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      autofocus: widget.autofocus,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
      style: GoogleFonts.spaceGrotesk(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      onChanged: _handleChange,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint ?? '0.00',
        prefixText: '\$ ',
        prefixStyle: GoogleFonts.spaceGrotesk(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
