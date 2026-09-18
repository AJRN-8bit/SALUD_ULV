import 'package:flutter/material.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/shadows.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/themes.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.stops,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
  });

  final Widget child;
  final List<Color>? colors;
  final List<double>? stops;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  @override
  Widget build(BuildContext context) {
    // final theme = context.colors;

    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            colors: colors ??
                [
                  context.colors.background,
                  context.colors.background,
                  context.colors.background,
                ],
            stops: stops, 
          ),
        ),
        child: child,
      ),
    );
  }
}






class BackgroundContainer extends StatelessWidget {
  const BackgroundContainer({
    super.key,
    required this.child,
    this.color,
    this.backgroundColor,
    this.pHeight,
    this.pWidth,
  });

  final double? pHeight;
  final double? pWidth;
  final Widget child;
  final Color? backgroundColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Container(
      constraints: BoxConstraints(
        minHeight: pHeight ?? 325,
      ),
      width: pWidth ?? double.infinity,
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: color ?? colors.surface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        border: Border.all(
          color: colors.border,
        ),
        boxShadow: context.shadows.boxShadow,
      ),
      child: child,
    );
  }
}
