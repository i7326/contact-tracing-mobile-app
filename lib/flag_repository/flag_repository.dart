import 'dart:async';

import 'package:meta/meta.dart';

import 'package:coloc/flag_repository/flag_api_client.dart';
import 'package:coloc/model/flag.dart';

class FlagRepository {
  final FlagApiClient flagApiClient;

  FlagRepository({@required this.flagApiClient})
      : assert(flagApiClient != null);

  Future<bool> saveFlag(Flag flag, String token) async {
    return await flagApiClient.saveFlag(flag, token);
  }

  Future<Flag> fetchFlag(String token) async {
    return await flagApiClient.fetchFlag(token);
  }
}
