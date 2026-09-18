

import 'package:flutter/cupertino.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/group_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/user_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/current_user_session_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/group_usecases.dart';

class JoinGroupUseCase implements IJoinGroupUseCase{
  final IGroupRepo groupRepo;
  final IMemberLocalRepo memberLocalRepo;
  final ICurrentUserSession currentUserSession;

  const JoinGroupUseCase(this.groupRepo, this.memberLocalRepo, this.currentUserSession);

  @override
  Future<void> execute(int groupID) async {
    final userUUID = await currentUserSession.getCurrentUserUUID();
    if(userUUID == null) return;

    final hasGroup = await memberLocalRepo.getGroupID(userUUID);
    if(hasGroup != null) return;

    await groupRepo.joinGroup(userUUID, groupID);
    await memberLocalRepo.setGroupID(userUUID, groupID);


    debugPrint('member has joined a group');

    return;
  }
}