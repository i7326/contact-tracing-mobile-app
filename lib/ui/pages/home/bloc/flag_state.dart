part of 'flag_bloc.dart';

abstract class FlagState extends Equatable {
  const FlagState();

  @override
  List<Object> get props => [];
}

class FlagNotLoaded extends FlagState {}

class SavingFlag extends FlagState {}

class SavingCompleted extends FlagState {}

class FlagEmpty extends FlagState {}

class FlagLoading extends FlagState {}

class FlagLoaded extends FlagState {
  final Flag flag;
  const FlagLoaded({@required this.flag}) : assert(flag != null);

  @override
  List<Object> get props => [flag];
}

class LoadFailure extends FlagState {
  final String error;

  const LoadFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'LoadFailure { error: $error }';
}

class SaveFailure extends FlagState {
  final String error;

  const SaveFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'SaveFailure { error: $error }';
}