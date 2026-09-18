import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:salud_ulv_app/src/core/models/member.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/auth_repo.dart';
import 'package:salud_ulv_app/src/core/models/user.dart';
import 'package:salud_ulv_app/src/core/data/DTOs/member_dto.dart';
import 'package:salud_ulv_app/src/core/data/DTOs/user_dto.dart';



class AuthHTTPController implements IAuthExtRepo {

  @override
  Future<bool> userExists(String userCode, String email) async{
    try {
      final baseUrl = dotenv.env['API_URL'];


      final request = await http.post(
        Uri.parse('$baseUrl/auth/user/exists'),
          headers: {
            'Content-Type': 'application/json', 
          },

        body: jsonEncode({
          "userCode": userCode,
          "email": email
        })
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timed out');
        }
      );


      if (request.statusCode == 200) {
        debugPrint(request.statusCode.toString());
        return true;
        // throw Exception('Error al registrar usuario');
      }

      return false; 

      
    } catch (e) {
      debugPrint(' $e');
      rethrow;
    }
  }



  @override
  Future<bool> registerMember(User user, String password, int typeID) async {
    try {
      final baseUrl = dotenv.env['API_URL'];
      final userData = UserDTO.fromDomain(user).toJson();
      // userData["password"] = password;
      final body = jsonEncode({
          "user": userData,
          "password": password,
          "typeID": typeID
        });

        debugPrint(body);


      final request = await http.post(
        Uri.parse('$baseUrl/auth/register'),
          headers: {
            'Content-Type': 'application/json', 
          },

        body: body
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timed out');
        }
      );


      if (request.statusCode != 201) {
        debugPrint(request.statusCode.toString());
        return false;
        // throw Exception('Error al registrar usuario');
      }

      // this allows the user to be authenticated without having to login again after registration
      // final body = jsonDecode(request.body);
      // final token = body['token'] as String;
      // debugPrint(token);

      // return token;
      return true; // registered in API

      
    } catch (e) {
      debugPrint(' $e');
      rethrow;
    }
  }


  @override
  Future<String?> loginWithEmailOrCode(String input, String password) async{
    try {
      final baseUrl = dotenv.env['API_URL'];

      debugPrint('in http login: $input, $password ///////////////');

      final request = await http.post(
        Uri.parse('$baseUrl/auth/login'),
          headers: {
            'Content-Type': 'application/json', 
          },

        body: jsonEncode({
          "input": input.toString(),
          "password": password.toString()
        })
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timed out');
        }
      );

      if (request.statusCode != 200) {
        debugPrint(request.statusCode.toString());
        throw Exception('Error al iniciar sesión');
      }

      final body = jsonDecode(request.body);
      final token = body['token'] as String;
      debugPrint(token);

      return token;

      
    } catch (e) {
      debugPrint(' $e');
      rethrow;
    }
  }


  @override
  Future<void> resetPasswordWithEmail(String email, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.3:3030/auth/changePw'),
        headers: {
            'Content-Type': 'application/json', 
          },

          body: jsonEncode({
            "email": email,
            "newPassword": newPassword
          })

      );

        if (response.statusCode != 200) {
          debugPrint(response.statusCode.toString());
          throw Exception('Error al cambiar contraseña');
        }


    } catch (e) {
      debugPrint(' $e');
    }
  }

  @override
  Future<void> registerMemberInfo(MemberInfo info) async {
    try {

      final data = MemberInfoDTO.fromDomain(info).toJson();

      final response = await http.post(
        Uri.parse('http://192.168.1.3:3030/auth/saveMemberInfo'),
        headers: {
            'Content-Type': 'application/json', 
          },

          body: jsonEncode({ data })

      ).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timed out');
        }
      );

        if (response.statusCode != 200) {
          debugPrint(response.statusCode.toString());
          throw Exception('Error');
        }


    } catch (e) {
      debugPrint(' $e');
    }
  }


  @override
  Future<void> deleteAccount(String email) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.3:3030/auth/deleteAcc'),
        headers: {
            'Content-Type': 'application/json', 
          },

          body: jsonEncode({
            "email": email
          })

      );

        if (response.statusCode != 200) {
          debugPrint(response.statusCode.toString());
          throw Exception('Error al borrar usuario');
        }

    } catch (e) {
      debugPrint(' $e');
    }
  }
}