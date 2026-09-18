// import 'package:salud_ulv_app/src/core/models/member.dart';
import 'package:salud_ulv_app/src/core/models/user.dart';

// All user are gonna be memeber as default
abstract class IAuthExtRepo{
  // Future<void> registerSignUpCredentials(String userCode, String email, String password, String confirmedPw);
  Future<bool> userExists(String userCode, String email);
  Future<bool> registerMember(User user, String password, int typeID); // user
  // member info comes after registry
  Future<String?> loginWithEmailOrCode(String input, String password);
  Future<void> resetPasswordWithEmail(String email, String newPassword);
  Future<void> deleteAccount(String email);
}