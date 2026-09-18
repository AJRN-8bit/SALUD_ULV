
import 'package:salud_ulv_app/src/core/models/group.dart';

abstract class IGroupRepo{
  Future<List<IGroup>?> getGroupsList(int typeID);
  Future<void> joinGroup(String userUUID, int groupID);
  Future<IGroup?> getMemberGroup(int groupID);
}