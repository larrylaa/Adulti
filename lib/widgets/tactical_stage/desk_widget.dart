import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// White desk with cash stacks that grow linearly with [checking] balance.
/// 0:       empty desk
/// 1–499:   loose bills scattered on surface
/// 500+:    neatly banded green stacks; height scales with balance
class DeskWidget extends StatelessWidget {
  final double checking;

  const DeskWidget({super.key, required this.checking});

  @override
  Widget build(BuildContext context) {
    final stackFraction = ((checking - 500) / 4500).clamp(0.0, 1.0);
    final hasLooseBills = checking >= 1 && checking < 500;
    final hasStacks = checking >= 500;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: stackFraction),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, animatedFraction, _) {
        return CustomPaint(
          size: const Size(90, 68),
          painter: _DeskPainter(
            stackFraction: animatedFraction,
            hasLooseBills: hasLooseBills,
            hasStacks: hasStacks,
          ),
        );
      },
    );
  }
}

class _DeskPainter extends CustomPainter {
  final double stackFraction;
  final bool hasLooseBills;
  final bool hasStacks;

  _DeskPainter({
    required this.stackFraction,
    required this.hasLooseBills,
    required this.hasStacks,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawDesk(canvas, size);
    if (hasLooseBills) {
      _drawLooseBills(canvas, size);
    } else if (hasStacks) {
      _drawCashStacks(canvas, size, stackFraction);
    }
  }

  void _drawDesk(Canvas canvas, Size size) {
    // Desk shadow
    final shadowPaint = Paint()
      ..color = AppColors.navy.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(4, size.height * 0.45, size.width - 4, size.height * 0.6),
        const Radius.circular(4),
      ),
      shadowPaint,
    );

    // Desk top surface
    final topPaint = Paint()..color = AppColors.surface;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size.height * 0.42, size.width - 2, 10),
        const Radius.circular(3),
      ),
      topPaint,
    );

    // Desk front face
    final facePaint = Paint()..color = const Color(0xFFF1F5F9);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          2,
          size.height * 0.52,
          size.width - 6,
          size.height * 0.35,
        ),
        const Radius.circular(3),
      ),
      facePaint,
    );

    // Desk border
    final borderPaint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          0,
          size.height * 0.42,
          size.width - 2,
          size.height * 0.46,
        ),
        const Radius.circular(3),
      ),
      borderPaint,
    );

    // Leg left
    final legPaint = Paint()..color = const Color(0xFFE2E8F0);
    canvas.drawRect(
      Rect.fromLTWH(4, size.height * 0.86, 8, size.height * 0.14),
      legPaint,
    );
    // Leg right
    canvas.drawRect(
      Rect.fromLTWH(size.width - 14, size.height * 0.86, 8, size.height * 0.14),
      legPaint,
    );
  }

  void _drawLooseBills(Canvas canvas, Size size) {
    final billPaint = Paint()..color = const Color(0xFF86EFAC);
    final billBorder = Paint()
      ..color = AppColors.success.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // Draw 4 scattered bills
    final bills = [
      Rect.fromLTWH(8, size.height * 0.28, 20, 9),
      Rect.fromLTWH(22, size.height * 0.30, 22, 9),
      Rect.fromLTWH(14, size.height * 0.22, 18, 8),
      Rect.fromLTWH(38, size.height * 0.27, 20, 9),
    ];

    for (final bill in bills) {
      canvas.save();
      final center = bill.center;
      canvas.translate(center.dx, center.dy);
      canvas.rotate(0.08 * (bills.indexOf(bill) % 2 == 0 ? 1 : -1));
      canvas.translate(-center.dx, -center.dy);
      canvas.drawRRect(
        RRect.fromRectAndRadius(bill, const Radius.circular(2)),
        billPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(bill, const Radius.circular(2)),
        billBorder,
      );
      canvas.restore();
    }
  }

  void _drawCashStacks(Canvas canvas, Size size, double fraction) {
    final maxStackH = size.height * 0.36;
    final stackH = (maxStackH * (0.2 + fraction * 0.8)).clamp(8.0, maxStackH);
    final stackTop = size.height * 0.42 - stackH;

    final positions = [10.0, 30.0, 52.0];
    final widths = [18.0, 16.0, 18.0];

    for (int i = 0; i < positions.length; i++) {
      _drawSingleStack(canvas, positions[i], stackTop, widths[i], stackH, i);
    }
  }

  void _drawSingleStack(
    Canvas canvas,
    double x,
    double top,
    double w,
    double h,
    int idx,
  ) {
    // Stack body
    final stackPaint = Paint()..color = const Color(0xFF4ADE80);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, top, w, h),
        const Radius.circular(2),
      ),
      stackPaint,
    );

    // Stack band (money band)
    final bandPaint = Paint()..color = const Color(0xFFD97706);
    final bandY = top + h * 0.5 - 2;
    canvas.drawRect(Rect.fromLTWH(x, bandY, w, 4), bandPaint);

    // Top highlight
    final highlightPaint = Paint()..color = Colors.white.withValues(alpha: 0.3);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + 1, top + 1, w - 2, 4),
        const Radius.circular(1),
      ),
      highlightPaint,
    );

    // Bill line details
    final linePaint = Paint()
      ..color = AppColors.success.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    for (int j = 0; j < 3; j++) {
      final lineY = top + (j + 1) * (h / 4);
      if (lineY < top + h - 4) {
        canvas.drawLine(
          Offset(x + 2, lineY),
          Offset(x + w - 2, lineY),
          linePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_DeskPainter oldDelegate) =>
      oldDelegate.stackFraction != stackFraction ||
      oldDelegate.hasLooseBills != hasLooseBills ||
      oldDelegate.hasStacks != hasStacks;
}
