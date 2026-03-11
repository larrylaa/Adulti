import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// Translucent wisp/shadow entity hovering behind the character.
/// Visibility and color lerp driven by debt amount and DTI ratio.
class ShadowWidget extends StatelessWidget {
  final double totalDebt;
  final double debtToIncomeRatio; // 0.0 – ∞

  const ShadowWidget({
    super.key,
    required this.totalDebt,
    required this.debtToIncomeRatio,
  });

  double get _opacity {
    if (totalDebt <= 0) return 0.0;
    return (totalDebt / 10000).clamp(0.05, 0.85);
  }

  double get _scale {
    if (totalDebt <= 0) return 0.0;
    return (0.4 + (totalDebt / 20000).clamp(0.0, 0.6));
  }

  Color get _color {
    // Past 30% DTI → lerp to deep amber
    final t = ((debtToIncomeRatio - 0.3) / 0.5).clamp(0.0, 1.0);
    return Color.lerp(
      const Color(0xFFFEF3C7), // amber-100
      const Color(0xFFF59E0B), // amber-500
      t,
    )!;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: _opacity),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, animatedOpacity, _) {
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.4, end: _scale),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
          builder: (context, animatedScale, _) {
            return Opacity(
              opacity: animatedOpacity,
              child: Transform.scale(
                scale: animatedScale,
                child: CustomPaint(
                  size: const Size(100, 130),
                  painter: _ShadowPainter(color: _color),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ShadowPainter extends CustomPainter {
  final Color color;

  _ShadowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.5;

    // Outer glow
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: 70, height: 90),
      glowPaint,
    );

    // Core wisp body — organic teardrop shape
    final wispPaint = Paint()..color = color.withValues(alpha: 0.7);
    final wispPath = Path();
    wispPath.moveTo(cx, size.height * 0.12);
    wispPath.cubicTo(
      cx + 30,
      size.height * 0.12,
      cx + 38,
      size.height * 0.55,
      cx,
      size.height * 0.88,
    );
    wispPath.cubicTo(
      cx - 38,
      size.height * 0.55,
      cx - 30,
      size.height * 0.12,
      cx,
      size.height * 0.12,
    );
    canvas.drawPath(wispPath, wispPaint);

    // Tendrils — small wavy arms
    final tendrilPaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    void drawTendril(double startX, double startY, double dx, double dy) {
      final path = Path()..moveTo(startX, startY);
      path.cubicTo(
        startX + dx * 0.3,
        startY + dy * 0.2,
        startX + dx * 0.7,
        startY + dy * 0.4,
        startX + dx,
        startY + dy,
      );
      canvas.drawPath(path, tendrilPaint);
    }

    drawTendril(cx - 28, size.height * 0.35, -15, -25);
    drawTendril(cx + 28, size.height * 0.35, 15, -25);
    drawTendril(cx - 20, size.height * 0.2, -18, -30);
    drawTendril(cx + 20, size.height * 0.2, 18, -30);

    // Eyes — two glowing slits
    _drawEye(canvas, Offset(cx - 10, cy - 8), color);
    _drawEye(canvas, Offset(cx + 10, cy - 8), color);
  }

  void _drawEye(Canvas canvas, Offset center, Color wispColor) {
    // Glow
    final glowPaint = Paint()
      ..color = AppColors.warning.withValues(alpha: 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 10, height: 5),
      glowPaint,
    );
    // Pupil slit
    final pupilPaint = Paint()..color = const Color(0xFFF59E0B);
    final pupilPath = Path();
    pupilPath.addOval(Rect.fromCenter(center: center, width: 8, height: 3));
    canvas.drawPath(pupilPath, pupilPaint);
  }

  @override
  bool shouldRepaint(_ShadowPainter oldDelegate) => oldDelegate.color != color;
}
