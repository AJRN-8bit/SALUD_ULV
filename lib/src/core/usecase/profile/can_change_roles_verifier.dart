

import 'package:flutter/cupertino.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/user_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/current_user_session_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/profile_usecase.dart';

class CanChangeRolesVerifier implements ICanChangeRole {
  final ICurrentUserSession currentUserSession;
  final IUserLocalRepo userLocalRepo;

  const CanChangeRolesVerifier(this.currentUserSession, this.userLocalRepo);

  @override
  Future<bool> execute() async {
    final userUUID = await currentUserSession.getCurrentUserUUID();
    if(userUUID == null) return false;

    final roles = await userLocalRepo.getRoles(userUUID);
    if(roles == null) return false;

    final hasRoles = roles.length > 1;
    debugPrint('User has multiple roles: $hasRoles');
    return hasRoles;
  }
}