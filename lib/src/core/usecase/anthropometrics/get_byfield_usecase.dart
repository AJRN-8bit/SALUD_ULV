import 'package:salud_ulv_app/src/core/repositories/repos/anthro_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/current_user_session_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/anthropometric_usecase.dart';

class GetByfieldAnthroUsecase implements IGetByFieldAnthroUseCase{
  final IAnthropometricLocalRepo anthropometricRepo;
  final ICurrentUserSession currentUserSession;

  const GetByfieldAnthroUsecase(this.anthropometricRepo, this.currentUserSession);

  @override
  Future<List<Map<String, dynamic>>?> execute(String field) async{
    final userUUID = await currentUserSession.getCurrentUserUUID();
    if(userUUID == null) return null;

    final fieldAnthro = await anthropometricRepo.getByField(userUUID, field);
    if(fieldAnthro == null || fieldAnthro.isEmpty) return null;

    return fieldAnthro;
  }
}