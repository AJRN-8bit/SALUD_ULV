// ─────────────────────────────────────────────────────────
// Modelo para stats dinámicos
// ─────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/exercise_tracking_bloc/exercise_tracking_bloc.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/exercise_tracking_bloc/exercise_tracking_event.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/exercise_tracking_bloc/exercise_tracking_state.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/helpers/fomaters.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/themes.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/data_tiles.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/info.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/fonts_size.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/shadows.dart';

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
        // child: circleButton(
        //   icon: Icons.play_arrow_rounded,
        //   background: colors.onPrimary,
        //   foreground: colors.onSecondary,
        //   onPressed: onStart,
        //   // size: 80
        // ),
        child: TrackActionButton(onPressed: onStart, icon: Icons.play_arrow_rounded, width: 150,),
      ),
      ExerciseControlsMode.tracking => Center(
        // child: circleButton(
        //   icon: Icons.pause_rounded,
        //   background: colors.onPrimary,
        //   foreground: colors.onSecondary,
        //   onPressed: onPause,
        //   size: 90,
        // ),
        child: TrackActionButton(icon: Icons.pause_rounded, onPressed: onPause, width: 150,),
      ),
      ExerciseControlsMode.paused => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // GestureDetector(
          //   onLongPress: onDiscard,
          //   child: circleButton(
          //     icon: Icons.delete_rounded,
          //     background: colors.danger,
          //     foreground: colors.background,
          //     size: 55,
          //     iconSize: context.iconSize.md,
          //     onPressed: () {},
          //   ),
          // ),
          // // SlideToConfirm(icon: Icons.delete_rounded, onConfirmed: onDiscard),


          // SizedBox(width: context.spacing.md),
          // circleButton(
          //   icon: Icons.play_arrow_rounded,
          //   background: colors.onPrimary,
          //   foreground: colors.onSecondary,
          //   onPressed: onResume,
          // ),
          // SizedBox(width: context.spacing.md),
          // circleButton(
          //   icon: Icons.check_rounded,
          //   background: colors.success,
          //   foreground: colors.background,
          //   size: 55,
          //   iconSize: context.iconSize.md,
          //   onPressed: onSave,
          // ),

          TrackActionButton(onPressed: onResume, icon: Icons.play_arrow_rounded, width: 150,),
          SizedBox(height: context.spacing.md,),

          Row(
            mainAxisAlignment: .center,
            mainAxisSize: .max,
            crossAxisAlignment: .center,
            children: [
          SlideToConfirm(onConfirmed: onDiscard, width: 100,),
          SizedBox(width: context.spacing.sm,),
          TrackActionButton(onPressed: onSave, icon: Icons.save, width: 100,),
            ],
          )

        ],
      ),
    },
  );
}



class TrackActionButton extends StatelessWidget {
  const TrackActionButton({
    super.key,
    this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.foregroundColor,
    this.height = 56,
    this.width = 100
  });

  final String? label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final Color? foregroundColor;
  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bg = color ?? colors.secondary;
    final fg = foregroundColor ?? Colors.white;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        color: onPressed == null ? bg.withValues(alpha: 0.4) : bg,
        borderRadius: BorderRadius.circular(height / 2),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(height / 2),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: .center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: fg, size: context.iconSize.lg),
                // const SizedBox(width: 8),
              ],
              Flexible(
                child: CustomTextWidget(
                  label: label ?? '',
                    color: fg,
                    fontSize: context.fontsSize.details,
                    fontWeight: FontWeight.w700,
                  
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class SlideToConfirm extends StatefulWidget {
  const SlideToConfirm({
    super.key,
    this.label,
    required this.onConfirmed,
    this.icon = Icons.close_rounded,
    this.color,
    this.height = 50,
    this.threshold = 0.85, // how far to slide (0-1) to count as confirmed
    this.width
  });

  final String? label;
  final VoidCallback onConfirmed;
  final IconData icon;
  final Color? color;
  final double height;
  final double threshold;
  final double? width;

  @override
  State<SlideToConfirm> createState() => _SlideToConfirmState();
}

class _SlideToConfirmState extends State<SlideToConfirm> {
  double _dx = 0;
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = colors.warning;
    final width = widget.width ?? double.infinity;

    return LayoutBuilder(
      builder: (context, constraints) {
        const pad = 4.0;
        final thumb = widget.height - pad * 2;
        final maxDx = (constraints.maxWidth - thumb - pad * 2)
            .clamp(1.0, width);
        final progress = (_dx / maxDx).clamp(0.0, 1.0);

        void onEnd() {
          if (progress >= widget.threshold) {
            HapticFeedback.mediumImpact();
            setState(() {
              _dragging = false;
              _dx = maxDx;
            });
            widget.onConfirmed();
            // Reset in case the widget stays on screen
            Future.delayed(const Duration(milliseconds: 400), () {
              if (mounted) setState(() => _dx = 0);
            });
          } else {
            setState(() {
              _dragging = false;
              _dx = 0; // snap back
            });
          }
        }

        return Container(
          height: widget.height,
          width: widget.width ?? double.infinity,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(widget.height / 2),
            border: Border.all(color: colors.danger),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Fill that follows the thumb
              AnimatedContainer(
                duration:
                    _dragging ? Duration.zero : const Duration(milliseconds: 200),
                width: _dx + thumb + pad * 2,
                decoration: BoxDecoration(
                  color: colors.danger.withAlpha(200),
                  borderRadius: BorderRadius.circular(widget.height / 2),
                ),
              ),

              // Label fades as you slide
              Center(
                child: Opacity(
                  opacity: 1 - progress,
                  child: Padding(
                    padding: EdgeInsets.only(left: thumb),
                    child: Text(
                      widget.label ?? '',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              // Thumb
              AnimatedPositioned(
                duration:
                    _dragging ? Duration.zero : const Duration(milliseconds: 200),
                left: pad + _dx,
                child: GestureDetector(
                  onHorizontalDragStart: (_) => setState(() => _dragging = true),
                  onHorizontalDragUpdate: (d) => setState(
                    () => _dx = (_dx + d.delta.dx).clamp(0.0, maxDx),
                  ),
                  onHorizontalDragEnd: (_) => onEnd(),
                  onHorizontalDragCancel: onEnd,
                  child: Container(
                    width: thumb,
                    height: thumb,
                    decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                    child: Icon(widget.icon, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}







class TrackingSheetContent extends StatelessWidget {
  const TrackingSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final colors = context.colors;
    final bloc = context.read<ExerciseTrackingBloc>();

    return BlocBuilder<ExerciseTrackingBloc, ExerciseTrackingState>(
      builder: (context, state) {
        final hasData = state is ActiveExerciseState;
        final isPaused = state is ExercisePaused;
        final isTracking = state is TrackingExercise;

        final time = hasData ? formatDuration(state.timeElapsed) : '--:--';
        final steps =
            hasData && state.steps != null ? '${state.steps}' : '--';
        final hasDistance =
            hasData && state.distance != null && state.distance! > 0;
        final distance =
            hasDistance ? (state.distance! / 1000).toStringAsFixed(2) : '--';

        final status = isPaused
            ? 'Pausado'
            : isTracking
                ? 'En progreso'
                : 'Listo para comenzar';

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---------- PEEK: timer + main button ----------
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(label: time, fontSize: context.fontsSize.display, fontWeight: .w800,),
                      CustomTextWidget(label: status, fontSize: context.fontsSize.caption,),
                    ],
                  ),
                ),
                if (isTracking)
                  TrackActionButton(
                    // width: 100,
                    icon: Icons.pause_rounded,
                    color: colors.warning,
                    onPressed: () => bloc.add(PauseExerciseEvent()),
                  )
                else if (isPaused)
                  TrackActionButton(
                    // width: 56,
                    icon: Icons.play_arrow_rounded,
                    onPressed: () => bloc.add(ResumeExerciseEvent()),
                  )
                else
                  TrackActionButton(
                    // width: 56,
                    icon: Icons.play_arrow_rounded,
                    onPressed: () => bloc.add(StartExerciseEvent()),
                  ),
              ],
            ),

            SizedBox(height: spacing.md),

            // ---------- EXPANDED: stats ----------
            Row(
              children: [
                // Expanded(
                //   child: GridDataTileTrasparent(
                //     // icon: FontAwesomeIcons.stopwatch,
                //     data: time,
                //     label: 'Duración',
                //   ),
                // ),
                Expanded(
                  child: GridDataTileTrasparent(
                    // icon: FontAwesomeIcons.ruler,
                    data: distance,
                    sufix: hasDistance ? 'km' : '',
                    label: 'Distancia',
                  ),
                ),
                Expanded(
                  child: GridDataTileTrasparent(
                    // icon: FontAwesomeIcons.shoePrints,
                    data: steps,
                    label: 'Pasos',
                  ),
                ),
              ],
            ),

            // ---------- EXPANDED: save / discard (only when paused) ----------
            if (isPaused) ...[
              SizedBox(height: spacing.md),
              Row(
                children: [
                  Expanded(
                    child: SlideToConfirm(
                      label: 'Desliza para descartar',
                      onConfirmed: () => bloc.add(DiscardExerciseEvent()),
                    ),
                  ),
                  SizedBox(width: spacing.md),
                  TrackActionButton(
                    // width: 56,
                    icon: Icons.save,
                    color: colors.success,
                    onPressed: () => bloc.add(SaveExerciseEvent()),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}