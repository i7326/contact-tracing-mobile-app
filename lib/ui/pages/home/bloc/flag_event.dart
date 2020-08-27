part of 'flag_bloc.dart';

abstract class FlagEvent extends Equatable {
  const FlagEvent();
}

class AddFlag extends FlagEvent {
  final int timestamp;
  final String type;

  const AddFlag({
    @required this.timestamp,
    @required this.type,
  });

  @override
  List<Object> get props => [timestamp, type];

  @override
  String toString() =>
      'AddFlag { timestamp: $timestamp, type: $type }';
}

class FetchFlag extends FlagEvent {
  const FetchFlag();

  @override
  List<Object> get props => [];
}