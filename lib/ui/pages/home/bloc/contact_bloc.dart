import 'dart:async';

import 'package:coloc/ui/pages/home/bloc/scan_bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:coloc/user_repository/user_repositor.dart';
import 'package:coloc/model/contact.dart';
import 'package:coloc/contact_repository/contact_repository.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepository repository;
  final UserRepository userRepository;

  ContactBloc({@required this.repository, @required this.userRepository})
      : assert(repository != null),
        assert(userRepository != null);

  @override
  ContactState get initialState => InitialContact();

  @override
  Stream<ContactState> mapEventToState(ContactEvent event) async* {
    if (event is FetchContacts) {
      yield ContactLoading();
      try {
        final List contacts =
            await repository.fetchContacts(await userRepository.getToken());
        if (contacts.isEmpty) {
          yield ContactsEmpty();
          return;
        }
        yield ContactsLoaded(contacts: contacts);
      } catch (error) {
        yield LoadFailure(error: error.toString());
      }
    } else if (event is AddContact) {
      try {
        yield SavingContact();
        final token = await userRepository.getToken();
        final response = await repository.saveContact(
            Contact(
                id: event.id,
                type: event.type,
                location: event.location,
                timestamp: event.timestamp),
            token);
            yield SavingContactCompleted();
      } catch (error) {
        yield SavingContactFailed(error: error.toString());
      }
    }
  }
}
