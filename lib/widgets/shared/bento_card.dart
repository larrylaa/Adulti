import 'package:flutter/material.dart';
import '../../app/theme.dart';

class BentoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;

  const BentoCard({
    super.key,
    required this.child,
    this.padding,
    this.borderColor,
    this.borderWidth = 1.5,
    this.borderRadius = 16,
    this.backgroundColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? AppColors.border.withValues(alpha: 0.15),
          width: borderWidth,
        ),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.06),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
      ),
      child: child,
    );
  }
}
