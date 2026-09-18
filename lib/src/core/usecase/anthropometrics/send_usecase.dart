
import 'package:flutter/cupertino.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/anthro_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/check_connection_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/current_user_session_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/anthropometric_usecase.dart';

class SendAnthroUsecase implements ISendAnthroUseCase {
  final IAnthropometricLocalRepo anthropometricLocalRepo;
  final IAnthropometricExtRepo anthropometricExtRepo;
  final ICurrentUserSession currentUserSession;
  final ICheckConnectionRepo checkConnectionRepo;

  const SendAnthroUsecase(
    this.anthropometricLocalRepo, 
    this.anthropometricExtRepo, 
    this.currentUserSession,
    this.checkConnectionRepo
    );

  @override
  Future<bool> execute() async {
    final hasConnection = await checkConnectionRepo.hasConnection();
    if(!hasConnection) return false;

    final userUUID = await currentUserSession.getCurrentUserUUID();
    if(userUUID == null) return false;

    final pending = await anthropometricLocalRepo.getUnsynced(userUUID);
    if(pending == null || pending.isEmpty) return false;

    // Sending each unsynced data to the APIes
    debugPrint("Pending lenght: ${pending.length}");


    bool sentAny = false;

    for (final item in pending) {
      try {
        debugPrint(item.toString());

        await anthropometricExtRepo.send(item);

        await anthropometricLocalRepo.markAsSynced(
          item.anthropometricID!,
        );

        sentAny = true;
      } catch (e) {
        debugPrint("Item not sent to API");
      }
    }

    return sentAny;
  }
}