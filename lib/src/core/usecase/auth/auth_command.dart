
class AuthCommand {
  final String? userCode;
  final String email;
  final String password;

  AuthCommand({
    this.userCode,
    required this.email,
    required this.password
  });

  bool isValidUserID() {
    String idStr = userCode.toString();
    return idStr.length <= 6 && RegExp(r'^[0-9]+$').hasMatch(idStr);
  }

  bool validateEmail() {
    final pattern = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$");
    return pattern.hasMatch(email);
  }

  bool validatePassword() {
    final hasMinLength = password.length >= 8;
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    return hasMinLength && hasLetter && hasNumber;
  }
}