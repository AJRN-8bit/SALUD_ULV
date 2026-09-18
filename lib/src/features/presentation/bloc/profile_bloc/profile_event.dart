
abstract class ProfileEvent {}

class GetProfileEvent extends ProfileEvent{}
class GetUserNameEvent extends ProfileEvent{}

class CanChangeRoleEvent extends ProfileEvent{}

class SelectRoleEvent extends ProfileEvent{
  final String role;

  SelectRoleEvent(this.role);
}
