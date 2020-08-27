import 'dart:async';

import 'package:coloc/model/flag.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:coloc/flag_repository/flag_repository.dart';
import 'package:coloc/user_repository/user_repositor.dart';

part 'flag_event.dart';
part 'flag_state.dart';

class FlagBloc extends Bloc<FlagEvent, FlagState> {
  final FlagRepository flagRepository;
  final UserRepository userRepository;

  FlagBloc({@required this.flagRepository, @required this.userRepository})
      : assert(flagRepository != null),
        assert(userRepository != null);

  @override
  FlagState get initialState => FlagNotLoaded();

  @override
  Stream<FlagState> mapEventToState(FlagEvent event) async* {
    if (event is FetchFlag) {
      yield FlagLoading();
      try {
        final Flag flag =
            await flagRepository.fetchFlag(await userRepository.getToken());
        if (flag == null) {
          yield FlagEmpty();
          return;
        }
        yield FlagLoaded(flag: flag);
      } catch (error) {
        yield LoadFailure(error: error.toString());
      }
    } else if (event is AddFlag) {
      try {
        yield SavingFlag();
        final token = await userRepository.getToken();
        final response = await flagRepository.saveFlag(
            Flag.fromJson({"type": event.type, "timestamp": event.timestamp}),
            token);
        yield SavingCompleted();
      } catch (error) {
        yield SaveFailure(error: error.toString());
      }
    }
  }
}
