import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coloc/ui/pages/login/login_form.dart';
import 'package:coloc/user_repository/user_repositor.dart';

import 'package:coloc/authentication/authentication.dart';
import 'package:coloc/ui/pages/login/bloc/login_bloc.dart';

class Login extends StatelessWidget {
  final UserRepository userRepository;

  Login({Key key, @required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // _onLoginButtonPressed() {
    //   BlocProvider.of<LoginBloc>(context).add(
    //     LoginButtonPressed(
    //       phrase: _phraseController.text,
    //     ),
    //   );
    // }

    return Scaffold(
      appBar: AppBar(title: Text('Login'), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: 'Change node client address',
          onPressed: () {
            BlocProvider.of<AuthenticationBloc>(context).add(ClearClientAddress());
          },
        ),
      ]),
      body: BlocProvider(
        create: (context) {
          return LoginBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            userRepository: userRepository,
          );
        },
        child: LoginForm(),
      ),
    );
  }
}
