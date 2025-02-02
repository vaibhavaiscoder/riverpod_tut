import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import 'models/createUserModel.dart';
import 'models/userModel.dart';

final apiServiceProvider = Provider<ApiServices>((ref) => ApiServices());

class ApiServices {
  String baseUrl = 'https://reqres.in/api';

  // get items
  Future<List<Datum>> getUsers() async {
    Response response = await get(Uri.parse("$baseUrl/users?page=2"));
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)['data'];
      return result.map(((e) => Datum.fromJson(e))).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  // post items
  Future<CreateUser> createUser(name, job) async {
    Response response = await post(Uri.parse("$baseUrl/users"),
        headers: {"Content-Type" : "application/json"},
        body: jsonEncode({'name': name, 'job': job}));
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      return CreateUser.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
