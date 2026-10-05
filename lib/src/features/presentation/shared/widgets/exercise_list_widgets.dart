

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salud_ulv_app/src/core/models/exercises.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/helpers/fomaters.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/fonts_size.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/themes.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/info.dart';


class RecordListPaginator extends StatelessWidget {
  const RecordListPaginator({
    super.key,
    required this.title,
    required this.subtitle,
    required this.hasPrevious,
    required this.hasNext,
    required this.onPrevious,
    required this.onNext,
  });

  final String title;
  final String subtitle;
  final bool hasPrevious;
  final bool hasNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: hasPrevious ? onPrevious : null,
          icon: Icon(
            Icons.chevron_left_rounded,
            color: hasPrevious
                ? colors.textPrimary
                : colors.onSecondary.withValues(alpha: 0.3),
          ),
        ),

        Column(
          children: [
            CustomTextWidget(
              label: title,
              fontWeight: FontWeight.w700,
              fontSize: context.fontsSize.title,
            ),
            CustomTextWidget(
              label: subtitle,
              fontSize: context.fontsSize.caption,
              color: colors.onSecondary,
            ),
          ],
        ),

        IconButton(
          onPressed: hasNext ? onNext : null,
          icon: Icon(
            Icons.chevron_right_rounded,
            color: hasNext
                ? colors.textPrimary
                : colors.onSecondary.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }
}





class WalkCard extends StatelessWidget {
  const WalkCard({
    super.key,
    required this.walk,
    this.onTap,
    this.color,
  });

  final Walk walk;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: color ?? colors.surface,
      borderRadius: BorderRadius.circular(spacing.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(spacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(spacing.radiusLg),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              // Icon badge
              Container(
                padding: EdgeInsets.all(spacing.sm),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: FaIcon(
                  FontAwesomeIcons.personWalking,
                  color: colors.onPrimary,
                  size: context.iconSize.md,
                ),
              ),
              SizedBox(width: spacing.md),

              // Date + stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatDateWithWord(walk.registeredAt!),
                      style: textTheme.titleSmall?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: spacing.xs),
                    Wrap(
                      spacing: spacing.md,
                      runSpacing: spacing.xs,
                      children: [
                        _Stat(
                          icon: FontAwesomeIcons.rulerHorizontal,
                          text: '${(walk.distance! / 1000).toStringAsFixed(2)} km',
                        ),
                        _Stat(
                          icon: FontAwesomeIcons.stopwatch,
                          text: formatDuration(walk.duration!),
                        ),
                        _Stat(
                          icon: FontAwesomeIcons.shoePrints,
                          text: '${walk.steps} pasos',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (onTap != null)
                Icon(Icons.chevron_right, color: Theme.of(context).hintColor),
            ],
          ),
        ),
      ),
    );
  }
}



class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.text});

  final FaIconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final hint = Theme.of(context).hintColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(icon, size: 14, color: context.colors.onPrimary),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: hint),
        ),
      ],
    );
  }
}