import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:salud_ulv_app/src/core/models/group.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/group_repo.dart';
import 'package:salud_ulv_app/src/core/data/DTOs/group_dto.dart';



class GroupController implements IGroupRepo{

  @override
  Future<List<IGroup>?> getGroupsList(int typeID) async {
    try {
      final baseUrl = dotenv.env['API_URL'];

      final response = await http.get(
        Uri.parse('$baseUrl/groups/get/$typeID'), 

      ).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timed out');
        }
      );


      if (response.statusCode != 200) {
        debugPrint(response.statusCode.toString());
        throw Exception('Couldnt load group info');
      }


      final body = jsonDecode(response.body);
      // debugPrint('Data from api: ${body['data']}');

      debugPrint('before converting api data');


      final data = (body['data'] as List)
        .map((item) => GroupDTO.fromJson(item as Map<String, dynamic>).toDomain())
        .toList();

      debugPrint('Data from api: $data');

      return data;

    } catch (e) {
      rethrow;
    }
  }



  @override
  Future<void> joinGroup(String userUUID, int groupID) async {
     try {
      final baseUrl = dotenv.env['API_URL'];

      debugPrint('En http para api: $userUUID, $groupID');

      final response = await http.post(
        Uri.parse('$baseUrl/groups/add'), 

        headers: {
            'Content-Type': 'application/json', 
          },

        body: jsonEncode({
          "groupID": groupID,
          "userUUID": userUUID
        })

      ).timeout(
        Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Request timed out');
        }
      );

      debugPrint('En http para api: datos enviados');


      if (response.statusCode != 201) {
        debugPrint(response.statusCode.toString());
        throw Exception('Couldnt register member to a group');
      }

      return;

    } catch (e) {
      rethrow;
    }
  }


  @override
  Future<IGroup?> getMemberGroup(int groupID) async {
    try {
      final baseUrl = dotenv.env['API_URL'];

      debugPrint('In http: $groupID');

      final response = await http.get(
        Uri.parse('$baseUrl/groups/get/members/$groupID'), 

      ).timeout(
        Duration(seconds: 20),
        onTimeout: () {
          throw Exception('Request timed out');
        }
      );


      if (response.statusCode != 200) {
        debugPrint(response.statusCode.toString());
        throw Exception('Couldnt load group info');
      }


      final body = jsonDecode(response.body);
      debugPrint('Data from api: ${body['data']}');


      final data = GroupDTO.fromJson(body['data']).toDomain();

      debugPrint('Sending data to use case');
      return data;

    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}