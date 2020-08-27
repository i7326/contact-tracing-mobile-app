part of 'contact_bloc.dart';

abstract class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object> get props => [];
}

class InitialContact extends ContactState {}

class ContactEmpty extends ContactState {}

class ContactLoading extends ContactState {}

class SavingContact extends ContactState {}

class SavingContactFailed extends ContactState {
  final String error;

  const SavingContactFailed({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'LoadFailure { error: $error }';
}

class SavingContactCompleted extends ContactState {}

class ContactScanning extends ContactState {
  final bool scanning;
  const ContactScanning({@required this.scanning}) : assert(scanning != null);

  @override
  List<Object> get props => [scanning];
}

class ContactsLoaded extends ContactState {
  final List<dynamic> contacts;
  const ContactsLoaded({@required this.contacts}) : assert(contacts != null);

  @override
  List<Object> get props => [contacts];
}

class ContactsEmpty extends ContactState {
  const ContactsEmpty();
  @override
  List<Object> get props => [];
}

class LoadFailure extends ContactState {
  final String error;

  const LoadFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'LoadFailure { error: $error }';
}
