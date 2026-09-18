
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:salud_ulv_app/src/core/models/user.dart';
// import 'package:salud_ulv_app/src/core/repositories/repos/auth_repo.dart';

// class AuthRepoTester implements IAuthExtRepo{

//   @override
//   Future<bool> registerUser(User user, String password) async {
//    return true;
//   }


//   @override
//   Future<String?> loginWithEmailOrCode(String input, String password) async {
//     // final body = jsonDecode("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiQjZFMkM0RjgtOUEzRC00RTFDLThGNkItM0Q3QTJFOUM1RjE0IiwidXNlckNvZGUiOiI5MDgwNzAiLCJyb2xlcyI6WyJNZW1iZXIiXSwiaWF0IjoxNzg2OTE1NzI5LCJleHAiOjE3ODc1MjA1Mjl9.SJ3-DaLFmMBAex9L-aVDbk6SXEMb7WM9XZ09kSPhinM");
//     //   final token = body['token'] as String;
//     //   debugPrint(token);

//     final token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiQjZFMkM0RjgtOUEzRC00RTFDLThGNkItM0Q3QTJFOUM1RjE0IiwidXNlckNvZGUiOiI5MDgwNzAiLCJyb2xlcyI6WyJNZW1iZXIiXSwiaWF0IjoxNzg2OTE1NzI5LCJleHAiOjE3ODc1MjA1Mjl9.SJ3-DaLFmMBAex9L-aVDbk6SXEMb7WM9XZ09kSPhinM";

//       return token;
//   }


//   @override
//   Future<void> resetPasswordWithEmail(String email, String newPassword) {
//     // TODO: implement resetPasswordWithEmail
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> deleteAccount(String email) {
//     // TODO: implement deleteAccount
//     throw UnimplementedError();
//   }
// }
