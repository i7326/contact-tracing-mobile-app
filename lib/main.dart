import 'package:flutter/material.dart';
import 'package:coloc/config/ui.dart';
import 'package:coloc/config/routes.dart';
import 'package:coloc/ui/pages/home/index.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coloc/authentication/authentication.dart';
import 'package:coloc/user_repository/user_repositor.dart';
import 'package:coloc/ui/pages/login/login.dart';
import 'package:coloc/ui/pages/splash/splash.dart';
import 'package:coloc/ui/pages/common/loadingindicator.dart';
import 'package:coloc/contact_repository/contact_repository.dart';
import 'package:coloc/contact_repository/contact_api_client.dart';
import 'package:coloc/flag_repository/flag_repository.dart';
import 'package:coloc/flag_repository/flag_api_client.dart';
import 'package:coloc/ui/pages/home/bloc/contact_bloc.dart';
import 'package:coloc/ui/pages/home/bloc/flag_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;


class StateBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

Future<String> _checkClientAddress(context, cb) async {
  final storage = new Storage.FlutterSecureStorage();
  final _clientAddressController = TextEditingController(text: 'http://localhost:8081');
  String clientAddress;
  try {
    clientAddress = await storage.read(key: 'clientAddress');
  } catch (err) {
    throw new Exception(err);
  }
  return clientAddress != null
      ? cb(clientAddress)
      : showDialog<String>(
          context: context,
          barrierDismissible:
              false, // dialog is dismissible with a tap on the barrier
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Enter NodeJs Client Address'),
              content: new Row(
                children: <Widget>[
                  new Expanded(
                      child: new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(
                      labelText: 'Client Address',
                      hintText: 'http://localhost:8081',
                    ),
                    controller: _clientAddressController,
                  ))
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    cb(_clientAddressController.text);
                    Navigator.of(context).pop(clientAddress);
                  },
                ),
              ],
            );
          },
        );
}

void main() {
  BlocSupervisor.delegate = StateBlocDelegate();
  final userRepository = UserRepository();
  final flagRepository =
      FlagRepository(flagApiClient: FlagApiClient(httpClient: http.Client()));
  final contactRepository = ContactRepository(
      contactApiClient: ContactApiClient(httpClient: http.Client()));
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(create: (context) {
          return AuthenticationBloc(userRepository: userRepository);
          //  ..add(AppStarted());
        }),
        BlocProvider<ContactBloc>(create: (context) {
          return ContactBloc(
              repository: contactRepository, userRepository: userRepository);
        }),
        BlocProvider<FlagBloc>(create: (context) {
          return FlagBloc(
              flagRepository: flagRepository, userRepository: userRepository);
        })
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  final materialApp = MaterialApp(
      title: UIConfig.appName,
      theme: ThemeData(
          primaryColor: Colors.white,
          fontFamily: UIConfig.quickFont,
          primarySwatch: Colors.amber),
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationUninitialized) {
            _checkClientAddress(
                context,
                (String client) => BlocProvider.of<AuthenticationBloc>(context)
                    .add(AddClient(client: client)));
          }
          if (state is ClientAddressLoaded) {
            BlocProvider.of<AuthenticationBloc>(context).add(AppStarted());
          }
          if (state is AuthenticationAuthenticated) {
            return Home(
                userRepository: RepositoryProvider.of<UserRepository>(context));
          }
          if (state is AuthenticationUnauthenticated) {
            return Login(
                userRepository: RepositoryProvider.of<UserRepository>(context));
          }
          if (state is AuthenticationLoading) {
            return LoadingIndicator();
          }
          return SplashPage();
        },
      ),
      // initialRoute: UIData.notFoundRoute,

      //routes
      routes: <String, WidgetBuilder>{
        RoutesConfig.HOME: (BuildContext context) => Home(
            userRepository: RepositoryProvider.of<UserRepository>(context)),
      });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(providers: [
      RepositoryProvider(create: (context) => UserRepository()),
      RepositoryProvider(
          create: (context) => ContactRepository(
              contactApiClient: ContactApiClient(httpClient: http.Client()))),
      RepositoryProvider(
          create: (context) => FlagRepository(
              flagApiClient: FlagApiClient(httpClient: http.Client())))
    ], child: materialApp);
  }
}
