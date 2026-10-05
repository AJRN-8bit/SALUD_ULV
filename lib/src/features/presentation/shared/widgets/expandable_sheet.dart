import 'package:flutter/material.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/shadows.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/themes.dart';

class ExpandableSheet extends StatelessWidget {
  const ExpandableSheet({
    super.key,
    required this.child,
    this.color,
    this.initialSize = 0.18,
    this.minSize = 0.1,
    this.maxSize = 1,
    this.snapSizes,
    this.showHandle = true,
    this.controller,
    this.padding,
  });

  /// Content shown inside the sheet. It is placed in a scrollable
  /// that is wired to the sheet, so dragging expands it first and
  /// scrolls the content afterwards.
  final Widget child;

  final Color? color;

  /// Fractions of the parent's height (0.0 - 1.0).
  final double initialSize;
  final double minSize;
  final double maxSize;

  /// Positions the sheet snaps to. Defaults to [minSize], midpoint, [maxSize].
  final List<double>? snapSizes;

  final bool showHandle;
  final double? padding;

  /// Optional, lets the parent expand/collapse the sheet from code.
  final DraggableScrollableController? controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return DraggableScrollableSheet(
      controller: controller,
      initialChildSize: initialSize,
      minChildSize: minSize,
      maxChildSize: maxSize,
      snap: true,
      snapSizes: snapSizes ?? [minSize, (minSize + maxSize) / 2, maxSize],
      builder: (context, scrollController) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: color ?? colors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(spacing.radiusLg),
            ),
            border: Border.all(color: colors.border),
            boxShadow: context.shadows.boxShadow,
          ),
          child: SingleChildScrollView(
            controller: scrollController, // IMPORTANT
            padding: EdgeInsets.all(padding ?? spacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showHandle) ...[
                  Icon(
                    Icons.keyboard_arrow_up_rounded,
                    size: context.iconSize.xl,
                    color: context.colors.textPrimary.withValues(alpha: 0.6),
                  ),
                  // SizedBox(height: spacing.md),
                ],
                child,
              ],
            ),
          ),
        );
      },
    );
  }
}
