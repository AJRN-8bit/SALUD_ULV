import 'package:flutter/foundation.dart';
import 'package:salud_ulv_app/src/core/models/exercise_summaries.dart';
import 'package:salud_ulv_app/src/core/models/exercises.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/excercise_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/current_user_session_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/excercise_usecases.dart';

class GetExerciseSummaryUseCase implements IGetExerciseSummary {
  final IExerciseLocalRepo exerciseLocalRepo;
  final ICurrentUserSession currentUserSession;

  const GetExerciseSummaryUseCase(this.exerciseLocalRepo, this.currentUserSession);

  @override
  Future<IExerciseSummary?> execute(SummaryPeriod period) async {
    final userUUID = await currentUserSession.getCurrentUserUUID();
    if (userUUID == null) return null;

    final data = await exerciseLocalRepo.getAll(userUUID);
    if (data == null || data.isEmpty) return null;

    final now = DateTime.now();
    final (start, end) = _rangeFor(period, now);

    final inRange = data.where((activity) {
      final date = activity.registeredAt;
      if (date == null) return false;
      return !date.isBefore(start) && date.isBefore(end);
    }).toList();

    if(inRange.isEmpty){
      debugPrint('range empty');
      return null;
    } 



    switch (data) {
      case List<Walk>():
        return AerobicExerciseSummary(
          recordCount: data.length,
          startDate: start,
          endDate: end,
          metrics: {
            'Pasos': _summarizeField(
              data.map((w) => w.steps?.toDouble()).toList(),
            ),
            'Duración': _summarizeField(
              data.map((w) => w.duration?.inSeconds.toDouble()).toList(),
            ),
            'Distancia': _summarizeField(data.map((w) => w.distance).toList()),
            'Calorias quemadas': _summarizeField(
              data.map((w) => w.caloriesBurned).toList(),
            ),
            'Elevación': _summarizeField(
              data.map((w) => w.elevationGain).toList(),
            ),
            'Ritmo': _summarizeField(data.map((w) => w.avgPace).toList()),
            'Pasos por minuto': _summarizeField(
              data.map((w) => w.avgCadence).toList(),
            ),
            // 'heartRate': _summarizeField(data.map((w) => w.heartRate).toList()),
            // 'avgSteps': _summarizeField(data.map((w) => w.avgSteps).toList()),
          },
        );

        case List<Running>():
        return AerobicExerciseSummary(
          recordCount: data.length,
          startDate: start,
          endDate: end,
          metrics: {
            'Velocidad': _summarizeField(
              data.map((w) => w.speed?.toDouble()).toList(),
            ),
            'Duración': _summarizeField(
              data.map((w) => w.duration?.inSeconds.toDouble()).toList(),
            ),
            'Distancia': _summarizeField(data.map((w) => w.distance).toList()),
            'Calorias quemadas': _summarizeField(
              data.map((w) => w.caloriesBurned).toList(),
            ),
            'Elevación': _summarizeField(
              data.map((w) => w.elevationGain).toList(),
            ),
            'Ritmo': _summarizeField(data.map((w) => w.avgPace).toList()),
            // 'Pasos por minuto': _summarizeField(
            //   data.map((w) => w.avgCadence).toList(),
            // ),
            // 'heartRate': _summarizeField(data.map((w) => w.heartRate).toList()),
            // 'avgSteps': _summarizeField(data.map((w) => w.avgSteps).toList()),
          },
        );


        case List<Cycling>():
        return AerobicExerciseSummary(
          recordCount: data.length,
          startDate: start,
          endDate: end,
          metrics: {
            'Velocidad': _summarizeField(
              data.map((w) => w.speed?.toDouble()).toList(),
            ),
            'Duración': _summarizeField(
              data.map((w) => w.duration?.inSeconds.toDouble()).toList(),
            ),
            'Distancia': _summarizeField(data.map((w) => w.distance).toList()),
            'Calorias quemadas': _summarizeField(
              data.map((w) => w.caloriesBurned).toList(),
            ),
            'Elevación': _summarizeField(
              data.map((w) => w.elevationGain).toList(),
            ),
            'Ritmo': _summarizeField(data.map((w) => w.avgPace).toList()),
            // 'Pasos por minuto': _summarizeField(
            //   data.map((w) => w.avgCadence).toList(),
            // ),
            // 'heartRate': _summarizeField(data.map((w) => w.heartRate).toList()),
            // 'avgSteps': _summarizeField(data.map((w) => w.avgSteps).toList()),
          },
        );

        
      default:
        return null;
    }
  }
}

MetricSummary _summarizeField(List<num?> values) {
  final validValues = values.whereType<num>().toList();

  if (validValues.isEmpty) {
    return (sum: 0, average: 0, min: 0, max: 0, count: 0);
  }

  final sum = validValues.fold<double>(0, (acc, v) => acc + v);
  final average = sum / validValues.length;
  final min = validValues.reduce((a, b) => a < b ? a : b).toDouble();
  final max = validValues.reduce((a, b) => a > b ? a : b).toDouble();

  return (
    sum: sum,
    average: average,
    min: min,
    max: max,
    count: validValues.length,
  );
}

(DateTime, DateTime) _rangeFor(SummaryPeriod period, DateTime now) {
  switch (period) {
    case SummaryPeriod.week:
      final start = now.subtract(Duration(days: now.weekday - 1));
      final startOfDay = DateTime(start.year, start.month, start.day);
      return (startOfDay, startOfDay.add(const Duration(days: 7)));
    case SummaryPeriod.month:
      return (
        DateTime(now.year, now.month, 1),
        DateTime(now.year, now.month + 1, 1),
      );
    case SummaryPeriod.year:
      return (DateTime(now.year, 1, 1), DateTime(now.year + 1, 1, 1));
  }
}
