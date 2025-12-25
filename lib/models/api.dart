import 'dart:convert';

import 'package:dashboard/models/login_model.dart';
import 'package:http/http.dart' as http;

class Api {
  String BaseUrl = "http://127.0.0.1:8000/api/v1/";
  Future<String?> login(LoginModel model) async {
    String? token;
    Uri url = Uri.parse("${BaseUrl}login");
    http.Response response = await http.post(
      url,
      body: json.encode({
        "phone_number": model.phoneNumber,
        "password": model.password,
      }),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      token = data['data']['token'];
    } else {
      print(data['message']);
    }

    return token;
  }
}
