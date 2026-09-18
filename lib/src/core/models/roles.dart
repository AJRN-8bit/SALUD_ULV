

class RoleStrings {
  static const admin = "Admin";
  static const member = "Member";
  static const guest = "Guest";
}


enum UserRole { admin, member }

extension UserRoleParsing on String? {
  UserRole? toUserRole() => switch (this) {
    RoleStrings.admin => UserRole.admin,
    RoleStrings.member => UserRole.member,
    // RoleStrings.guest => UserRole.guest,
    _ => null, // unknown/unexpected role from backend
  };
}