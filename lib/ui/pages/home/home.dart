import 'package:flutter/material.dart';
import 'package:coloc/ui/widgets/tiles_widget.dart';
import 'package:coloc/ui/pages/home/corona_precuations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coloc/ui/pages/home/bloc/scan_bloc.dart';
import 'package:coloc/ui/pages/home/bloc/flag_bloc.dart';
import 'package:coloc/user_repository/user_repositor.dart';
import 'package:coloc/flag_repository/flag_repository.dart';
import 'package:coloc/model/flag_status.dart';

class HomeWidget extends StatefulWidget {
  final ScanBloc scanBloc;
  final FlagBloc flagBloc;
  HomeWidget({this.scanBloc, this.flagBloc});
  @override
  State<StatefulWidget> createState() {
    return HomeStateWidget(scanBloc: scanBloc, flagBloc: flagBloc);
  }
}

class HomeStateWidget extends State<HomeWidget> {
  final ScanBloc scanBloc;
  final FlagBloc flagBloc;
  HomeStateWidget({this.scanBloc, this.flagBloc});
  FlagStatus flagStatus(String type) {
    FlagStatus status;
    if (type == "suspicious") {
      status = FlagStatus.fromJson(
          {"color": Colors.amber, "text": "Possible Exposure  Detected"});
    } else if (type == "positive") {
      status = FlagStatus.fromJson(
          {"color": Colors.deepOrange, "text": "Please Quarantine yourself"});
    } else {
      status =
          FlagStatus.fromJson({"color": Colors.green, "text": "You are Safe"});
    }
    return status;
  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ScanBloc>.value(value: scanBloc),
        BlocProvider<FlagBloc>.value(value: flagBloc),
      ],
      child: Container(
        child: Column(
          children: <Widget>[
            BlocBuilder<FlagBloc, FlagState>(builder: (context, state) {
              if (state is FlagNotLoaded || state is SavingCompleted) {
                BlocProvider.of<FlagBloc>(context).add(FetchFlag());
              } else if (state is FlagLoaded) {
                final status = flagStatus(state.flag.type);
                return TilesWidget(color: status.color, status: status.text);
              } else if (state is LoadFailure) {
                return Center(
                  child: Text("Failed to load status"),
                );
              } else if (state is SaveFailure) {
                BlocProvider.of<FlagBloc>(context).add(FetchFlag());
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
            Container(
                padding: const EdgeInsets.all(24.0),
                child: Material(
                    color: Colors.grey,
                    elevation: 14.0,
                    borderRadius: BorderRadius.circular(12.0),
                    shadowColor: Color(0x802196F3),
                    child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/corona.png"),
                              alignment: Alignment.bottomRight,
                            ),
                          ),
                          width: 1.7976931348623157e+308,
                          height: 150.0,
                          child: Container(
                            child: Container(
                              padding: const EdgeInsets.all(0.0),
                              alignment: Alignment.topCenter,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    new Text(
                                      "Fight against Corona together",
                                      style: new TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Roboto"),
                                    ),
                                    new Padding(
                                      child: new Container(
                                        child: new Text(
                                          "Prepare yourself, Dont Panic",
                                          style: new TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Roboto"),
                                        ),
                                        padding: const EdgeInsets.all(0.0),
                                        alignment: Alignment.topLeft,
                                        width: 1.7976931348623157e+308,
                                        height: 80.0,
                                      ),
                                      padding: const EdgeInsets.fromLTRB(
                                          15.0, 15.0, 14.0, 15.0),
                                    )
                                  ]),
                            ),
                            padding:
                                const EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 1.0),
                            alignment: Alignment.topCenter,
                            width: 1.7976931348623157e+308,
                            height: 1.7976931348623157e+308,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute<void>(
                              builder: (BuildContext context) {
                            return Scaffold(
                              body: Container(
                                alignment: Alignment.topLeft,
                                child: CoronaPrecuations(),
                              ),
                            );
                          }));
                        }))),
            BlocBuilder<FlagBloc, FlagState>(builder: (context, state) {
              if (state is FlagLoaded) {
                final status = flagStatus(state.flag.type);
                return BlocBuilder<ScanBloc, ScanState>(
                    builder: (context, state) {
                  if (state is Scanning) {
                    return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SpinKitDoubleBounce(
                          color: status.color,
                          size: 150,
                        ));
                  }
                  return Container(
                      alignment: Alignment.center,
                      height: 150,
                      child: Text("Not Scanning"));
                });
              }
              // if (state is !ScanningStarted) {
              //   return Padding(
              //       padding: const EdgeInsets.all(5.0),
              //       child: SpinKitDoubleBounce(
              //         color: Colors.amber,
              //         size: 150,
              //       ));
              // }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
