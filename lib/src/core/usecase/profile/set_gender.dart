

import 'package:salud_ulv_app/src/core/repositories/repos/user_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/current_user_session_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/profile_usecase.dart';

class SetGenderUseCase implements ISetGenderUseCase {

  final IMemberLocalRepo memberLocalRepo;
  final ICurrentUserSession currentUserSession;

  const SetGenderUseCase(this.memberLocalRepo, this.currentUserSession);

  @override
  Future<void> execute(String gender) async {
    final userUUID = await currentUserSession.getCurrentUserUUID();
    if(userUUID == null) return;

    await memberLocalRepo.setGender(userUUID, gender);
    return;
  }
}