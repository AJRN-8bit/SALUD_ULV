

import 'package:salud_ulv_app/src/core/models/anthropometrics.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/anthro_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/check_connection_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/anthropometric_usecase.dart';

class GetByUserCodeUsecase implements IGetByUserCodeAdminUseCase{
  final IAnthropometricExtRepo anthropometricExtRepo;
  final ICheckConnectionRepo checkConnectionRepo;

  const GetByUserCodeUsecase(this.anthropometricExtRepo, this.checkConnectionRepo);

  @override
  Future<List<Anthropometrics>?> execute(String input) async {
    final hasConnection = await checkConnectionRepo.hasConnection();
    if(!hasConnection) throw Exception("No internet");

    final data = await anthropometricExtRepo.getByUserCode(input);
    if(data == null || data.isEmpty) return null;

    return data;
  }
}