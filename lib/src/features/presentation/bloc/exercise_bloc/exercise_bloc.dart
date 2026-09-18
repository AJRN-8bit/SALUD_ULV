

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/excercise_usecases.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/exercise_bloc/exercise_event.dart';


import 'package:salud_ulv_app/src/features/presentation/bloc/exercise_bloc/exercise_state.dart';

class ExerciseGetRecentBloc extends Bloc<ExerciseEvent, ExerciseState>{
  final IGetRecentExerciseUseCase recentExerciseUseCase;

  ExerciseGetRecentBloc({required this.recentExerciseUseCase}) :super(ExerciseInitial()){

    on<ExerciseGetRecentEvent>((event, emit) async {
      try {
        emit(ExerciseLoading());
        final data = await recentExerciseUseCase.execute();
        debugPrint('Data in bloc $data');
        emit(ExerciseRecentLoaded(data));

      } catch (e) {
        debugPrint(e.toString());
        emit(ExerciseError("Error in bloc"));
      }
    });
  }
}


class ExerciseGetSamplesBLoc extends Bloc<ExerciseEvent, ExerciseState>{
  final IGetSamplesUseCase getRecentSamplesUseCase;

  ExerciseGetSamplesBLoc({required this.getRecentSamplesUseCase}) :super(ExerciseInitial()){

    on<ExerciseGetSamplesEvent>((event, emit) async {
      try {
        emit(ExerciseLoading());
        final data = await getRecentSamplesUseCase.execute(event.activityID);
        debugPrint('in bloc: $data');
        emit(ExerciseSamplesLoaded(data));

      } catch (e) {
        emit(ExerciseError("Error getting samples data"));
      }
    });
  }
}


class ExerciseGetAllBLoc extends Bloc<ExerciseEvent, ExerciseState>{    
  final IGetAllExerciseUseCase allExerciseUseCase;

  ExerciseGetAllBLoc({required this.allExerciseUseCase}) :super(ExerciseInitial()){

    on<ExerciseGetAllEvent>((event, emit) async {
      try {
        emit(ExerciseLoading());
        final data = await allExerciseUseCase.execute();
        debugPrint(data.toString());
        emit(ExerciseListLoaded(data));

      } catch (e) {
        emit(ExerciseError("Error getting data in bloc"));
      }
    });
  }
}




// class SendExerciseBloc extends Bloc<ExerciseEvent, ExerciseState>{    
//   final ISendExerciseUseCase sendExerciseUseCase;

//   SendExerciseBloc({required this.sendExerciseUseCase}) :super(ExerciseInitial()){

//     on<ExerciseSyncPending>((event, emit) async {
//       try {
       
//         emit(ExerciseSent());

//       } catch (e) {
//         emit(ExerciseError("Error getting data"));
//       }
//     });
//   }
// }
