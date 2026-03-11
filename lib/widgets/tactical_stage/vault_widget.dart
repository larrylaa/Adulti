import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/theme.dart';

enum VaultState { open, ajar, locked }

/// 3-state steel safe.
/// open:   door swung 90° — dark cavity visible
/// ajar:   door at 45°    — unlocked, cracked open
/// locked: door shut       — green LED glows, wheel detail
class VaultWidget extends StatelessWidget {
  final double savings;
  final double savingsGoal;

  const VaultWidget({
    super.key,
    required this.savings,
    required this.savingsGoal,
  });

  double get _vaultProgress => (savings / savingsGoal).clamp(0.0, 1.0);

  VaultState get _state {
    if (savings <= 0) return VaultState.open;
    if (savings < savingsGoal) return VaultState.ajar;
    return VaultState.locked;
  }

  @override
  Widget build(BuildContext context) {
    final progress = _vaultProgress;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: _doorAngle),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, angle, _) {
        return CustomPaint(
          size: const Size(72, 80),
          painter: _VaultPainter(
            doorAngle: angle,
            state: _state,
            vaultProgress: progress,
          ),
        );
      },
    );
  }

  double get _doorAngle {
    switch (_state) {
      case VaultState.open:
        return pi / 2; // 90° open
      case VaultState.ajar:
        return pi / 4; // 45° ajar
      case VaultState.locked:
        return 0.0; // fully shut
    }
  }
}

class _VaultPainter extends CustomPainter {
  final double doorAngle;
  final VaultState state;
  final double vaultProgress;

  _VaultPainter({
    required this.doorAngle,
    required this.state,
    required this.vaultProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawBody(canvas, size);
    if (state != VaultState.open) {
      _drawMoneyBills(canvas, size);
    }
    _drawDoor(canvas, size);
    if (state == VaultState.locked) {
      _drawGreenLed(canvas, size);
    }
    _drawWheelDetail(canvas, size);
  }

  void _drawMoneyBills(Canvas canvas, Size size) {
    if (vaultProgress <= 0) return;
    // Cavity bounds: x≈6, y≈6, floor≈y+height-16
    const cavityX = 8.0;
    const cavityFloor = 66.0;
    const billW = 13.0;
    const billH = 5.0;
    const gap = 1.5;
    const maxStack = 40.0;

    final stackH = maxStack * vaultProgress;
    final count = ((stackH / (billH + gap)).ceil()).clamp(1, 7);

    final fillPaint = Paint()..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = const Color(0xFF2E5C3A);

    for (int i = 0; i < count; i++) {
      final y = cavityFloor - (i + 1) * (billH + gap);
      final x = cavityX + (i % 3) * 2.5;
      fillPaint.color = i % 2 == 0
          ? const Color(0xFF4CAF7D)
          : const Color(0xFFD4EDDA);
      final rect = Rect.fromLTWH(x, y, billW, billH);
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(1));
      // Tiny tilt for realism
      canvas.save();
      canvas.translate(x + billW / 2, y + billH / 2);
      canvas.rotate((i % 3 - 1) * 0.03);
      canvas.translate(-(x + billW / 2), -(y + billH / 2));
      canvas.drawRRect(rrect, fillPaint);
      canvas.drawRRect(rrect, strokePaint);
      canvas.restore();
    }
  }

  void _drawBody(Canvas canvas, Size size) {
    // Shadow
    final shadowPaint = Paint()
      ..color = AppColors.navy.withValues(alpha: 0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(4, 6, size.width - 4, size.height - 8),
        const Radius.circular(6),
      ),
      shadowPaint,
    );

    // Body
    final bodyPaint = Paint()..color = const Color(0xFF475569);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width - 2, size.height - 4),
        const Radius.circular(6),
      ),
      bodyPaint,
    );

    // Interior cavity (dark)
    final cavityPaint = Paint()..color = const Color(0xFF0F172A);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(6, 6, size.width - 20, size.height - 16),
        const Radius.circular(4),
      ),
      cavityPaint,
    );

    // Shelf inside
    if (state != VaultState.locked) {
      final shelfPaint = Paint()..color = const Color(0xFF1E293B);
      canvas.drawRect(
        Rect.fromLTWH(8, size.height * 0.5, size.width - 24, 2),
        shelfPaint,
      );
    }
  }

  void _drawDoor(Canvas canvas, Size size) {
    canvas.save();
    // Door hinges at left edge
    canvas.translate(6, 0);
    // Rotate around left edge of door
    canvas.rotate(-doorAngle);

    final doorPaint = Paint()..color = const Color(0xFF64748B);
    final doorWidth = size.width - 14;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 4, doorWidth, size.height - 12),
        const Radius.circular(4),
      ),
      doorPaint,
    );

    // Door highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(3, 7, doorWidth - 6, 8),
        const Radius.circular(2),
      ),
      highlightPaint,
    );

    // Door edge bevel
    final bevelPaint = Paint()
      ..color = const Color(0xFF334155)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(1, 5, doorWidth - 2, size.height - 14),
        const Radius.circular(4),
      ),
      bevelPaint,
    );

    canvas.restore();
  }

  void _drawWheelDetail(Canvas canvas, Size size) {
    final cx = size.width - 14.0;
    final cy = size.height * 0.45;

    final spokePaint = Paint()
      ..color = state == VaultState.locked
          ? const Color(0xFF94A3B8)
          : const Color(0xFF475569)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Outer ring
    canvas.drawCircle(Offset(cx, cy), 9, spokePaint);

    // Spokes
    for (int i = 0; i < 6; i++) {
      final angle = (pi / 3) * i;
      canvas.drawLine(
        Offset(cx + cos(angle) * 4, cy + sin(angle) * 4),
        Offset(cx + cos(angle) * 9, cy + sin(angle) * 9),
        spokePaint,
      );
    }

    // Hub
    final hubPaint = Paint()
      ..color = state == VaultState.locked
          ? const Color(0xFF94A3B8)
          : const Color(0xFF475569);
    canvas.drawCircle(Offset(cx, cy), 3.5, hubPaint);
  }

  void _drawGreenLed(Canvas canvas, Size size) {
    // Glow halo
    final glowPaint = Paint()
      ..color = AppColors.success.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(
      Offset(size.width - 14, size.height * 0.72),
      7,
      glowPaint,
    );

    // LED dot
    final ledPaint = Paint()..color = AppColors.success;
    canvas.drawCircle(Offset(size.width - 14, size.height * 0.72), 4, ledPaint);

    // LED specular
    final specPaint = Paint()..color = Colors.white.withValues(alpha: 0.6);
    canvas.drawCircle(
      Offset(size.width - 15.5, size.height * 0.71),
      1.5,
      specPaint,
    );
  }

  @override
  bool shouldRepaint(_VaultPainter oldDelegate) =>
      oldDelegate.doorAngle != doorAngle ||
      oldDelegate.state != state ||
      oldDelegate.vaultProgress != vaultProgress;
}
