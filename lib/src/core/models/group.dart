import 'package:salud_ulv_app/src/core/models/user.dart';

abstract class IGroup{
  int? groupID;
  String? name;
  String? description;
  // String? building;
  List<User>? members;

  IGroup({
    this.groupID,
    this.name,
    this.description,
    // this.building,
    this.members
  });
} 


class Group implements IGroup{
  @override
  int? groupID;
  @override
  String? name;
  @override
  String? description;
  @override
  // String? building;
  @override
  List<User>? members;

  Group({
    this.groupID,
    this.name,
    this.description,
    // this.building,
    this.members
  });
}