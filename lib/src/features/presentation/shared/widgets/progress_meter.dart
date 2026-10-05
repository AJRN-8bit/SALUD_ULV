import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/fonts_size.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/themes.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/info.dart';

class CircularProgressMeter extends StatelessWidget {
  final int amount;
  final int goalAmount;
  final FaIconData? icon;
  final double size;
  final double strokeWidth;
  final String? label;

  const CircularProgressMeter({
    super.key,
    required this.amount,
    required this.goalAmount,
    this.icon,
    this.size = 180,
    this.strokeWidth = 14,
    this.label,
  });

  double get _progress {
    if (goalAmount <= 0) {
      return 0.0;
    }

    final safeAmount = amount < 0 ? 0 : amount;

    return (safeAmount / goalAmount).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    // Protect CustomPaint from invalid dimensions.
    final safeSize = size.isFinite && size > 0 ? size : 180.0;

    final safeStrokeWidth =
        strokeWidth.isFinite && strokeWidth > 0
            ? math.min(strokeWidth, safeSize / 2)
            : 14.0;

    return SizedBox(
      width: safeSize,
      height: safeSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ring
          Positioned.fill(
            child: CustomPaint(
              painter: _RingPainter(
                progress: 1.0,
                strokeWidth: safeStrokeWidth,
                color: colors.onSecondary,
              ),
            ),
          ),

          // Progress ring
          Positioned.fill(
            child: CustomPaint(
              painter: _RingPainter(
                progress: _progress,
                strokeWidth: safeStrokeWidth,
                gradientColors: [
                  colors.primary,
                  colors.primary,
                  colors.primary,
                  // colors.secondary,
                ],
              ),
            ),
          ),

          // Center content
          Column(
            mainAxisSize: MainAxisSize.min,
            
            children: [
              if(icon != null) ...[
              FaIcon(
                icon,
                size: context.iconSize.sm,
                color: colors.primary,
              ),
             SizedBox(height: spacing.xs),
              ],


              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$amount',
                      style: TextStyle(
                        fontSize: context.fontsSize.headline,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    TextSpan(
                      text: ' / $goalAmount',
                      style: TextStyle(
                        fontSize: context.fontsSize.body,
                        fontWeight: FontWeight.w400,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              if (label != null && label!.isNotEmpty) ...[
                SizedBox(height: spacing.xs),
                CustomTextWidget(
                  label: label!,
                  fontSize: context.fontsSize.caption,
                 
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color? color;
  final List<Color>? gradientColors;

  _RingPainter({
    required this.progress,
    required this.strokeWidth,
    this.color,
    this.gradientColors,
  }) : assert(
          color != null || gradientColors != null,
          'Either color or gradientColors must be provided',
        );

  @override
  void paint(Canvas canvas, Size size) {
    // --------------------------------------------
    // Validate everything before touching painting
    // --------------------------------------------

    if (!size.width.isFinite || !size.height.isFinite) {
      return;
    }

    if (size.width <= 0 || size.height <= 0) {
      return;
    }

    if (!strokeWidth.isFinite || strokeWidth <= 0) {
      return;
    }

    if (!progress.isFinite) {
      return;
    }

    final safeProgress = progress.clamp(0.0, 1.0);

    if (safeProgress <= 0) {
      return;
    }

    // --------------------------------------------
    // Geometry
    // --------------------------------------------

    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final maxStroke = math.min(
      size.width,
      size.height,
    );

    final safeStrokeWidth = math.min(
      strokeWidth,
      maxStroke,
    );

    final radius = (maxStroke - safeStrokeWidth) / 2;

    if (!radius.isFinite || radius <= 0) {
      return;
    }

    final rect = Rect.fromCircle(
      center: center,
      radius: radius,
    );

    // --------------------------------------------
    // Paint
    // --------------------------------------------

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = safeStrokeWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    // --------------------------------------------
    // Gradient
    // --------------------------------------------

    if (gradientColors != null &&
        gradientColors!.length >= 2) {
      paint.shader = SweepGradient(
        startAngle: 0,
        endAngle: 2 * math.pi,
        colors: gradientColors!,
      ).createShader(rect);
    } else if (color != null) {
      paint.color = color!;
    } else {
      return;
    }

    // --------------------------------------------
    // Arc
    // --------------------------------------------

    const startAngle = -math.pi / 2;

    final sweepAngle = 2 * math.pi * safeProgress;

    if (!sweepAngle.isFinite || sweepAngle <= 0) {
      return;
    }

    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.color != color ||
        !_sameColors(
          oldDelegate.gradientColors,
          gradientColors,
        );
  }

  bool _sameColors(
    List<Color>? a,
    List<Color>? b,
  ) {
    if (identical(a, b)) {
      return true;
    }

    if (a == null || b == null) {
      return false;
    }

    if (a.length != b.length) {
      return false;
    }

    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }

    return true;
  }
}
