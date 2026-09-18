
import 'package:flutter/cupertino.dart';
import 'package:salud_ulv_app/src/core/models/group.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/group_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/user_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/check_connection_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/current_user_session_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/group_usecases.dart';

class GetMemberGroupUseCase implements IGetMemberGroupUseCase{
  final ICurrentUserSession currentUserSession;
  final IGroupRepo groupRepo;
  final IMemberLocalRepo memberLocalRepo;
  final ICheckConnectionRepo checkConnectionRepo;

  const GetMemberGroupUseCase(this.currentUserSession, this.groupRepo, this.memberLocalRepo, this.checkConnectionRepo);

  @override
  Future<IGroup?> execute() async{
    final hasConnection = await checkConnectionRepo.hasConnection();
    if(!hasConnection) throw Exception('No connection');

    debugPrint('getting user uuid');
    final userUUID = await currentUserSession.getCurrentUserUUID();
    if(userUUID == null) return null;

    debugPrint('getting groupid');
    final groupID = await memberLocalRepo.getGroupID(userUUID);
    if(groupID == null) return null;

    debugPrint('getting group');
    final group = await groupRepo.getMemberGroup(groupID);
    if(group == null) return null;

    
    debugPrint('sending back group');
    return group;
  }
}