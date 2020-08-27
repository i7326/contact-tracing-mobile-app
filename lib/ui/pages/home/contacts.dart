import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coloc/ui/pages/home/bloc/contact_bloc.dart';

class ContactWidget extends StatefulWidget {
  final ContactBloc contactBloc;
  ContactWidget({this.contactBloc});
  @override
  State<StatefulWidget> createState() {
    return _ContactWidget(contactBloc: contactBloc);
  }
}

class _ContactWidget extends State<ContactWidget> {
  final ContactBloc contactBloc;
  _ContactWidget({this.contactBloc});
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: contactBloc,
        child:
            BlocBuilder<ContactBloc, ContactState>(builder: (context, state) {
          if (state is InitialContact || state is SavingContactCompleted) {
            BlocProvider.of<ContactBloc>(context).add(FetchContacts());
          }
          if (state is LoadFailure) {
            return Center(
              child: Text('failed to fetch contacts'),
            );
          }
          if (state is ContactsEmpty) {
            return Center(
              child: Text('No Contacts found'),
            );
          }
          if (state is ContactsLoaded) {
            return ListView(
              children: state.contacts
                  .map((e) => ListTile(
                        title: Text(
                          e.id,
                        ),
                        subtitle: Text("${e.location}\n${e.timestamp}"),
                        onTap: () {
                          Text('Another data');
                        },
                      ))
                  .toList(),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }));
  }
}
