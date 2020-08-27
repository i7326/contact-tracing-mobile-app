import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:coloc/config/api_config.dart';
import 'package:coloc/model/flag.dart';
import 'package:coloc/user_repository/user_repositor.dart';

class FlagApiClient {
  final http.Client httpClient;

  FlagApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<Flag> fetchFlag(String token) async {
    try {
      final url = '${APIConfig.SERVER_IP}/contacts/flag';
      final response = await this
          .httpClient
          .get(url, headers: {"Authorization": "Bearer $token"});
      if (response.statusCode != 200) {
        throw new Exception('Error Fetching Flag');
      }

      final json = jsonDecode(response.body);
      return (json.length > 0)
          ? Flag.fromJson(json[0])
          : Flag.fromJson({
              "timestamp": new DateTime.now().millisecondsSinceEpoch,
              "type": "negative"
            });
    } catch (err) {
      throw new Exception(err);
    }
  }

  Future<bool> saveFlag(Flag flag, String token) async {
    try {
      final url = '${APIConfig.SERVER_IP}/contacts/flag';
      final json = jsonEncode(flag);
      final response = await this
          .httpClient
          .post(url, body: json, headers: {"Authorization": "Bearer $token"});

      if (response.statusCode != 200) {
        throw new Exception('Error updating Flag');
      }
    } catch (err) {
      throw new Exception(err);
    }
    return true;
  }
}
