import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// Holographic blue beam emitting from the character's wrist watch.
/// Visibility scales with total investment balance.
class WatchBeamWidget extends StatelessWidget {
  final double totalInvestments;

  const WatchBeamWidget({super.key, required this.totalInvestments});

  @override
  Widget build(BuildContext context) {
    // Scale opacity: starts faint at $1, full at $50k+
    final opacity = totalInvestments > 0
        ? (totalInvestments / 50000).clamp(0.15, 1.0)
        : 0.0;

    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      child: CustomPaint(
        size: const Size(60, 90),
        painter: _WatchBeamPainter(),
      ),
    );
  }
}

class _WatchBeamPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final beamOriginY = size.height * 0.85;

    // Outer glow cone
    final outerGlow = Paint()
      ..shader = RadialGradient(
        center: Alignment.bottomCenter,
        radius: 1.0,
        colors: [
          AppColors.shadowBlue.withValues(alpha: 0.15),
          AppColors.shadowBlue.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final coneOuterPath = Path()
      ..moveTo(cx - 2, beamOriginY)
      ..lineTo(cx + 2, beamOriginY)
      ..lineTo(cx + size.width * 0.45, 0)
      ..lineTo(cx - size.width * 0.45, 0)
      ..close();
    canvas.drawPath(coneOuterPath, outerGlow);

    // Main beam cone
    final conePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          AppColors.shadowBlue.withValues(alpha: 0.6),
          AppColors.shadowBlue.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final conePath = Path()
      ..moveTo(cx - 2, beamOriginY)
      ..lineTo(cx + 2, beamOriginY)
      ..lineTo(cx + size.width * 0.38, 4)
      ..lineTo(cx - size.width * 0.38, 4)
      ..close();
    canvas.drawPath(conePath, conePaint);

    // Horizontal scan rings
    final ringPaint = Paint()
      ..color = AppColors.shadowBlue.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    for (int i = 1; i <= 5; i++) {
      final t = i / 6.0;
      final y = size.height - beamOriginY + t * beamOriginY;
      final halfW = (2 + size.width * 0.38 * t).clamp(2.0, size.width * 0.4);
      canvas.drawLine(
        Offset(cx - halfW, size.height - y),
        Offset(cx + halfW, size.height - y),
        ringPaint,
      );
    }

    // Holographic data particles
    final particlePaint = Paint()
      ..color = AppColors.shadowBlue.withValues(alpha: 0.7);
    final rng = Random(42);
    for (int i = 0; i < 8; i++) {
      final px = cx + (rng.nextDouble() - 0.5) * size.width * 0.6;
      final py = (rng.nextDouble()) * beamOriginY * 0.8;
      canvas.drawCircle(
        Offset(px, py),
        rng.nextDouble() * 1.5 + 0.5,
        particlePaint,
      );
    }

    // Origin glow dot
    final originGlow = Paint()
      ..color = AppColors.shadowBlue.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(cx, beamOriginY), 6, originGlow);
    final originDot = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx, beamOriginY), 2, originDot);
  }

  @override
  bool shouldRepaint(_WatchBeamPainter oldDelegate) => false;
}
