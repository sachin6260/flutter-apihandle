import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiService {
  static Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(
      Uri.parse("https://reqres.in/api/users?page=2"),
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load users");
    }
  }
}
