part of 'scan_bloc.dart';

abstract class ScanEvent extends Equatable {
  const ScanEvent();
}

class StartScanning extends ScanEvent {
  const StartScanning();

  @override
  List<Object> get props => [];
}

class GetPermission extends ScanEvent {
  const GetPermission();

  @override
  List<Object> get props => [];
}

class AddDevice extends ScanEvent {
  final int timestamp;
  final String type;
  final String id;
  final String location;

  const AddDevice(
      {@required this.timestamp,
      @required this.type,
      @required this.id,
      @required this.location});

  @override
  List<Object> get props => [timestamp, type, id, location];

  @override
  String toString() => 'AddDevice { timestamp: $timestamp, type: $type, id: $id, location: $location }';
}

class EnableScanService extends ScanEvent {
  const EnableScanService();

  @override
  List<Object> get props => [];
}

class StartListening extends ScanEvent {
  const StartListening();

  @override
  List<Object> get props => [];
}

class StopScanning extends ScanEvent {
  const StopScanning();

  @override
  List<Object> get props => [];
}
