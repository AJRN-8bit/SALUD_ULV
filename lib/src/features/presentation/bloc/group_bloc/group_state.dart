

import 'package:salud_ulv_app/src/core/models/group.dart';

abstract class GroupState {}

class GroupInitial extends GroupState {}
class GroupLoading extends GroupState {}

class GroupMember extends GroupState {}
class GroupNotMember extends GroupState {}


class ListGroupLoaded extends GroupState{
  final List<IGroup> departments;

  ListGroupLoaded(this.departments);
}


class GroupLoaded extends GroupState {
  final IGroup group;

  GroupLoaded(this.group);
}


class GroupError extends GroupState {
  final String message;

  GroupError(this.message);
}
