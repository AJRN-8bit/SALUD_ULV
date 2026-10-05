
  import 'package:salud_ulv_app/src/core/models/exercise_summaries.dart';

String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String formatDuration(Duration d) {
    return '${d.inMinutes.toString().padLeft(2, '0')}:'
        '${(d.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  String formatDateWithWord(DateTime d) {
    const months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  String formatDurationFromSeconds(double? seconds) {
  if (seconds == null) return '-';

  final duration = Duration(seconds: seconds.round());
  final h = duration.inHours;
  final m = duration.inMinutes.remainder(60);
  final s = duration.inSeconds.remainder(60);

  if (h > 0) {
    return '${h}h ${m.toString().padLeft(2, '0')}m';
  } else if (m > 0) {
    return '${m}m ${s.toString().padLeft(2, '0')}s';
  } else {
    return '${s}s';
  }
  }


  MetricSummary scaleMetric(MetricSummary metric, double factor) {
  return (
    sum: metric.sum * factor,
    average: metric.average != null ? metric.average! * factor : null,
    min: metric.min != null ? metric.min! * factor : null,
    max: metric.max != null ? metric.max! * factor : null,
    count: metric.count,
  );
}