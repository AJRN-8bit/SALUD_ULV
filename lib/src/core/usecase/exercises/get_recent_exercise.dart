

import 'package:flutter/cupertino.dart';
import 'package:salud_ulv_app/src/core/models/exercises.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/excercise_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/current_user_session_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/excercise_usecases.dart';

class GetRecentExerciseUseCase implements IGetRecentExerciseUseCase{
  final IExerciseLocalRepo exerciseLocalRepo;
  final ICurrentUserSession currentUserSession;

  const GetRecentExerciseUseCase(this.exerciseLocalRepo, this.currentUserSession);

  @override
  Future<IPhysicalActivity?> execute() async {
    final userUUID = await currentUserSession.getCurrentUserUUID();
    if(userUUID == null) return null;

    final data = await exerciseLocalRepo.getRecent(userUUID);
    debugPrint("data in use case $data");
    if(data == null) return null;

    return data;
  }
}