import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'Token.dart';

const MMW_URL = "https://staging.app.wikiwatershed.org/api";

const JSON_HEADERS = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
};

Future<Token> getToken(String username, String password) async {
  final body = json.encode({'username': username, 'password': password});
  final response =
      await http.post("$MMW_URL/token/", body: body, headers: JSON_HEADERS);

  if (response.statusCode == 200) {
    return Token.fromJson(json.decode(response.body));
  } else {
    throw Exception(
        "Error ${response.statusCode}: failed to get token for user $username.");
  }
}