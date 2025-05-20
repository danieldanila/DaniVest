import 'package:frontend/models/signup_data.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/constants/constants.dart' as constants;

class UserService {
  static Future<String> createUser(SignupData userBody) async {
    final response = await http.post(
      Uri.parse(
        "${constants.Strings.backendURL}${constants.Strings.createUserPath}",
      ),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(userBody),
    );

    if (response.statusCode == 201) {
      final responseBodyJson = jsonDecode(response.body);
      return responseBodyJson[constants.Strings.responseMessageFieldName];
    } else {
      return constants.Strings.genericError;
    }
  }
}
