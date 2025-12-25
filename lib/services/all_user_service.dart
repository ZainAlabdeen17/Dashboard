import 'dart:convert';

import 'package:dashboard/models/user.dart';
import 'package:http/http.dart' as http;

class AllUserService {
  Future<List<User>> getAllUsers(String token) async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/v1/admin/users/'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    dynamic data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      List<User> users = [];
      users = List<User>.from(data['data']['data']);
      print(users);
      return users;
      
    } else {
      throw Exception(response.statusCode);
    }
  }
}
