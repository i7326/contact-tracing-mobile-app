import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coloc/ui/pages/login/bloc/login_bloc.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _phraseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() {
      BlocProvider.of<LoginBloc>(context).add(
        LoginButtonPressed(
          phrase: _phraseController.text,
        ),
      );
    }

    _onGenerateButtonPressed() {
      BlocProvider.of<LoginBloc>(context).add(
        GenerateButtonPressed(),
      );
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is PhraseGenerated) {
          _phraseController.text = state.phrase;
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  child: TextFormField(
                    maxLines: 3,
                    enabled: state is! LoginLoading ? true : false,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        labelText: "Pass Phrase",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0))),
                    controller: _phraseController,
                  ),
                  // child: DropdownButtonFormField(
                  //   decoration: InputDecoration(
                  //       contentPadding:
                  //           EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  //       labelText: "State",
                  //       border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(32.0))),
                  //   value: _stateController,
                  //   items: [{ "name": "Tamil Nadu", "value":'5e8e2249c045767a7c19167a'}]
                  //       .map((res) => DropdownMenuItem(
                  //             child: Text(res["name"].toString()),
                  //             value: res["value"].toString(),
                  //           ))
                  //       .toList(),
                  //   onChanged: (value) {
                  //     setState(() {
                  //       _stateController = value;
                  //     });
                  //   },
                  // )
                ),
                RaisedButton(
                  onPressed:
                      state is! LoginLoading ? _onGenerateButtonPressed : null,
                  child: Text('Generate'),
                ),
                RaisedButton(
                  onPressed:
                      state is! LoginLoading ? _onLoginButtonPressed : null,
                  child: Text('Login'),
                ),
                Container(
                  child: state is LoginLoading
                      ? CircularProgressIndicator()
                      : null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
