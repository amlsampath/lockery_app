import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mylockery/locker_app/model/locker_model.dart';
import 'package:mylockery/locker_app/repository/locker_repository.dart';


part 'locker_event.dart';
part 'locker_state.dart';

class LockerBloc extends Bloc<LockerEvent, LockerState> {
  final LockerRepository _lockerRepository;
  StreamSubscription? _lockerSubscription;
  LockerBloc({required LockerRepository lockerRepository})
      : _lockerRepository = lockerRepository,
        super(LockerLoading()) {
    on<LoadLocker>((event, emit) async {
      emit(LockerLoading());
      try {
        List<LockerModel> list = await _lockerRepository.getAllLoker();
        emit(LokerLoaded(lockers: list));
      } catch (e) {
        print(e);
      }
    });
  }
}
