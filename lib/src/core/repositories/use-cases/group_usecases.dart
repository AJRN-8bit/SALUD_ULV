

import 'package:salud_ulv_app/src/core/models/group.dart';

abstract class IGetGroupListUseCase{
  Future<List<IGroup>?> execute();
}

abstract class IJoinGroupUseCase {
  Future<void> execute(int groupID);
}

abstract class IGetMemberGroupUseCase {
  Future<IGroup?> execute(); 
}

abstract class ICheckGroupMembershipUseCase {
  Future<bool> execute();
}