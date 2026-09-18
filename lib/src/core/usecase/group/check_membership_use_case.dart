

import 'package:flutter/widgets.dart';
import 'package:salud_ulv_app/src/core/repositories/services/current_user_session_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/group_usecases.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sqflite/member_repo.dart';

class CheckMembershipUseCase implements ICheckGroupMembershipUseCase {
  final MemberLocalRepo memberLocalRepo;
  final ICurrentUserSession currentUserSession;

  const CheckMembershipUseCase(this.memberLocalRepo, this.currentUserSession);

  @override
  Future<bool> execute() async {
    final userUUID = await currentUserSession.getCurrentUserUUID();
    // debugPrint(userUUID);
    if(userUUID == null) return false;

    final groupID = await memberLocalRepo.getGroupID(userUUID);
    debugPrint('TIene un grupo asignado: $groupID');
    
    final hasGroup = groupID != null;
    debugPrint('TIene un grupo asignado: $hasGroup');

    return hasGroup;
  }
}