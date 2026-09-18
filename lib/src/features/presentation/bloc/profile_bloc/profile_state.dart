
import 'package:salud_ulv_app/src/core/models/user.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState{}
class ProfileLoading extends ProfileState{}

class ProfileLoaded extends ProfileState{
  final IUser user;
  ProfileLoaded(this.user);
}

class CanChangeRole extends ProfileState{
  final bool canChange;
  CanChangeRole(this.canChange);
}

class RoleSelected extends ProfileState{
  final String role;
  RoleSelected(this.role);
}

class UserNameLoaded extends ProfileState {
  final List<String> name;
  UserNameLoaded(this.name);
}


class ProfileError extends ProfileState{
  final String message;
  ProfileError(this.message);
}

