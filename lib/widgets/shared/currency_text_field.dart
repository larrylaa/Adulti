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
      text: _formatInitialAmount(widget.initialValue),
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

  String _formatInitialAmount(double value) {
    if (value <= 0) {
      return '';
    }

    final fixed = value.toStringAsFixed(2);
    if (fixed.endsWith('.00')) {
      return fixed.substring(0, fixed.length - 3);
    }
    if (fixed.endsWith('0')) {
      return fixed.substring(0, fixed.length - 1);
    }
    return fixed;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      autofocus: widget.autofocus,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: const [_CurrencyInputFormatter()],
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

class _CurrencyInputFormatter extends TextInputFormatter {
  const _CurrencyInputFormatter();

  static final _allowed = RegExp('^\\d*\\.?\\d{0,2}\$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) {
      return newValue;
    }

    if (_allowed.hasMatch(text)) {
      return newValue;
    }

    return oldValue;
  }
}
