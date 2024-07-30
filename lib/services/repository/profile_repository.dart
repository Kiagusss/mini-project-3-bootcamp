
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../model/profile_model.dart';

class ProfileRepository {
  final String apiUrl = "https://fakestoreapi.com/users/1";

  Future<Profile> fetchProfile() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return Profile.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load profile');
    }
  }
}
