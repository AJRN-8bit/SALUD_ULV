import 'package:salud_ulv_app/src/core/models/anthropometrics.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/anthro_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/current_user_session_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/anthropometric_usecase.dart';

class GetRecentAnthroUsecase implements IGetRecentAnthroUseCase{
  final IAnthropometricLocalRepo anthropometricRepo;
  final ICurrentUserSession currentUserSession;

  const GetRecentAnthroUsecase(this.anthropometricRepo, this.currentUserSession);

  @override
  Future<Anthropometrics?> execute() async{
    final userUUID = await currentUserSession.getCurrentUserUUID();
    if(userUUID == null) return null;

    final recentAnthro = await anthropometricRepo.getRecent(userUUID);
    if(recentAnthro == null) return null;

    return recentAnthro;
  }
}