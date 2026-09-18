
import 'package:salud_ulv_app/src/core/repositories/repos/user_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/current_user_session_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/profile_usecase.dart';

class GetUserNameUseCase implements IGetUserNameUseCase{
  final ICurrentUserSession currentUserSession;
  final IUserLocalRepo userLocalRepo;

  const GetUserNameUseCase({required this.currentUserSession, required this.userLocalRepo});

  @override
  Future<List<String>?> execute() async{
    final userUUID = await currentUserSession.getCurrentUserUUID();
    if(userUUID == null) return null;

    final name = await userLocalRepo.getName(userUUID);
    if(name == null) return null;

    return name;
  }

}