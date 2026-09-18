

abstract class GroupEvent {}

class LoadGroupsListEvent extends GroupEvent {}
class LoadMemberGroupEvent extends GroupEvent {}

class CheckGroupMembershipEvent extends GroupEvent{}

class JoinGroupEvent extends GroupEvent {
  final int groupID;

  JoinGroupEvent(this.groupID);
}

