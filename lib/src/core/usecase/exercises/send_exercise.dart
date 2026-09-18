

import 'package:flutter/material.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/excercise_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/check_connection_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/excercise_usecases.dart';

//class SendExerciseUseCase implements ISendExerciseUseCase{
//  final IExerciseLocalRepo exerciseLocalRepo;
//  final IExerciseExtRepo exerciseExtRepo;
//  final ICheckConnectionRepo checkConnectionRepo;
//  final List<String> exercises = ['walk'];

//  SendExerciseUseCase(
//    this.exerciseLocalRepo,
//    this.exerciseExtRepo,
//    this.checkConnectionRepo
//    ); 

//  @override
//  Future<void> execute() async {
//    final hasConnection = await checkConnectionRepo.hasConnection();
//    if(!hasConnection) return;

//    for(final exerciseType in exercises) {
//      final pending = await exerciseLocalRepo.getUnsynced();
//      if(pending == null || pending.isEmpty) continue;


//      for(final item in pending) {
//        try {
//          debugPrint(item.toString());
//          await exerciseExtRepo.send(item);
//          await exerciseLocalRepo.markAsSynced(item.activityID!);

//        } catch (e) {
//          debugPrint("Item not sent to API");
//        }
//      }
      
//      debugPrint('Exercise $exerciseType sent');
//    }
//  }
//}