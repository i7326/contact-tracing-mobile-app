import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:coloc/config/api_config.dart';
import 'package:coloc/model/contact.dart';

class ContactApiClient {
  final http.Client httpClient;

  ContactApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List> fetchContacts(String token) async {
    final url = '${APIConfig.SERVER_IP}/contacts';
    final response = await this
        .httpClient
        .get(url, headers: {"Authorization": "Bearer $token"});
    if (response.statusCode != 200) {
      throw new Exception('error getting contacts');
    }

    final json = jsonDecode(response.body);
    return json.map((contact) => Contact.fromJson(contact)).toList();
  }

  Future<bool> saveContact(Contact contact, String token) async {
    try {
      final url = '${APIConfig.SERVER_IP}/contacts';
      final json = jsonEncode(contact);
      final response = await this
          .httpClient
          .post(url, body: json, headers: {"Authorization": "Bearer $token"});

      if (response.statusCode != 200) {
        throw new Exception('Error saving contacts');
      }
    } catch (err) {
      throw new Exception(err);
    }
    return true;
  }
}
