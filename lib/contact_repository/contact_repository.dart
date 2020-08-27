import 'dart:async';

import 'package:meta/meta.dart';

import 'package:coloc/contact_repository/contact_api_client.dart';
import 'package:coloc/model/contact.dart';

class ContactRepository {
  final ContactApiClient contactApiClient;

  ContactRepository({@required this.contactApiClient})
      : assert(contactApiClient != null);

  Future<bool> saveContact(Contact contact, String token) async {
    return await contactApiClient.saveContact(contact, token);
  }

  Future<List> fetchContacts(String token) async {
    return await contactApiClient.fetchContacts(token);
  }
}
