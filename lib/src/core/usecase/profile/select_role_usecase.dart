
import 'package:salud_ulv_app/src/core/repositories/repos/user_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/current_user_session_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/profile_usecase.dart';

class SelectRoleUseCase implements ISelectRoleUseCase {

  final ICurrentUserSession currentUserSession;
  final IUserLocalRepo userLocalRepo;

  const SelectRoleUseCase(this.currentUserSession, this.userLocalRepo);

  @override
  Future<String?> execute(String role) async {
    final userUUID = await currentUserSession.getCurrentUserUUID();
    if(userUUID == null) return null;

    final roles = await userLocalRepo.getRoles(userUUID);
    if(roles == null) return null;

    final containsRole = roles.contains(role);

    if(!containsRole) return null;

    await userLocalRepo.setCurrentRole(userUUID, role);
    return role;
  }
}