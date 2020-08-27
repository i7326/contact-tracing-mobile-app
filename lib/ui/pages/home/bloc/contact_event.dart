part of 'contact_bloc.dart';

abstract class ContactEvent extends Equatable {
  const ContactEvent();
}

class AddContact extends ContactEvent {
  final String id;
  final String location;
  final int timestamp;
  final String type;

  const AddContact({
    @required this.id,
    @required this.location,
    @required this.timestamp,
    @required this.type,
  });

  @override
  List<Object> get props => [id, location, timestamp, type];

  @override
  String toString() =>
      'AddContact { id: $id, location: $location, timestamp: $timestamp, type: $type }';
}

class FetchContacts extends ContactEvent {
  const FetchContacts();

  @override
  List<Object> get props => [];
}

