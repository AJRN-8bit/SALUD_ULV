
import 'package:salud_ulv_app/src/core/models/user.dart';

abstract class IGetProfileInfoUsecase {
  Future<IUser?> execute();
}

abstract class ICanChangeRole{
  Future<bool> execute();
}

abstract class ISelectRoleUseCase{
  Future<String?> execute(String role);
}

abstract class ISetGenderUseCase{
  Future<void> execute(String gender);
}

abstract class IGetUserNameUseCase {
  Future<List<String>?> execute();
}