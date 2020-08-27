part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];

}

class LoginButtonPressed extends LoginEvent {
  final String phrase;

  const LoginButtonPressed({
    @required this.phrase,
  });

  @override
  List<Object> get props => [phrase];

  @override
  String toString() =>
      'LoginButtonPressed { phrase: $phrase }';
}

class GenerateButtonPressed extends LoginEvent {}