import 'package:salud_ulv_app/src/core/models/anthropometrics.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/anthro_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/check_connection_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/anthropometric_usecase.dart';

class GetallAnthroAdminUsecase implements IGetAllAnthroUseCase{
  final IAnthropometricExtRepo anthropometricRepo;
  final ICheckConnectionRepo checkConnectionRepo;

  const GetallAnthroAdminUsecase(this.anthropometricRepo, this.checkConnectionRepo);

  @override
  Future<List<Anthropometrics>?> execute() async{
    final hasConnection = await checkConnectionRepo.hasConnection();
    if(!hasConnection) throw Exception("No internet");

    final allAnthro = await anthropometricRepo.getAll();
    if(allAnthro == null || allAnthro.isEmpty) return null;

    return allAnthro;
  }
}