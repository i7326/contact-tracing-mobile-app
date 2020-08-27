import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:coloc/user_repository/user_repositor.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:coloc/authentication/authentication.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  AuthenticationBloc({@required this.userRepository})
      : assert(userRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if(event is ClearClientAddress) {
      await userRepository.clearClientAddress();
      yield AuthenticationUninitialized();
    }
    if (event is AddClient) {
      await userRepository.persistClientAddress(event.client);
      yield ClientAddressLoaded();
    }

    if (event is AppStarted) {
      final bool hasToken = await userRepository.hasToken();

      if (hasToken) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      final fcmToken = await _firebaseMessaging.getToken();
      final authToken = event.token;
      await userRepository.persistToken(event.token);
      await userRepository.saveFCMToken(fcmToken, authToken);
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}
