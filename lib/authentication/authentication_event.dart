import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}
class ClearClientAddress extends AuthenticationEvent {}

class UnintializeApp extends AuthenticationEvent {}

class AppStarted extends AuthenticationEvent {}


class AddClient extends AuthenticationEvent {
  final String client;

  const AddClient({
    @required this.client,
  });

  @override
  List<Object> get props => [client];

  @override
  String toString() =>
      'AddClient { timestamp: $client }';
}

class LoggedIn extends AuthenticationEvent {
  final String token;

  const LoggedIn({@required this.token});

  @override
  List<Object> get props => [token];

  @override
  String toString() => 'LoggedIn { token: $token }';
}

class LoggedOut extends AuthenticationEvent {}