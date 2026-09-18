import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/fonts_size.dart';
import 'dart:math';

import 'package:salud_ulv_app/src/features/presentation/shared/themes/themes.dart';

enum ChartType { line, bar }

// ------------------------------------------------------------
// PUNTO / BARRA - CONFIGURACIÓN VISUAL (separada de la gráfica)
// ------------------------------------------------------------

/// Agrupa toda la configuración de apariencia de los puntos de la línea
/// y de las barras, para poder modificarla sin tocar `CustomDataChart`.
class ChartPointStyle {
  // --- Línea ---

  /// Si la línea se dibuja curva (true) o recta entre puntos (false).
  final bool isCurved;

  /// Qué tan suave es la curva (0.0 = angulosa, 1.0 = muy suave).
  final double curveSmoothness;

  /// Grosor de la línea.
  final double lineWidth;

  /// Si se muestran los puntos (dots) sobre la línea.
  final bool showDots;

  /// Radio de cada punto (dot), solo aplica si [showDots] es true.
  final double dotRadius;

  /// Color de los puntos. Si es null, se usa el color primario del tema.
  final Color? dotColor;

  /// Si se rellena el área debajo de la línea con gradiente.
  final bool showBelowBarGradient;

  // --- Barras ---

  /// Ancho de cada barra en el gráfico de tipo bar.
  final double barChartWidth;

  /// Radio de las esquinas superiores de cada barra.
  final double barBorderRadius;

  const ChartPointStyle({
    this.isCurved = true,
    this.curveSmoothness = 0.3,
    this.lineWidth = 3,
    this.showDots = false,
    this.dotRadius = 4,
    this.dotColor,
    this.showBelowBarGradient = true,
    this.barChartWidth = 16,
    this.barBorderRadius = 6,
  });

  /// Permite crear una copia modificando solo algunos valores.
  ChartPointStyle copyWith({
    bool? isCurved,
    double? curveSmoothness,
    double? lineWidth,
    bool? showDots,
    double? dotRadius,
    Color? dotColor,
    bool? showBelowBarGradient,
    double? barChartWidth,
    double? barBorderRadius,
  }) {
    return ChartPointStyle(
      isCurved: isCurved ?? this.isCurved,
      curveSmoothness: curveSmoothness ?? this.curveSmoothness,
      lineWidth: lineWidth ?? this.lineWidth,
      showDots: showDots ?? this.showDots,
      dotRadius: dotRadius ?? this.dotRadius,
      dotColor: dotColor ?? this.dotColor,
      showBelowBarGradient:
          showBelowBarGradient ?? this.showBelowBarGradient,
      barChartWidth: barChartWidth ?? this.barChartWidth,
      barBorderRadius: barBorderRadius ?? this.barBorderRadius,
    );
  }
}

// ------------------------------------------------------------
// GRÁFICA
// ------------------------------------------------------------

class CustomDataChart extends StatelessWidget {
  final List<num> values;
  final List<dynamic>? times;
  final ChartType type;
  final double height;
  final String? title;
  final bool? grid;

  /// Personaliza el texto que aparece en el tooltip al tocar un punto/barra.
  final String Function(num value, dynamic time)? tooltipLabelBuilder;

  /// Color de fondo del tooltip. Si es null, se usa un color por defecto.
  final Color? tooltipBackgroundColor;

  /// Número máximo de puntos/barras a mostrar en la gráfica.
  final int maxPoints;

  /// Número aproximado de etiquetas a mostrar en el eje inferior.
  final int maxLabels;

  /// Configuración visual de los puntos/barras (curva, dots, ancho, etc.).
  /// Al estar separada en [ChartPointStyle], se puede modificar sin tocar
  /// esta clase.
  final ChartPointStyle pointStyle;

  const CustomDataChart({
    super.key,
    required this.values,
    this.times,
    this.type = ChartType.line,
    this.height = 220,
    this.title,
    this.grid,
    this.tooltipLabelBuilder,
    this.tooltipBackgroundColor,
    this.maxPoints = 15,
    this.maxLabels = 10,
    this.pointStyle = const ChartPointStyle(),
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fontSize = context.fontsSize;

    final rawData = <_ChartPoint>[];

    for (int i = 0; i < values.length; i++) {
      final value = values[i].toDouble();

      if (!value.isFinite) continue;

      rawData.add(
        _ChartPoint(
          value: value,
          time: times != null && i < times!.length ? times![i] : i,
        ),
      );
    }

    if (rawData.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            'Sin datos',
            style: TextStyle(color: colors.textPrimary),
          ),
        ),
      );
    }

    final validData = _downsample(rawData, maxPoints);

    final doubleValues = validData.map((point) => point.value).toList();

    final maxValue = doubleValues.reduce((a, b) => a > b ? a : b);

    // Prevent maxY from being 0.
    final maxY = maxValue <= 0 ? 1.0 : maxValue;

    final leftInterval = _calculateNiceInterval(maxY);

    final showGrid = grid ?? true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: TextStyle(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: fontSize.body,
            ),
          ),
          SizedBox(height: context.spacing.lg),
        ],

        SizedBox(
          height: height,
          child: type == ChartType.line
              ? _buildLineChart(colors, validData, maxY, showGrid, leftInterval)
              : _buildBarChart(colors, validData, maxY, showGrid, leftInterval),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // DOWNSAMPLING (agrupa datos crudos en buckets promediados)
  // ------------------------------------------------------------

  List<_ChartPoint> _downsample(List<_ChartPoint> data, int maxPoints) {
    if (data.length <= maxPoints || maxPoints <= 0) return data;

    final bucketSize = (data.length / maxPoints).ceil();
    final result = <_ChartPoint>[];

    for (int i = 0; i < data.length; i += bucketSize) {
      final end = min(i + bucketSize, data.length);
      final bucket = data.sublist(i, end);

      final avgValue =
          bucket.map((p) => p.value).reduce((a, b) => a + b) / bucket.length;

      final representativeTime = bucket[bucket.length ~/ 2].time;

      result.add(_ChartPoint(value: avgValue, time: representativeTime));
    }

    return result;
  }

  // ------------------------------------------------------------
  // NICE INTERVAL (evita labels duplicados en el eje izquierdo)
  // ------------------------------------------------------------

  double _calculateNiceInterval(double maxY, {int targetSteps = 4}) {
    if (maxY <= 0) return 1;

    final rawStep = maxY / targetSteps;
    final magnitude = pow(10, (log(rawStep) / ln10).floor()).toDouble();
    final residual = rawStep / magnitude;

    double niceResidual;
    if (residual > 5) {
      niceResidual = 10;
    } else if (residual > 2) {
      niceResidual = 5;
    } else if (residual > 1) {
      niceResidual = 2;
    } else {
      niceResidual = 1;
    }

    final interval = niceResidual * magnitude;

    return interval < 1 ? 1 : interval;
  }

  // ------------------------------------------------------------
  // LABEL FORMATTING
  // ------------------------------------------------------------

  String _labelFor(dynamic time) {
    if (time is DateTime) {
      return '${time.day}/${time.month}';
    }

    if (time is Duration) {
      final totalSeconds = time.inSeconds;

      if (totalSeconds < 60) {
        return '${totalSeconds}s';
      }

      final hours = time.inHours;
      final minutes = time.inMinutes.remainder(60);

      if (hours > 0) {
        return '${hours}h${minutes}m';
      }

      return '${minutes}m';
    }

    if (time is num) {
      return time.toString();
    }

    if (time is String) {
      return time;
    }

    return time.toString();
  }

  String _tooltipTextFor(num value, dynamic time) {
    if (tooltipLabelBuilder != null) {
      return tooltipLabelBuilder!(value, time);
    }
    return '${value.toStringAsFixed(1)}\n${_labelFor(time)}';
  }

  // ------------------------------------------------------------
  // BOTTOM LABEL (solo muestra ~maxLabels etiquetas)
  // ------------------------------------------------------------

  Widget _bottomLabel(dynamic colors, double value, List<_ChartPoint> data) {
    final index = value.toInt();

    if (index < 0 || index >= data.length) {
      return const SizedBox.shrink();
    }

    final labelStep = max(1, (data.length / maxLabels).ceil());

    final isFirst = index == 0;
    final isLast = index == data.length - 1;

    if (!isFirst && !isLast && index % labelStep != 0) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        _labelFor(data[index].time),
        style: TextStyle(color: colors.textPrimary, fontSize: 12),
      ),
    );
  }

  // ------------------------------------------------------------
  // LINE CHART
  // ------------------------------------------------------------

  Widget _buildLineChart(
    dynamic colors,
    List<_ChartPoint> data,
    double maxY,
    bool showGrid,
    double leftInterval,
  ) {
    final spots = data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxY,

        gridData: FlGridData(
          show: showGrid,
          drawVerticalLine: false,
          horizontalInterval: leftInterval,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: colors.surface, strokeWidth: 1);
          },
        ),

        borderData: FlBorderData(show: false),

        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),

          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),

          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: leftInterval,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(0),
                  style: TextStyle(color: colors.textPrimary, fontSize: 12),
                );
              },
            ),
          ),

          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return _bottomLabel(colors, value, data);
              },
            ),
          ),
        ),

        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) =>
                tooltipBackgroundColor ?? colors.surface,
            getTooltipItems: (spots) {
              return spots.map((spot) {
                final index = spot.x.toInt();

                if (index < 0 || index >= data.length) {
                  return null;
                }

                return LineTooltipItem(
                  _tooltipTextFor(spot.y, data[index].time),
                  TextStyle(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),

        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: pointStyle.isCurved,
            curveSmoothness: pointStyle.curveSmoothness,

            gradient: LinearGradient(
              colors: [colors.onTertiary, colors.onSecondary, colors.onPrimary],
            ),

            barWidth: pointStyle.lineWidth,

            dotData: FlDotData(
              show: pointStyle.showDots,
              getDotPainter: (spot, percent, bar, index) {
                return FlDotCirclePainter(
                  radius: pointStyle.dotRadius,
                  color: pointStyle.dotColor ?? colors.primary,
                  strokeWidth: 0,
                );
              },
            ),

            belowBarData: BarAreaData(
              show: pointStyle.showBelowBarGradient,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colors.primary.withOpacity(0.25),
                  colors.primary.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // BAR CHART
  // ------------------------------------------------------------

  Widget _buildBarChart(
    dynamic colors,
    List<_ChartPoint> data,
    double maxY,
    bool showGrid,
    double leftInterval,
  ) {
    return BarChart(
      BarChartData(
        minY: 0,
        maxY: maxY,

        gridData: FlGridData(
          show: showGrid,
          drawVerticalLine: false,
          horizontalInterval: leftInterval,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: colors.surface, strokeWidth: 1);
          },
        ),

        borderData: FlBorderData(show: false),

        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),

          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),

          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: leftInterval,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(0),
                  style: TextStyle(color: colors.textPrimary, fontSize: 12),
                );
              },
            ),
          ),

          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return _bottomLabel(colors, value, data);
              },
            ),
          ),
        ),

        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) =>
                tooltipBackgroundColor ?? colors.surface,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              if (groupIndex < 0 || groupIndex >= data.length) {
                return null;
              }

              return BarTooltipItem(
                _tooltipTextFor(rod.toY, data[groupIndex].time),
                TextStyle(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),

        barGroups: data.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.value,
                width: pointStyle.barChartWidth,
                borderRadius: BorderRadius.circular(pointStyle.barBorderRadius),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    colors.onTertiary,
                    colors.secondary,
                    colors.primary,
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ------------------------------------------------------------
// INTERNAL DATA MODEL
// ------------------------------------------------------------

class _ChartPoint {
  final double value;
  final dynamic time;

  const _ChartPoint({required this.value, required this.time});
}