import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'Boundary.dart';
import 'JobStatus.dart';
import 'Token.dart';

const MMW_URL = "https://staging.app.wikiwatershed.org";

const JSON_HEADERS = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
};

Future<Token> getToken(String username, String password) async {
  final body = json.encode({'username': username, 'password': password});
  final response =
      await http.post("$MMW_URL/api/token/", body: body, headers: JSON_HEADERS);

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

  get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token ${token.token}',
      };

  Future<List<Boundary>> getSuggestions(String query) async {
    final response = await http.get(
        "$MMW_URL/mmw/modeling/boundary-layers-search/?text=$query",
        headers: JSON_HEADERS);
    if (response.statusCode == 200) {
      return (json.decode(response.body)['suggestions'] as List)
          .map((b) => Boundary.fromJson(b))
          .toList();
    } else {
      throw Exception(
          "Error ${response.statusCode}: could not get suggestions for $query");
    }
  }

  Future<JobStatus> postLand(Boundary boundary) async {
    final response = await http.post(
      "$MMW_URL/api/analyze/land/?wkaoi=${boundary.huc.code}__${boundary.id}",
      headers: headers,
    );

    if (response.statusCode == 200) {
      final jobId = json.decode(response.body)['job'];

      return poll(jobId);
    } else {
      throw Exception(
          "Error ${response.statusCode}: could not start land analysis for ${boundary.name}");
    }
  }

  Future<JobStatus> poll(String jobId) async {
    final response = await http.get(
      "$MMW_URL/api/jobs/$jobId/",
      headers: headers,
    );

    if (response.statusCode == 200) {
      return JobStatus.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          "Error ${response.statusCode}: could not poll for $jobId");
    }
  }
}
