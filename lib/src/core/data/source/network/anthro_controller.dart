
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:salud_ulv_app/src/core/models/anthropometrics.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/anthro_repo.dart';
import 'package:salud_ulv_app/src/core/data/DTOs/anthro_dto.dart';

class AnthroController implements IAnthropometricExtRepo{
  @override
  Future<void> send(Anthropometrics data) async {
      
    try {
      final baseUrl = dotenv.env['API_URL'];
      final anthroData = AnthropometricsDTO.fromDomain(data).toJson();


      final response = await http.post(
        Uri.parse('$baseUrl/anthropometric/save'),
        headers: {'Content-Type': 'application/json'},

        body: jsonEncode(anthroData),   
      )
      .timeout(Duration(seconds: 5));
      
      if (response.statusCode != 200) {
      debugPrint(response.statusCode.toString());
      throw Exception('Error al registrar antropometricos');
      }

      debugPrint("Sending item to API");

    } catch (e) {
      rethrow;
    }

  }


  @override
  Future<List<Anthropometrics>?> getAll() async {
    try {
      final baseUrl = dotenv.env['API_URL'];

      final response = await http.get(
        Uri.parse('$baseUrl/anthropometric/get/all'),  

      ).timeout(
        Duration(seconds: 5),
        onTimeout: () {
          throw Exception('Request timed out');
        }
      );
      
      if (response.statusCode != 200) {
      debugPrint(response.statusCode.toString());
      throw Exception('Couldnt get data');
      }

      final body = jsonDecode(response.body);
      debugPrint('Data from api: $body');

      debugPrint("Taking data from API");

      return (body['data'] as List)
        .map((item) => AnthropometricsDTO.fromJson(item as Map<String, dynamic>).toDomain())
        .toList();


    } catch (e) {
      rethrow;
    }
  }


  @override
  Future<List<Anthropometrics>?> getByUserCode(String input) async {
    try {
      final baseUrl = dotenv.env['API_URL'];

      final response = await http.get(
        Uri.parse('$baseUrl/anthropometric/get/$input'), 

      ).timeout(
        Duration(seconds: 5),
        onTimeout: () {
          throw Exception('Request timed out');
        }
      );


      if (response.statusCode != 200) {
      debugPrint(response.statusCode.toString());
      throw Exception('Couldnt get data');
      }

      final body = jsonDecode(response.body);
      debugPrint('Data from api: $body');

      debugPrint("Taking data from API");

      return (body['data'] as List)
        .map((item) => AnthropometricsDTO.fromJson(item as Map<String, dynamic>).toDomain())
        .toList();

    } catch (e) {
      rethrow;
    }
  }



  @override
  Future<List<Map<String, dynamic>>?> getByCodeAndField(String input, String field) {
    // TODO: implement getByField
    throw UnimplementedError();
  }
}