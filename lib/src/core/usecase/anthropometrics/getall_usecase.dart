import 'package:salud_ulv_app/src/core/models/anthropometrics.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/anthro_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/current_user_session_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/anthropometric_usecase.dart';

class GetallAnthroUsecase implements IGetAllAnthroUseCase{
  final IAnthropometricLocalRepo anthropometricRepo;
  final ICurrentUserSession currentUserSession;

  const GetallAnthroUsecase(this.anthropometricRepo, this.currentUserSession);

  @override
  Future<List<Anthropometrics>?> execute() async{
    final userUUID = await currentUserSession.getCurrentUserUUID();
    if(userUUID == null) return null;

    final allAnthro = await anthropometricRepo.getAll(userUUID);
    if(allAnthro == null || allAnthro.isEmpty) return null;

    return allAnthro;
  }
}