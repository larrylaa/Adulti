import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/user_stats.dart';
import '../../app/theme.dart';

/// Draws the full-body character with accessories.
/// [rotationAngle] drives a perspective-depth simulation: canvas.scale(cos(angle), 1.0)
/// making the character appear to turn in 3D when the user drags horizontally.
class CharacterWidget extends StatefulWidget {
  final CharacterClass? characterClass;
  final double rotationAngle;

  const CharacterWidget({
    super.key,
    this.characterClass,
    this.rotationAngle = 0.0,
  });

  @override
  State<CharacterWidget> createState() => _CharacterWidgetState();
}

class _CharacterWidgetState extends State<CharacterWidget> {
  late double _angle;

  @override
  void initState() {
    super.initState();
    _angle = widget.rotationAngle;
  }

  @override
  void didUpdateWidget(covariant CharacterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rotationAngle != widget.rotationAngle) {
      _angle = widget.rotationAngle;
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _angle += details.delta.dx * 0.008;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      child: CustomPaint(
        size: const Size(120, 200),
        painter: _CharacterPainter(
          characterClass: widget.characterClass,
          rotationAngle: _angle,
        ),
      ),
    );
  }
}

class _CharacterPainter extends CustomPainter {
  final CharacterClass? characterClass;
  final double rotationAngle;

  _CharacterPainter({this.characterClass, required this.rotationAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    // Apply perspective: scale X by cos(angle), clamped so char stays visible
    final scaleX = cos(rotationAngle).abs().clamp(0.15, 1.0);
    final facingRight = sin(rotationAngle) < 0;

    canvas.save();
    canvas.translate(cx, 0);
    canvas.scale(scaleX * (facingRight ? -1 : 1), 1.0);
    canvas.translate(-cx, 0);

    _drawBody(canvas, size);
    if (characterClass != null) {
      _drawAccessory(canvas, size, characterClass!);
    }

    canvas.restore();
  }

  void _drawBody(Canvas canvas, Size size) {
    final cx = size.width / 2;

    // Shadow beneath feet
    final shadowPaint = Paint()
      ..color = AppColors.navy.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, size.height - 6),
        width: 60,
        height: 12,
      ),
      shadowPaint,
    );

    // Legs
    final legPaint = Paint()..color = const Color(0xFF334155);
    // Left leg
    final leftLegPath = Path()
      ..moveTo(cx - 12, size.height * 0.6)
      ..lineTo(cx - 18, size.height - 8)
      ..lineTo(cx - 10, size.height - 8)
      ..lineTo(cx - 6, size.height * 0.6)
      ..close();
    canvas.drawPath(leftLegPath, legPaint);
    // Right leg
    final rightLegPath = Path()
      ..moveTo(cx + 6, size.height * 0.6)
      ..lineTo(cx + 10, size.height - 8)
      ..lineTo(cx + 18, size.height - 8)
      ..lineTo(cx + 12, size.height * 0.6)
      ..close();
    canvas.drawPath(rightLegPath, legPaint);

    // Shoes
    final shoePaint = Paint()..color = const Color(0xFF0F172A);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(cx - 20, size.height - 10, 14, 8),
        bottomLeft: const Radius.circular(3),
        bottomRight: const Radius.circular(4),
      ),
      shoePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(cx + 8, size.height - 10, 14, 8),
        bottomLeft: const Radius.circular(4),
        bottomRight: const Radius.circular(3),
      ),
      shoePaint,
    );

    // Torso
    final torsoPaint = Paint()..color = const Color(0xFF3B82F6);
    final torsoRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx - 18, size.height * 0.3, 36, size.height * 0.32),
      const Radius.circular(8),
    );
    canvas.drawRRect(torsoRect, torsoPaint);

    // Arms
    final armPaint = Paint()..color = const Color(0xFF2563EB);
    // Left arm
    final leftArmPath = Path()
      ..moveTo(cx - 18, size.height * 0.32)
      ..lineTo(cx - 34, size.height * 0.5)
      ..lineTo(cx - 28, size.height * 0.52)
      ..lineTo(cx - 16, size.height * 0.34)
      ..close();
    canvas.drawPath(leftArmPath, armPaint);
    // Right arm
    final rightArmPath = Path()
      ..moveTo(cx + 18, size.height * 0.32)
      ..lineTo(cx + 34, size.height * 0.5)
      ..lineTo(cx + 28, size.height * 0.52)
      ..lineTo(cx + 16, size.height * 0.34)
      ..close();
    canvas.drawPath(rightArmPath, armPaint);

    // Hands
    final handPaint = Paint()..color = const Color(0xFFF5CBA7);
    canvas.drawCircle(Offset(cx - 29, size.height * 0.52), 5, handPaint);
    canvas.drawCircle(Offset(cx + 29, size.height * 0.52), 5, handPaint);

    // Neck
    final neckPaint = Paint()..color = const Color(0xFFF5CBA7);
    canvas.drawRect(
      Rect.fromLTWH(cx - 6, size.height * 0.24, 12, size.height * 0.08),
      neckPaint,
    );

    // Head
    final headPaint = Paint()..color = const Color(0xFFF5CBA7);
    canvas.drawCircle(Offset(cx, size.height * 0.2), 22, headPaint);

    // Eyes
    final eyePaint = Paint()..color = const Color(0xFF0F172A);
    canvas.drawCircle(Offset(cx - 8, size.height * 0.18), 3, eyePaint);
    canvas.drawCircle(Offset(cx + 8, size.height * 0.18), 3, eyePaint);

    // Smile
    final smilePaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(cx, size.height * 0.22),
        width: 14,
        height: 8,
      ),
      0,
      pi,
      false,
      smilePaint,
    );

    // Hair
    final hairPaint = Paint()..color = const Color(0xFF1E293B);
    final hairPath = Path()
      ..addArc(
        Rect.fromCenter(
          center: Offset(cx, size.height * 0.2),
          width: 44,
          height: 44,
        ),
        pi,
        pi,
      )
      ..lineTo(cx + 22, size.height * 0.16)
      ..close();
    canvas.drawPath(hairPath, hairPaint);
  }

  void _drawAccessory(Canvas canvas, Size size, CharacterClass cls) {
    final cx = size.width / 2;

    switch (cls) {
      case CharacterClass.student:
        _drawMessengerBag(canvas, size, cx);
      case CharacterClass.graduate:
        _drawMessengerBag(canvas, size, cx);
        _drawGraduationTassel(canvas, size, cx);
      case CharacterClass.professional:
        _drawBlazer(canvas, size, cx);
        _drawWatch(canvas, size, cx);
    }
  }

  void _drawMessengerBag(Canvas canvas, Size size, double cx) {
    final bagPaint = Paint()..color = const Color(0xFF92400E);
    final bagRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx + 16, size.height * 0.38, 20, 16),
      const Radius.circular(4),
    );
    canvas.drawRRect(bagRect, bagPaint);
    // Strap
    final strapPaint = Paint()
      ..color = const Color(0xFF78350F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawLine(
      Offset(cx + 18, size.height * 0.31),
      Offset(cx + 36, size.height * 0.38),
      strapPaint,
    );
    // Flap
    final flapPaint = Paint()..color = const Color(0xFFB45309);
    final flapPath = Path()
      ..moveTo(cx + 16, size.height * 0.38)
      ..lineTo(cx + 36, size.height * 0.38)
      ..lineTo(cx + 36, size.height * 0.43)
      ..quadraticBezierTo(
        cx + 26,
        size.height * 0.46,
        cx + 16,
        size.height * 0.43,
      )
      ..close();
    canvas.drawPath(flapPath, flapPaint);
  }

  void _drawGraduationTassel(Canvas canvas, Size size, double cx) {
    // Tassel string
    final tasselPaint = Paint()
      ..color = const Color(0xFFD97706)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(cx + 22, size.height * 0.35),
      Offset(cx + 22, size.height * 0.48),
      tasselPaint,
    );
    // Tassel tip
    final tipPaint = Paint()..color = const Color(0xFFF59E0B);
    canvas.drawCircle(Offset(cx + 22, size.height * 0.49), 3, tipPaint);
    // Tassel threads
    for (int i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(cx + 22, size.height * 0.49),
        Offset(cx + 18 + i * 3.0, size.height * 0.54),
        tasselPaint..strokeWidth = 1.0,
      );
    }
  }

  void _drawBlazer(Canvas canvas, Size size, double cx) {
    final blazerPaint = Paint()..color = const Color(0xFF1E3A5F);
    // Left lapel
    final leftLapel = Path()
      ..moveTo(cx - 18, size.height * 0.30)
      ..lineTo(cx - 2, size.height * 0.36)
      ..lineTo(cx - 2, size.height * 0.62)
      ..lineTo(cx - 18, size.height * 0.62)
      ..close();
    canvas.drawPath(leftLapel, blazerPaint);
    // Right lapel
    final rightLapel = Path()
      ..moveTo(cx + 18, size.height * 0.30)
      ..lineTo(cx + 2, size.height * 0.36)
      ..lineTo(cx + 2, size.height * 0.62)
      ..lineTo(cx + 18, size.height * 0.62)
      ..close();
    canvas.drawPath(rightLapel, blazerPaint);
    // Collar notch
    final collarPaint = Paint()..color = Colors.white;
    final leftCollar = Path()
      ..moveTo(cx - 2, size.height * 0.31)
      ..lineTo(cx - 8, size.height * 0.36)
      ..lineTo(cx - 2, size.height * 0.38)
      ..close();
    canvas.drawPath(leftCollar, collarPaint);
    final rightCollar = Path()
      ..moveTo(cx + 2, size.height * 0.31)
      ..lineTo(cx + 8, size.height * 0.36)
      ..lineTo(cx + 2, size.height * 0.38)
      ..close();
    canvas.drawPath(rightCollar, collarPaint);
    // Button
    final btnPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx, size.height * 0.47), 2, btnPaint);
    canvas.drawCircle(Offset(cx, size.height * 0.53), 2, btnPaint);
  }

  void _drawWatch(Canvas canvas, Size size, double cx) {
    // Watch band
    final bandPaint = Paint()..color = const Color(0xFF0F172A);
    canvas.drawRect(
      Rect.fromLTWH(cx + 23, size.height * 0.49, 9, 7),
      bandPaint,
    );
    // Watch face
    final watchFacePaint = Paint()..color = const Color(0xFF1E3A5F);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + 22, size.height * 0.48, 11, 9),
        const Radius.circular(2),
      ),
      watchFacePaint,
    );
    // Watch crystal
    final crystalPaint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.6);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + 23.5, size.height * 0.49, 8, 7),
        const Radius.circular(1.5),
      ),
      crystalPaint,
    );
  }

  @override
  bool shouldRepaint(_CharacterPainter oldDelegate) =>
      oldDelegate.characterClass != characterClass ||
      oldDelegate.rotationAngle != rotationAngle;
}
