// ─────────────────────────────────────────────────────────
// Modelo para stats dinámicos
// ─────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/fonts_size.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/shadows.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/themes.dart';

class ExerciseStat {
  final IconData icon;
  final String label;
  final String value;

  const ExerciseStat({
    required this.icon,
    required this.label,
    required this.value,
  });
}

// ─────────────────────────────────────────────────────────
// _StatCard
// ─────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String value;

  const _StatCard({
    required this.label,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 125,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.onPrimary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(context.spacing.radiusLg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Solo se muestra el círculo del icono si icon no es null.
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.surface.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: colors.onPrimary),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: context.fontsSize.caption,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: context.fontsSize.caption - 2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Tarjeta de info: recibe TODO por parámetro, sin BlocBuilder
// ─────────────────────────────────────────────────────────

Widget exerciseInfoCard(
  BuildContext context, {
  required String title,
  required IconData icon,
  required String
  statusLabel, // 'Pausado' / 'En progreso' / 'Listo para comenzar'
  required bool isTracking, // controla el puntito verde
  required String time, // ya formateado, ej '02:15'
  required List<ExerciseStat> stats,
}) {
  final colors = context.colors;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    decoration: BoxDecoration(
      color: colors.surface.withValues(alpha: 0.94),
      borderRadius: BorderRadius.circular(24),
      boxShadow: context.shadows.boxShadow,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: colors.onPrimary, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    statusLabel,
                    style: TextStyle(color: colors.textPrimary, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (isTracking)
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withValues(alpha: 0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
          ],
        ),

        const SizedBox(height: 12),

        Text(
          time,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),

        if (stats.isNotEmpty) ...[
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              for (final stat in stats)
                _StatCard(
                  icon: stat.icon,
                  label: stat.label,
                  value: stat.value,
                ),
            ],
          ),
        ],
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────
// Controles: también reciben el "modo" por parámetro
// ─────────────────────────────────────────────────────────

enum ExerciseControlsMode { initial, tracking, paused }

Widget exerciseControls(
  BuildContext context, {
  required ExerciseControlsMode mode,
  required VoidCallback onStart,
  required VoidCallback onPause,
  required VoidCallback onResume,
  required VoidCallback onDiscard,
  required VoidCallback onSave,
}) {
  final colors = context.colors;

  Widget circleButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color background,
    required Color foreground,
    double size = 90,
    double iconSize = 28,
  }) {
    return Material(
      color: background,
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, color: foreground, size: iconSize),
        ),
      ),
    );
  }

  return Container(
    padding: EdgeInsets.symmetric(vertical: context.spacing.md),
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(28),
      // boxShadow: context.shadows.boxShadow,
    ),
    child: switch (mode) {
      ExerciseControlsMode.initial => Center(
        child: circleButton(
          icon: Icons.play_arrow_rounded,
          background: colors.onPrimary,
          foreground: colors.onSecondary,
          onPressed: onStart,
          // size: 80
        ),
      ),
      ExerciseControlsMode.tracking => Center(
        child: circleButton(
          icon: Icons.pause_rounded,
          background: colors.onPrimary,
          foreground: colors.onSecondary,
          onPressed: onPause,
          size: 90,
        ),
      ),
      ExerciseControlsMode.paused => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onLongPress: onDiscard,
            child: circleButton(
              icon: Icons.delete_rounded,
              background: colors.danger,
              foreground: colors.background,
              size: 55,
              iconSize: context.iconSize.md,
              onPressed: () {},
            ),
          ),


          SizedBox(width: context.spacing.md),
          circleButton(
            icon: Icons.play_arrow_rounded,
            background: colors.onPrimary,
            foreground: colors.onSecondary,
            onPressed: onResume,
          ),
          SizedBox(width: context.spacing.md),
          circleButton(
            icon: Icons.check_rounded,
            background: colors.success,
            foreground: colors.background,
            size: 55,
            iconSize: context.iconSize.md,
            onPressed: onSave,
          ),
        ],
      ),
    },
  );
}
