import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/user_stats.dart';
import '../../app/theme.dart';

/// Full-body character with 3D gradient shading, class accessories, gender hair.
/// Drag left/right to spin (cos(angle) perspective scale).
class CharacterWidget extends StatefulWidget {
  final CharacterClass? characterClass;
  final CharacterGender? gender;
  final double rotationAngle;

  const CharacterWidget({
    super.key,
    this.characterClass,
    this.gender,
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
          gender: widget.gender,
          rotationAngle: _angle,
        ),
      ),
    );
  }
}

class _CharacterPainter extends CustomPainter {
  final CharacterClass? characterClass;
  final CharacterGender? gender;
  final double rotationAngle;

  _CharacterPainter({
    this.characterClass,
    this.gender,
    required this.rotationAngle,
  });

  // ── Palette ────────────────────────────────────────────────────────────────
  static const _skinBase = Color(0xFFF5CBA7);
  static const _skinLight = Color(0xFFFFF5E6);
  static const _skinShadow = Color(0xFFD4A574);
  static const _shirtLight = Color(0xFF93C5FD);
  static const _shirtBase = Color(0xFF3B82F6);
  static const _shirtDark = Color(0xFF1E40AF);
  static const _pantsLight = Color(0xFF6B7280);
  static const _pantsBase = Color(0xFF374151);
  static const _pantsDark = Color(0xFF111827);
  static const _shoeBase = Color(0xFF0F172A);
  static const _shoeHighlight = Color(0xFF334155);
  static const _hairBase = Color(0xFF1E293B);
  static const _hairShine = Color(0xFF334155);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final scaleX = cos(rotationAngle).abs().clamp(0.15, 1.0);
    final facingRight = sin(rotationAngle) < 0;

    canvas.save();
    canvas.translate(cx, 0);
    canvas.scale(scaleX * (facingRight ? -1 : 1), 1.0);
    canvas.translate(-cx, 0);

    _drawShadow(canvas, size, cx);
    _drawLegs(canvas, size, cx);
    _drawShoes(canvas, size, cx);
    _drawTorso(canvas, size, cx);
    _drawArms(canvas, size, cx);
    _drawHands(canvas, size, cx);
    _drawNeck(canvas, size, cx);
    _drawHead(canvas, size, cx);
    _drawHair(canvas, size, cx, gender);
    _drawFace(canvas, size, cx);
    if (characterClass != null) {
      _drawAccessory(canvas, size, cx, characterClass!);
    }

    canvas.restore();
  }

  // ── Ground shadow ───────────────────────────────────────────────────────────
  void _drawShadow(Canvas canvas, Size size, double cx) {
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, size.height - 6),
        width: 70,
        height: 14,
      ),
      Paint()
        ..color = AppColors.navy.withValues(alpha: 0.10)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
  }

  // ── Legs ──────────────────────────────────────────────────────────────────
  void _drawLegs(Canvas canvas, Size size, double cx) {
    final rect = Rect.fromLTWH(
      cx - 26,
      size.height * 0.55,
      52,
      size.height * 0.42,
    );
    final shader = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [_pantsLight, _pantsBase, _pantsDark],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(rect);
    final paint = Paint()..shader = shader;

    // Left leg (wider)
    final leftLeg = Path()
      ..moveTo(cx - 16, size.height * 0.60)
      ..lineTo(cx - 22, size.height - 10)
      ..lineTo(cx - 12, size.height - 10)
      ..lineTo(cx - 6, size.height * 0.60)
      ..close();
    canvas.drawPath(leftLeg, paint);

    // Right leg (wider)
    final rightLeg = Path()
      ..moveTo(cx + 6, size.height * 0.60)
      ..lineTo(cx + 12, size.height - 10)
      ..lineTo(cx + 22, size.height - 10)
      ..lineTo(cx + 16, size.height * 0.60)
      ..close();
    canvas.drawPath(rightLeg, paint);

    // Centre seam highlight
    canvas.drawLine(
      Offset(cx - 3, size.height * 0.60),
      Offset(cx - 5, size.height - 10),
      Paint()
        ..color = _pantsLight.withValues(alpha: 0.35)
        ..strokeWidth = 1.2,
    );
    canvas.drawLine(
      Offset(cx + 3, size.height * 0.60),
      Offset(cx + 5, size.height - 10),
      Paint()
        ..color = _pantsLight.withValues(alpha: 0.35)
        ..strokeWidth = 1.2,
    );
  }

  // ── Shoes ────────────────────────────────────────────────────────────────
  void _drawShoes(Canvas canvas, Size size, double cx) {
    // Left shoe (wider + repositioned)
    final leftShoeRect = Rect.fromLTWH(cx - 26, size.height - 12, 18, 9);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        leftShoeRect,
        bottomLeft: const Radius.circular(3),
        bottomRight: const Radius.circular(4),
      ),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_shoeHighlight, _shoeBase],
        ).createShader(leftShoeRect),
    );
    // Left shoe toe highlight
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(cx - 21, size.height - 11, 7, 3),
        topLeft: const Radius.circular(2),
        topRight: const Radius.circular(2),
      ),
      Paint()..color = _shoeHighlight.withValues(alpha: 0.4),
    );

    // Right shoe (wider + repositioned)
    final rightShoeRect = Rect.fromLTWH(cx + 8, size.height - 12, 18, 9);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rightShoeRect,
        bottomLeft: const Radius.circular(4),
        bottomRight: const Radius.circular(3),
      ),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_shoeHighlight, _shoeBase],
        ).createShader(rightShoeRect),
    );
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(cx + 9, size.height - 11, 7, 3),
        topLeft: const Radius.circular(2),
        topRight: const Radius.circular(2),
      ),
      Paint()..color = _shoeHighlight.withValues(alpha: 0.4),
    );
  }

  // ── Torso ────────────────────────────────────────────────────────────────
  void _drawTorso(Canvas canvas, Size size, double cx) {
    // Wider torso for more body mass
    final torsoRect = Rect.fromLTWH(
      cx - 24,
      size.height * 0.30,
      48,
      size.height * 0.32,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(torsoRect, const Radius.circular(8)),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [_shirtLight, _shirtBase, _shirtDark],
          stops: const [0.0, 0.4, 1.0],
        ).createShader(torsoRect),
    );

    // Chest highlight — top centre light source
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx - 6, size.height * 0.34),
        width: 14,
        height: 10,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.25),
    );

    // Torso left-edge highlight
    canvas.drawLine(
      Offset(cx - 23, size.height * 0.32),
      Offset(cx - 23, size.height * 0.60),
      Paint()
        ..color = _shirtLight.withValues(alpha: 0.6)
        ..strokeWidth = 2.0,
    );
  }

  // ── Arms ────────────────────────────────────────────────────────────────
  void _drawArms(Canvas canvas, Size size, double cx) {
    final armRect = Rect.fromLTWH(
      cx - 42,
      size.height * 0.30,
      84,
      size.height * 0.26,
    );
    final armShader = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [_shirtLight, _shirtBase, _shirtDark],
    ).createShader(armRect);

    // Left arm (thicker)
    final leftArm = Path()
      ..moveTo(cx - 24, size.height * 0.32)
      ..lineTo(cx - 40, size.height * 0.50)
      ..lineTo(cx - 32, size.height * 0.54)
      ..lineTo(cx - 20, size.height * 0.36)
      ..close();
    canvas.drawPath(leftArm, Paint()..shader = armShader);
    // Left arm highlight
    canvas.drawLine(
      Offset(cx - 24, size.height * 0.32),
      Offset(cx - 38, size.height * 0.49),
      Paint()
        ..color = _shirtLight.withValues(alpha: 0.45)
        ..strokeWidth = 1.5,
    );

    // Right arm (thicker)
    final rightArm = Path()
      ..moveTo(cx + 24, size.height * 0.32)
      ..lineTo(cx + 40, size.height * 0.50)
      ..lineTo(cx + 32, size.height * 0.54)
      ..lineTo(cx + 20, size.height * 0.36)
      ..close();
    canvas.drawPath(rightArm, Paint()..shader = armShader);
  }

  // ── Hands ────────────────────────────────────────────────────────────────
  void _drawHands(Canvas canvas, Size size, double cx) {
    final handRect = Rect.fromLTWH(cx - 40, size.height * 0.49, 80, 14);
    final handShader = RadialGradient(
      center: const Alignment(-0.3, -0.3),
      colors: [_skinLight, _skinBase, _skinShadow],
    ).createShader(handRect);
    canvas.drawCircle(
      Offset(cx - 36, size.height * 0.52),
      6.0,
      Paint()..shader = handShader,
    );
    canvas.drawCircle(
      Offset(cx + 36, size.height * 0.52),
      6.0,
      Paint()..shader = handShader,
    );
  }

  // ── Neck ────────────────────────────────────────────────────────────────
  void _drawNeck(Canvas canvas, Size size, double cx) {
    final neckRect = Rect.fromLTWH(
      cx - 8,
      size.height * 0.24,
      16,
      size.height * 0.08,
    );
    canvas.drawRect(
      neckRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [_skinLight, _skinBase, _skinShadow],
        ).createShader(neckRect),
    );
  }

  // ── Head ────────────────────────────────────────────────────────────────
  void _drawHead(Canvas canvas, Size size, double cx) {
    final headRect = Rect.fromCircle(
      center: Offset(cx, size.height * 0.18),
      radius: 25,
    );
    canvas.drawCircle(
      Offset(cx, size.height * 0.18),
      25,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.4),
          radius: 0.85,
          colors: [_skinLight, _skinBase, _skinShadow],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(headRect),
    );
  }

  // ── Hair ────────────────────────────────────────────────────────────────
  void _drawHair(Canvas canvas, Size size, double cx, CharacterGender? gender) {
    if (gender == CharacterGender.female) {
      // Female: long wavy hair framing face + ponytail
      final hairPaint = Paint()..color = _hairBase;
      // Head cap
      final cap = Path()
        ..addArc(
          Rect.fromCenter(
            center: Offset(cx, size.height * 0.18),
            width: 50,
            height: 50,
          ),
          pi,
          pi,
        )
        ..lineTo(cx + 25, size.height * 0.13)
        ..close();
      canvas.drawPath(cap, hairPaint);

      // Left side lock down to shoulder
      final leftLock = Path()
        ..moveTo(cx - 22, size.height * 0.15)
        ..quadraticBezierTo(
          cx - 30,
          size.height * 0.30,
          cx - 26,
          size.height * 0.42,
        );
      canvas.drawPath(
        leftLock,
        Paint()
          ..color = _hairBase
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7
          ..strokeCap = StrokeCap.round,
      );
      // Left lock shine
      canvas.drawPath(
        leftLock,
        Paint()
          ..color = _hairShine.withValues(alpha: 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );

      // Right side lock
      final rightLock = Path()
        ..moveTo(cx + 22, size.height * 0.15)
        ..quadraticBezierTo(
          cx + 30,
          size.height * 0.30,
          cx + 26,
          size.height * 0.42,
        );
      canvas.drawPath(
        rightLock,
        Paint()
          ..color = _hairBase
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawPath(
        rightLock,
        Paint()
          ..color = _hairShine.withValues(alpha: 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );

      // Ponytail at back-right
      final ponytail = Path()
        ..moveTo(cx + 20, size.height * 0.14)
        ..quadraticBezierTo(
          cx + 36,
          size.height * 0.22,
          cx + 32,
          size.height * 0.35,
        );
      canvas.drawPath(
        ponytail,
        Paint()
          ..color = _hairBase
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round,
      );
      // Ponytail tie dot
      canvas.drawCircle(
        Offset(cx + 31, size.height * 0.35),
        4,
        Paint()..color = const Color(0xFFEC4899),
      );
    } else {
      // Male: short classic hair
      final hairPaint = Paint()..color = _hairBase;
      final cap = Path()
        ..addArc(
          Rect.fromCenter(
            center: Offset(cx, size.height * 0.18),
            width: 50,
            height: 50,
          ),
          pi,
          pi,
        )
        ..lineTo(cx + 25, size.height * 0.15)
        ..close();
      canvas.drawPath(cap, hairPaint);

      // Hair shine
      canvas.drawPath(
        cap,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_hairShine.withValues(alpha: 0.3), Colors.transparent],
          ).createShader(Rect.fromLTWH(cx - 23, size.height * 0.06, 46, 26))
          ..blendMode = BlendMode.srcOver,
      );
    }
  }

  // ── Face ────────────────────────────────────────────────────────────────
  void _drawFace(Canvas canvas, Size size, double cx) {
    final eyePaint = Paint()..color = const Color(0xFF0F172A);

    // Eyes
    canvas.drawCircle(Offset(cx - 8, size.height * 0.175), 3.2, eyePaint);
    canvas.drawCircle(Offset(cx + 8, size.height * 0.175), 3.2, eyePaint);

    // Eye shine
    final shinePaint = Paint()..color = Colors.white.withValues(alpha: 0.7);
    canvas.drawCircle(Offset(cx - 7, size.height * 0.170), 1.2, shinePaint);
    canvas.drawCircle(Offset(cx + 9, size.height * 0.170), 1.2, shinePaint);

    // Female eyelashes
    if (gender == CharacterGender.female) {
      final lashPaint = Paint()
        ..color = const Color(0xFF0F172A)
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round;
      for (int i = 0; i < 3; i++) {
        final lx = (cx - 10) + i * 2.0;
        canvas.drawLine(
          Offset(lx, size.height * 0.165),
          Offset(lx - 0.5, size.height * 0.157),
          lashPaint,
        );
        final rx = (cx + 6) + i * 2.0;
        canvas.drawLine(
          Offset(rx, size.height * 0.165),
          Offset(rx - 0.5, size.height * 0.157),
          lashPaint,
        );
      }
    }

    // Smile
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(cx, size.height * 0.21),
        width: 14,
        height: 8,
      ),
      0,
      pi,
      false,
      Paint()
        ..color = const Color(0xFF0F172A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );

    // Nose dot
    canvas.drawCircle(
      Offset(cx, size.height * 0.195),
      1.2,
      Paint()..color = _skinShadow.withValues(alpha: 0.6),
    );
  }

  // ── Accessories ──────────────────────────────────────────────────────────
  void _drawAccessory(Canvas canvas, Size size, double cx, CharacterClass cls) {
    switch (cls) {
      case CharacterClass.student:
        _drawBackpack(canvas, size, cx);
      case CharacterClass.graduate:
        _drawBackpack(canvas, size, cx);
        _drawGraduationCap(canvas, size, cx);
      case CharacterClass.professional:
        _drawBlazer(canvas, size, cx);
        _drawWatch(canvas, size, cx);
    }
  }

  // ── Backpack (Student + Graduate) ────────────────────────────────────────
  void _drawBackpack(Canvas canvas, Size size, double cx) {
    final bagRect = Rect.fromLTWH(cx + 14, size.height * 0.31, 22, 28);
    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(bagRect, const Radius.circular(5)),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFFB45309), const Color(0xFF92400E)],
        ).createShader(bagRect),
    );
    // Body edge highlight
    canvas.drawRRect(
      RRect.fromRectAndRadius(bagRect, const Radius.circular(5)),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Front pocket
    final pocketRect = Rect.fromLTWH(cx + 16, size.height * 0.31 + 16, 18, 10);
    canvas.drawRRect(
      RRect.fromRectAndRadius(pocketRect, const Radius.circular(3)),
      Paint()..color = const Color(0xFF78350F),
    );

    // Left shoulder strap
    canvas.drawLine(
      Offset(cx + 15, size.height * 0.31),
      Offset(cx + 4, size.height * 0.44),
      Paint()
        ..color = const Color(0xFF78350F)
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );
    // Right strap
    canvas.drawLine(
      Offset(cx + 30, size.height * 0.31),
      Offset(cx + 18, size.height * 0.50),
      Paint()
        ..color = const Color(0xFF78350F)
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );
  }

  // ── Graduation Cap (Graduate) ─────────────────────────────────────────────
  void _drawGraduationCap(Canvas canvas, Size size, double cx) {
    final capY = size.height * 0.019;
    final capPaint = Paint()..color = const Color(0xFF1E293B);
    final capHighlight = Paint()..color = Colors.white.withValues(alpha: 0.1);

    // Base cylinder sitting on head
    final baseRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx - 12, capY + 10, 24, 8),
      const Radius.circular(3),
    );
    canvas.drawRRect(baseRect, capPaint);

    // Flat square top
    final topPath = Path()
      ..moveTo(cx - 20, capY + 12)
      ..lineTo(cx + 20, capY + 12)
      ..lineTo(cx + 20, capY + 5)
      ..lineTo(cx, capY)
      ..lineTo(cx - 20, capY + 5)
      ..close();
    canvas.drawPath(topPath, capPaint);
    canvas.drawPath(topPath, capHighlight);

    // Cap top edge highlight
    canvas.drawLine(
      Offset(cx - 18, capY + 6),
      Offset(cx + 18, capY + 6),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.18)
        ..strokeWidth = 1.2,
    );

    // Tassel string (right side)
    final tasselPaint = Paint()
      ..color = const Color(0xFFD97706)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(cx + 18, capY + 7),
      Offset(cx + 20, capY + 22),
      tasselPaint,
    );
    // Tassel tip
    canvas.drawCircle(
      Offset(cx + 20, capY + 22),
      3,
      Paint()..color = const Color(0xFFF59E0B),
    );
    // Tassel threads
    for (int i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(cx + 20, capY + 22),
        Offset(cx + 16 + i * 3.0, capY + 30),
        Paint()
          ..color = const Color(0xFFD97706)
          ..strokeWidth = 1.0,
      );
    }
  }

  // ── Blazer (Pro) ────────────────────────────────────────────────────────
  void _drawBlazer(Canvas canvas, Size size, double cx) {
    final blazerPaint = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.navy.withValues(alpha: 0.85), AppColors.navy],
          ).createShader(
            Rect.fromLTWH(cx - 18, size.height * 0.30, 36, size.height * 0.35),
          );

    final leftLapel = Path()
      ..moveTo(cx - 18, size.height * 0.30)
      ..lineTo(cx - 2, size.height * 0.37)
      ..lineTo(cx - 2, size.height * 0.62)
      ..lineTo(cx - 18, size.height * 0.62)
      ..close();
    canvas.drawPath(leftLapel, blazerPaint);

    final rightLapel = Path()
      ..moveTo(cx + 18, size.height * 0.30)
      ..lineTo(cx + 2, size.height * 0.37)
      ..lineTo(cx + 2, size.height * 0.62)
      ..lineTo(cx + 18, size.height * 0.62)
      ..close();
    canvas.drawPath(rightLapel, blazerPaint);

    // Collar notches
    final collarPaint = Paint()..color = Colors.white;
    final leftCollar = Path()
      ..moveTo(cx - 2, size.height * 0.31)
      ..lineTo(cx - 8, size.height * 0.36)
      ..lineTo(cx - 2, size.height * 0.39)
      ..close();
    canvas.drawPath(leftCollar, collarPaint);
    final rightCollar = Path()
      ..moveTo(cx + 2, size.height * 0.31)
      ..lineTo(cx + 8, size.height * 0.36)
      ..lineTo(cx + 2, size.height * 0.39)
      ..close();
    canvas.drawPath(rightCollar, collarPaint);

    // Lapel highlight
    canvas.drawLine(
      Offset(cx - 16, size.height * 0.31),
      Offset(cx - 3, size.height * 0.37),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.15)
        ..strokeWidth = 1.5,
    );

    // Buttons
    final btnPaint = Paint()..color = Colors.white.withValues(alpha: 0.9);
    canvas.drawCircle(Offset(cx, size.height * 0.47), 2, btnPaint);
    canvas.drawCircle(Offset(cx, size.height * 0.53), 2, btnPaint);
  }

  // ── Watch (Pro) ──────────────────────────────────────────────────────────
  void _drawWatch(Canvas canvas, Size size, double cx) {
    // Band
    canvas.drawRect(
      Rect.fromLTWH(cx + 23, size.height * 0.49, 9, 7),
      Paint()..color = const Color(0xFF0F172A),
    );
    // Face
    final faceRect = Rect.fromLTWH(cx + 22, size.height * 0.48, 11, 9);
    canvas.drawRRect(
      RRect.fromRectAndRadius(faceRect, const Radius.circular(2)),
      Paint()..color = const Color(0xFF1E3A5F),
    );
    // Crystal with gradient
    final crystalRect = Rect.fromLTWH(cx + 23.5, size.height * 0.49, 8, 7);
    canvas.drawRRect(
      RRect.fromRectAndRadius(crystalRect, const Radius.circular(1.5)),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF38BDF8).withValues(alpha: 0.7),
            const Color(0xFF0EA5E9).withValues(alpha: 0.5),
          ],
        ).createShader(crystalRect),
    );
    // Crystal shine
    canvas.drawCircle(
      Offset(cx + 25, size.height * 0.494),
      1.5,
      Paint()..color = Colors.white.withValues(alpha: 0.5),
    );
  }

  @override
  bool shouldRepaint(_CharacterPainter oldDelegate) =>
      oldDelegate.characterClass != characterClass ||
      oldDelegate.gender != gender ||
      oldDelegate.rotationAngle != rotationAngle;
}
