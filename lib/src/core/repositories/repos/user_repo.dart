import 'package:salud_ulv_app/src/core/models/member.dart';
import 'package:salud_ulv_app/src/core/models/user.dart';

// General user repository methods 

abstract class IUsersLocalRepo {
  Future<IUser?> getUser(String userUUID);
  Future<void> delete(String uuid);
}

abstract class IUserLocalRepo extends IUsersLocalRepo {
  Future<void> save(User user);
  Future<void> update(User user);
  Future<void> setCurrentRole(String userUUID, String currentRole);
  Future<String?> getCurrentRole(String userUUID);
  // Future<void> changeCurrentRole(String role, List<String> roles);
  Future<void> setRoles(String userUUID, List<String> roles);
  Future<List<String>?> getRoles(String userUUID);

  Future<List<String>?> getName(String userUUID);
}


abstract class IMemberLocalRepo extends IUsersLocalRepo {
  Future<void> saveInfo(MemberInfo memberInfo);

  Future<void> setGroupID(String userUUID, int groupID);
  Future<int?> getGroupID(String userUUID);
  Future<int?> getMemberTypeID(String userUUID);
}

