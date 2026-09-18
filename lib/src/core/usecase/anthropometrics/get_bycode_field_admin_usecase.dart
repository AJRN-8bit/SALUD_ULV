

import 'package:salud_ulv_app/src/core/repositories/repos/anthro_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/anthropometric_usecase.dart';

class GetByCodeAndFieldAnthroUsecase implements IGetByCodeAndFieldAnthroAdminUseCase{
  final IAnthropometricExtRepo anthropometricExtRepo;

  const GetByCodeAndFieldAnthroUsecase(this.anthropometricExtRepo);

  @override
  Future<List<Map<String, dynamic>>?> execute(String input, String field) async {
    final data = await anthropometricExtRepo.getByCodeAndField(input, field);
    if(data == null || data.isEmpty) return null;

    return data;
  }
}