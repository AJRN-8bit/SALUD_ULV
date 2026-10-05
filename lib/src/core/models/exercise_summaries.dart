enum SummaryPeriod { week, month, year }


typedef MetricSummary = ({
  double sum,
  double? average,
  double? min,
  double? max,
  int count,
});



abstract class IExerciseSummary {
  int recordCount;
  DateTime? startDate;
  DateTime? endDate;
  Map<String, MetricSummary> metrics;

  IExerciseSummary({
    required this.recordCount,
    required this.startDate,
    required this.endDate,
    required this.metrics,
  });
}

class AerobicExerciseSummary extends IExerciseSummary {
  AerobicExerciseSummary({
    required super.recordCount,
    required super.startDate,
    required super.endDate,
    required super.metrics,
  });
}

class WalkExerciseSummary extends AerobicExerciseSummary {
  WalkExerciseSummary({
    required super.recordCount,
    required super.startDate,
    required super.endDate,
    required super.metrics,
  });
}