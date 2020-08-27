import 'dart:async';

import 'package:coloc/model/user.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:coloc/user_repository/user_repositor.dart';
import 'package:location/location.dart';
import 'package:flutter_blue/flutter_blue.dart';

part 'scan_event.dart';
part 'scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final UserRepository userRepository;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  Location location = new Location();
  BluetoothState blueToothState = BluetoothState.unknown;
  bool locationServiceEnabled;
  PermissionStatus permissionGranted;

  ScanBloc({@required this.userRepository}) : assert(userRepository != null);

  @override
  ScanState get initialState => ScanInitial();

  @override
  Stream<ScanState> mapEventToState(ScanEvent event) async* {
    if (event is GetPermission) {
      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          yield PermissionRejected();
          return;
        }
      }
      yield PermissionGranted();
    } else if (event is StartScanning) {
      try {
        locationServiceEnabled = await location.serviceEnabled();
        blueToothState = await flutterBlue.state;
        if (blueToothState == BluetoothState.off || !locationServiceEnabled) {
          yield ScanServiceDisabled();
          return;
        }
      } catch (error) {
        yield ScanningFailed(error: error.toString());
        return;
      }
      try {
        User user = await userRepository.getUser();
        yield ScanningStarted(uuid: user.uid);
      } catch (error) {
        yield ScanningFailed(error: error.toString());
      }
    } else if (event is AddDevice) {
      yield ProximityDetected(device: {
        "id": event.id,
        "type": event.type,
        "location": event.location,
        "timestamp": event.timestamp
      });
    } else if (event is StartListening) {
      yield Scanning();
    } else {
      yield ScanningStopped();
    }
  }
}
