part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class GeneratingPhrase extends LoginState {}

class PhraseGenerated extends LoginState {
  final String phrase;
  const PhraseGenerated({@required this.phrase});

    @override
  List<Object> get props => [phrase];
}

class LoginLoading extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'LoginFailure { error: $error }';
}
