part of 'scan_bloc.dart';

abstract class ScanState extends Equatable {
  const ScanState() : super();

  @override
  List<Object> get props => [];
}

class ScanInitial extends ScanState {}

class GettingPermission extends ScanState {}

class PermissionGranted extends ScanState {}

class PermissionRejected extends ScanState {}

class ScanServiceDisabled extends ScanState {}

class ScanServiceEnabled extends ScanState {}

class Scanning extends ScanState {}


class ScanningStarted extends ScanState {
  final String uuid;
  const ScanningStarted({@required this.uuid}): assert(uuid != null);
}

class ProximityDetected extends ScanState {
  final Map<dynamic, dynamic> device;
  const ProximityDetected({@required this.device}) : assert(device != null);

  @override
  List<Object> get props => [device];
}

class ScanningStopped extends ScanState {}

class ScanningFailed extends ScanState {
  final String error;

  const ScanningFailed({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ScanningFailed { error: $error }';
}
