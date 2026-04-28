import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:week_4_task/model/user_model.dart';

class ApiService {
  Future<UserModel> fetchUsers({int results = 20}) async {
    try {
      final response = await http.get(
        Uri.parse('https://randomuser.me/api/?results=$results'),
      ).timeout(Duration(seconds: 30));

      print('Response status: ${response.statusCode}'); // Debug

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } on http.ClientException catch (e) {
      print('Client Exception: $e');
      throw Exception("Network Error: Please check your internet connection");
    } catch (e) {
      print('Error: $e');
      throw Exception("Error: $e");
    }
  }
}