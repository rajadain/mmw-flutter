import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'Boundary.dart';
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

class API {
  final Token token;

  API({this.token});

  static Future<API> fromCredentials(String username, String password) async {
    return API(token: await getToken(username, password));
  }

  Future<List<Boundary>> getSuggestions(String query) async {
    final response = await http.get(
        "$MMW_URL/mmw/modeling/boundary-layers-search/?text=$query",
        headers: JSON_HEADERS);

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((b) => Boundary.fromJson(b))
          .toList();
    } else {
      throw Exception(
          "Error ${response.statusCode}: could not get suggestions for $query");
    }
  }
}
